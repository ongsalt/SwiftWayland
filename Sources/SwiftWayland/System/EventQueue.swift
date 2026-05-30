import CWayland

public final class EventQueue: @unchecked Sendable {
    let raw: OpaquePointer
    let isMain: Bool
    weak var connection: Connection?

    init(raw: OpaquePointer, connection: Connection? = nil, isMain: Bool = false) {
        self.raw = raw
        self.connection = connection
        self.isMain = isMain
    }

    /// Dispatch pending events for this queue. Called by the external event loop.
    @discardableResult
    public func dispatchPending() -> Int32 {
        guard let conn = connection else { return -1 }
        return wl_display_dispatch_queue_pending(conn.rawDisplay, raw)
    }

    /// Create a child queue on the same display.
    public func createChildQueue() -> EventQueue? {
        guard let conn = connection else { return nil }
        return EventQueue(raw: wl_display_create_queue(conn.rawDisplay), connection: conn)
    }

    deinit {
        guard !isMain else { return }
        wl_event_queue_destroy(raw)
    }
}
