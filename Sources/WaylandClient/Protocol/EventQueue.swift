import CWayland
import Glibc
import SwiftWaylandCommon

// Immutable; libwayland's queue functions are thread-safe.
public final class EventQueue: @unchecked Sendable {
    let raw: OpaquePointer
    // Keeps the display connected until this queue is destroyed.
    let connection: Connection

    var rawDisplay: OpaquePointer { connection.rawDisplay }

    init(raw: OpaquePointer, connection: Connection) {
        self.raw = raw
        self.connection = connection
    }

    public var name: String? {
        guard let ptr = wl_event_queue_get_name(raw) else { return nil }
        return String(cString: ptr)
    }

    /// Blocks until events arrive, then dispatches all pending events on this queue.
    @discardableResult
    public func dispatch() -> Int32 {
        wl_display_dispatch_queue(rawDisplay, raw)
    }

    /// Dispatches pending events on this queue without reading from the socket.
    @discardableResult
    public func dispatchPending() -> Int32 {
        wl_display_dispatch_queue_pending(rawDisplay, raw)
    }

    /// Dispatches events with a timeout. Returns event count, 0 on timeout, -1 on error.
    @discardableResult
    public func dispatch(timeout: Duration) -> Int32 {
        let (seconds, attoseconds) = timeout.components
        var ts = timespec(tv_sec: Int(seconds), tv_nsec: Int(attoseconds / 1_000_000_000))
        return wl_display_dispatch_queue_timeout(rawDisplay, raw, &ts)
    }

    /// Blocks until the server has processed all pending requests, dispatching on this queue.
    @discardableResult
    public func roundtrip() -> Int32 {
        wl_display_roundtrip_queue(rawDisplay, raw)
    }

    /// Prepares to read events into this queue. Returns nil if the queue is non-empty (EAGAIN).
    public func prepareRead() -> ReadGuard? {
        guard wl_display_prepare_read_queue(rawDisplay, raw) == 0 else { return nil }
        return ReadGuard(display: rawDisplay)
    }

    // Proxies retain their queue, so by now every proxy on it has been destroyed.
    // The default queue belongs to the display, which frees it on disconnect.
    deinit {
        if raw != connection.rawMainQueue {
            wl_event_queue_destroy(raw)
        }
    }
}
