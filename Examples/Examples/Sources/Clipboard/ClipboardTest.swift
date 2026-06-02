import Foundation
import SwiftWayland
import WaylandProtocols

// Demonstrates fd passing in both directions:
//   Send:    compositor calls wl_data_source.send → we write to the fd
//   Receive: we call wl_data_offer.receive with a pipe → read from the other end
final class ClipboardTest {
    let connection: Connection

    private var compositor: WlCompositor?
    private var seat: WlSeat?
    private var dataDeviceManager: WlDataDeviceManager?
    private var xdgWmBase: XdgWmBase?

    private var surface: WlSurface?
    private var xdgSurface: XdgSurface?
    private var toplevel: XdgToplevel?
    private var buffer: WlBuffer?
    private var bufferData: UnsafeMutableRawPointer?

    private var keyboard: WlKeyboard?
    private var dataDevice: WlDataDevice?
    private var dataSource: WlDataSource?

    private let content = "Hello from SwiftWayland fd test! 🌊"
    private let mime = "text/plain;charset=utf-8"

    private var didSetClipboard = false
    private var pendingOffer: WlDataOffer?
    private var pendingMimes: [String] = []

    init(connection: Connection) {
        self.connection = connection
    }

    func start() throws {
        let globals = try Globals(connection: connection)
        connection.roundtrip()

        compositor        = try globals.bind(to: WlCompositor.self,        version: 6...6)
        xdgWmBase         = try globals.bind(to: XdgWmBase.self,           version: 6...7)
        seat              = try globals.bind(to: WlSeat.self,              version: 7...9)
        dataDeviceManager = try globals.bind(to: WlDataDeviceManager.self, version: 3...3)

        xdgWmBase!.onEvent = { [weak self] ev in
            if case .ping(let serial) = ev { try! self?.xdgWmBase?.pong(serial: serial) }
        }

        guard let compositor, let xdgWmBase, let seat, let dataDeviceManager else {
            fatalError("Missing required globals")
        }

        // Minimal window — we need a surface to receive keyboard focus
        surface    = try compositor.createSurface()
        xdgSurface = try xdgWmBase.getXdgSurface(surface: surface!)
        toplevel   = try xdgSurface!.getToplevel()
        try toplevel!.setTitle("SwiftWayland Clipboard Test")
        toplevel!.onEvent = { event in if case .close = event { exit(0) } }

        xdgSurface!.onEvent = { [weak self] event in
            guard let self, case .configure(let serial) = event else { return }
            try! self.xdgSurface!.ackConfigure(serial: serial)
            try! self.surface!.attach(buffer: self.buffer, x: 0, y: 0)
            try! self.surface!.commit()
        }

        // 1x1 opaque buffer — just enough to be a visible window
        buffer = try makeMinimalBuffer(shm: globals.bind(to: WlShm.self, version: 1...2),
                                       data: &bufferData)

        // Data device — listens for incoming clipboard offers
        dataDevice = try dataDeviceManager.getDataDevice(seat: seat)
        dataDevice!.onEvent = { [weak self] event in
            guard let self else { return }
            switch event {
            case .dataOffer(let offer):
                self.pendingOffer = offer
                self.pendingMimes = []
                offer.onEvent = { [weak self] ev in
                    if case .offer(let m) = ev { self?.pendingMimes.append(m) }
                }
            case .selection:
                self.onSelectionChanged()
            default:
                break
            }
        }

        // Keyboard — we need a key serial to call set_selection
        seat.onEvent = { [weak self] event in
            guard let self else { return }
            if case .capabilities(let caps) = event, caps.contains(.keyboard) {
                self.keyboard = try! seat.getKeyboard()
                self.keyboard!.onEvent = { [weak self] kev in self?.handleKeyboard(kev) }
            }
        }

        try surface!.commit()
        connection.roundtrip()
        connection.roundtrip()
    }

