import Foundation
import SwiftWayland

/// Context Object For Input Timestamps
/// 
/// Provides high-resolution timestamp events for a set of subscribed input
/// events. The set of subscribed input events is determined by the
/// zwp_input_timestamps_manager_v1 request used to create this object.
public final class ZwpInputTimestampsV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_input_timestamps_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Input Timestamps Object
    /// 
    /// Informs the server that the client will no longer be using this
    /// protocol object. After the server processes the request, no more
    /// timestamp events will be emitted.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// High-Resolution Timestamp Event
        /// 
        /// The timestamp event is associated with the first subsequent input event
        /// carrying a timestamp which belongs to the set of input events this
        /// object is subscribed to.
        /// The timestamp provided by this event is a high-resolution version of
        /// the timestamp argument of the associated input event. The provided
        /// timestamp is in the same clock domain and is at least as accurate as
        /// the associated input event timestamp.
        /// The timestamp is expressed as tv_sec_hi, tv_sec_lo, tv_nsec triples,
        /// each component being an unsigned 32-bit value. Whole seconds are in
        /// tv_sec which is a 64-bit value combined from tv_sec_hi and tv_sec_lo,
        /// and the additional fractional part in tv_nsec as nanoseconds. Hence,
        /// for valid timestamps tv_nsec must be in [0, 999999999].
        /// 
        /// - Parameters:
        ///   - TvSecHi: high 32 bits of the seconds part of the timestamp
        ///   - TvSecLo: low 32 bits of the seconds part of the timestamp
        ///   - TvNsec: nanoseconds part of the timestamp
        case timestamp(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.timestamp(tvSecHi: r.readUInt(), tvSecLo: r.readUInt(), tvNsec: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
