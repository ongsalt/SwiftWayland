// dispatch()
// read fd -> put message to (every) queue -> dispatch (this queue)
// should not block

public class EventQueue: Identifiable {
    private var queue: [(ObjectId, any WaylandEvent)] = []
    private unowned let connection: Connection

    public init(connection: Connection) {
        self.connection = connection
    }

    package func enqueue(_ event: any WaylandEvent, receiver: ObjectId) {
        queue.append((receiver, event))
    }

    // public func dispatch(wait: Bool = false) throws {
    //     // trigger read
    //     try connection.plsReadAndPutMessageIntoQueues(wait: wait)

    //     let flushed = queue
    //     queue = []
    //     for (id, event) in flushed {
    //         guard let proxy = connection.get(id: id) else {
    //             print("[Wayland] Unknown receiver, object might be deallocated \(event)")
    //             continue
    //         }

    //         proxy.dispatch(event: event)
    //     }
    // }

    public func dispatchAsync() async throws {
        try await connection.plsReadAndPutMessageIntoQueuesAsync()

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

    // public func roundtrip() throws {
    //     var shouldStop = false
    //     try connection.display.sync { _ in
    //         shouldStop = true
    //     }
    //     try connection.flush()
    //     while !shouldStop {
    //         try self.dispatch(wait: true)
    //     }
    // }

    public func roundtripAsync() async throws {
        var shouldStop = false
        try connection.display.sync { _ in
            shouldStop = true
        }
        try await connection.flushAsync()
        while !shouldStop {
            try await self.dispatchAsync()
        }
    }
}