    private func handleKeyboard(_ event: WlKeyboard.Event) {
        switch event {
        case .enter(let serial, _, _):
            guard !didSetClipboard else { break }
            didSetClipboard = true
            setClipboard(serial: serial)
        case .key(let serial, _, _, let state) where state == .pressed:
            // Pressing any key re-sets the clipboard with a fresh serial
            setClipboard(serial: serial)
        default:
            break
        }
    }

    // MARK: - fd send direction

    private func setClipboard(serial: UInt32) {
        guard let dataDeviceManager, let dataDevice else { return }
        dataSource = try! dataDeviceManager.createDataSource()
        try! dataSource!.offer(mimeType: mime)
        try! dataSource!.offer(mimeType: "text/plain")

        dataSource!.onEvent = { [weak self] event in
            guard let self else { return }
            switch event {
            case .send(let requestedMime, let fd):
                // Compositor (or another app) is requesting the data.
                // We write our content to the provided fd — this is fd SENDING.
                print("[Send] Compositor requested '\(requestedMime)' via fd \(fd.fileDescriptor)")
                let bytes = self.content.data(using: .utf8)!
                fd.write(bytes)
                try? fd.close()
                print("[Send] Wrote \(bytes.count) bytes: \"\(self.content)\"")
            case .cancelled:
                print("[Send] Selection cancelled (another app took the clipboard)")
                self.dataSource = nil
            default:
                break
            }
        }

        try! dataDevice.setSelection(source: dataSource!, serial: serial)
        print("[Send] Clipboard set. Copy something from another app to test receive.")
    }

    // MARK: - fd receive direction

    private func onSelectionChanged() {
        guard let offer = pendingOffer,
              pendingMimes.contains(mime) || pendingMimes.contains("text/plain") else {
            print("[Receive] New selection has no text mime types, ignoring")
            return
        }
        let targetMime = pendingMimes.contains(mime) ? mime : "text/plain"

        // Create a pipe. We pass the write end to the compositor;
        // it writes the data and closes its copy. We read from the read end.
        var fds = [Int32](repeating: 0, count: 2)
        pipe(&fds)
        let readEnd  = FileHandle(fileDescriptor: fds[0], closeOnDealloc: true)
        let writeEnd = FileHandle(fileDescriptor: fds[1], closeOnDealloc: true)

        // This is fd RECEIVING — we hand the write end to the compositor.
        print("[Receive] Requesting '\(targetMime)' via pipe write-fd \(writeEnd.fileDescriptor)")
        try! offer.receive(mimeType: targetMime, fd: writeEnd)

        // Close our copy of the write end so we'll see EOF after the compositor closes its copy.
        try? writeEnd.close()

        // Flush so the compositor gets the receive request and starts writing.
        connection.flush()

        DispatchQueue.global().async {
            let data = readEnd.readDataToEndOfFile()
            let text = String(data: data, encoding: .utf8) ?? "<\(data.count) binary bytes>"
            print("[Receive] Got \(data.count) bytes from fd \(readEnd.fileDescriptor): \"\(text)\"")
        }
    }

    // MARK: - Helpers

    private func makeMinimalBuffer(shm: WlShm, data: inout UnsafeMutableRawPointer?) throws -> WlBuffer {
        let size = 4  // 1x1 XRGB
        let name = "/swiftwayland-clipboard-\(UUID().uuidString)"
        let fd = shm_open(name, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR)
        if fd == -1 { fatalError("shm_open failed") }
        _ = shm_unlink(name)
        ftruncate(fd, off_t(size))
        data = mmap(nil, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0)
        data?.storeBytes(of: UInt32(0xFF_00_00_00), as: UInt32.self)
        let file = FileHandle(fileDescriptor: fd, closeOnDealloc: true)
        let pool = try shm.createPool(fd: file, size: Int32(size))
        return try pool.createBuffer(offset: 0, width: 1, height: 1, stride: 4, format: .xrgb8888)
    }
}
