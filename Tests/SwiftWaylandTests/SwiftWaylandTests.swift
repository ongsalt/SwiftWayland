import Testing
import Foundation
@testable import WaylandClient
import WaylandProtocols

@Test func `It must at least run`() async throws {
    let connection = try! Connection.fromEnv()

    let display = connection.display!
    let registry = try display.getRegistry()

    await confirmation { confirm in
        registry.onEvent = { event in
            switch event {
            case .global(_, let interface, _) where interface == WlDisplay.name:
                confirm()
            default:
                break
            }
        }
        try! connection.roundtrip()
    }
}

// Integration tests for Wayland fd passing via the clipboard protocol.
// Requires a running Wayland compositor ($WAYLAND_DISPLAY must be set).
//
// Two connections are used:
//   sender   — owns the data source; writes to the fd on wl_data_source.send
//   receiver — holds the data offer; creates a pipe, hands write end to compositor,
//              reads from the read end

@Suite(.serialized, .enabled(if: ProcessInfo.processInfo.environment["WAYLAND_DISPLAY"] != nil))
struct ClipboardTests {

    @Test("fd round-trip via wl_data_source / wl_data_offer")
    func fdRoundTrip() throws {
        let text = "SwiftWayland fd test \(UUID().uuidString)"
        let mime = "text/plain;charset=utf-8"

        // MARK: - Sender setup

        let sConn = Connection()
        let sGlobals = try Globals(connection: sConn)
        sConn.roundtrip()

        let sSeat = try sGlobals.bind(to: WlSeat.self, version: 7...9)
        let sDDM  = try sGlobals.bind(to: WlDataDeviceManager.self, version: 3...3)
        let sDD   = try sDDM.getDataDevice(seat: sSeat)

        let source = try sDDM.createDataSource()
        try source.offer(mimeType: mime)

        var sendCount = 0
        source.onEvent = { event in
            if case .send(_, let fd) = event {
                sendCount += 1
                fd.write(text.data(using: .utf8)!)
                try? fd.close()
            }
        }

        // serial 0 is accepted by most compositors for programmatic clipboard writes
        try sDD.setSelection(source: source, serial: 0)
        sConn.roundtrip()

        // MARK: - Receiver setup

        let rConn = Connection()
        let rGlobals = try Globals(connection: rConn)
        rConn.roundtrip()

        let rSeat = try rGlobals.bind(to: WlSeat.self, version: 7...9)
        let rDDM  = try rGlobals.bind(to: WlDataDeviceManager.self, version: 3...3)
        let rDD   = try rDDM.getDataDevice(seat: rSeat)

        var receivedText: String? = nil
        var pendingOffer: WlDataOffer? = nil

        rDD.onEvent = { event in
            switch event {
            case .dataOffer(let offer):
                pendingOffer = offer
            case .selection:
                guard let offer = pendingOffer else { break }
                var fds = [Int32](repeating: 0, count: 2)
                pipe(&fds)
                let readEnd  = FileHandle(fileDescriptor: fds[0], closeOnDealloc: true)
                let writeEnd = FileHandle(fileDescriptor: fds[1], closeOnDealloc: true)
                try! offer.receive(mimeType: mime, fd: writeEnd)
                try? writeEnd.close()
                rConn.flush()
                let data = readEnd.readDataToEndOfFile()
                receivedText = String(data: data, encoding: .utf8)
            default:
                break
            }
        }

        rConn.roundtrip()

        // MARK: - Drive both event loops until data arrives or timeout

        let deadline = Date().addingTimeInterval(3)
        while receivedText == nil && Date() < deadline {
            tick(sConn)
            tick(rConn)
        }

        // MARK: - Assert

        let got = try #require(receivedText, "No data received — compositor may reject serial=0 for set_selection")
        #expect(got == text)
        #expect(sendCount == 1, "Expected exactly one send request, got \(sendCount)")
    }
}

private func tick(_ connection: Connection) {
    if connection.prepareRead() { connection.readEvents() }
    connection.dispatchPending()
    connection.flush()
}
