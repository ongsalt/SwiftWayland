import CWayland
import Foundation
import SwiftWaylandCommon

public class EventQueue {
    var raw: OpaquePointer
    let rawDisplay: OpaquePointer

    init(raw: OpaquePointer, display: OpaquePointer) {
        self.raw = raw
        self.rawDisplay = display
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

    /// Prepares to read events into this queue. Returns false if the queue is non-empty (EAGAIN).
    @discardableResult
    public func prepareRead() -> Bool {
        wl_display_prepare_read_queue(rawDisplay, raw) == 0
    }

    public func destroy() {
        wl_event_queue_destroy(raw)
    }
}
