import Foundation
import Testing

@testable import WaylandClient

// Requires a running Wayland compositor ($WAYLAND_DISPLAY must be set).
@Suite(.serialized, .enabled(if: ProcessInfo.processInfo.environment["WAYLAND_DISPLAY"] != nil))
struct EventQueueTests {

    @Test("objects created with a queue are assigned to that queue")
    func proxyIsAssignedToQueue() throws {
        let connection = Connection()
        let queue = connection.createEventQueue(name: "test-queue")

        let registry = try connection.display.getRegistry(queue: queue)
        #expect(registry.queue === queue)

        // The parent stays on the main queue
        #expect(connection.display.queue === connection.mainQueue)
    }

    @Test("events on a custom queue are only dispatched by that queue")
    func eventsDispatchOnOwnQueue() throws {
        let connection = Connection()
        let queue = connection.createEventQueue(name: "test-queue")

        var done = false
        try connection.display.sync(callback: { _ in done = true }, queue: queue)

        // Reads the reply off the socket, but must not dispatch it
        connection.roundtrip()
        #expect(!done)

        queue.dispatchPending()
        #expect(done)
    }

    @Test("registry globals arrive through queue roundtrip")
    func registryOnQueue() throws {
        let connection = Connection()
        let queue = connection.createEventQueue()

        let registry = try connection.display.getRegistry(queue: queue)
        var globals: [String] = []
        registry.onEvent = { event in
            if case .global(_, let interface, _) = event {
                globals.append(interface)
            }
        }

        queue.roundtrip()
        #expect(globals.contains("wl_compositor"))
    }

    @Test("main queue is unaffected by wrapper creation")
    func mainQueueStillWorks() throws {
        let connection = Connection()
        let queue = connection.createEventQueue()

        var onQueue = false
        var onMain = false
        try connection.display.sync(callback: { _ in onQueue = true }, queue: queue)
        try connection.display.sync(callback: { _ in onMain = true })

        connection.roundtrip()
        #expect(onMain)
        #expect(!onQueue)

        queue.dispatchPending()
        #expect(onQueue)
    }
}
