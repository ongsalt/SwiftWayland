public class EventQueue: Identifiable {
    private var queue: [(ObjectId, any WaylandEvent)] = []
    private unowned let connection: Connection

    public init(connection: Connection) {
        self.connection = connection
    }

    package func enqueue(_ event: any WaylandEvent, receiver: ObjectId) {
        queue.append((receiver, event))
    }

    public func dispatch() async throws {
        try await connection.plsReadAndPutMessageIntoQueues()

        let flushed = queue
        queue = []
        for (id, event) in flushed {
            guard let proxy = connection.get(id: id) else {
                print("[Wayland] Unknown receiver, object might be deallocated \(event)")
                continue
            }

            proxy.dispatch(event: event)
        }
    }

    public func roundtrip() async throws {
        var shouldStop = false
        try connection.display.sync { _ in
            shouldStop = true
        }
        try await connection.flush()
        while !shouldStop {
            try await self.dispatch()
        }
    }
}
