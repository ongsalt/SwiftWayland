import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if UNSTABLE
/// Context Object For High-Resolution Input Timestamps
/// 
/// A global interface used for requesting high-resolution timestamps
/// for input events.
public final class ZwpInputTimestampsManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_input_timestamps_manager_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "get_keyboard_timestamps",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_input_timestamps_v1"
                    ),
                    Argument(
                        name: "keyboard",
                        type: .object,
                        interface: "wl_keyboard"
                    ),
                    ],
                ),
                Message(
                    name: "get_pointer_timestamps",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_input_timestamps_v1"
                    ),
                    Argument(
                        name: "pointer",
                        type: .object,
                        interface: "wl_pointer"
                    ),
                    ],
                ),
                Message(
                    name: "get_touch_timestamps",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_input_timestamps_v1"
                    ),
                    Argument(
                        name: "touch",
                        type: .object,
                        interface: "wl_touch"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Input Timestamps Manager Object
    /// 
    /// Informs the server that the client will no longer be using this
    /// protocol object. Existing objects created by this object are not
    /// affected.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Subscribe To High-Resolution Keyboard Timestamp Events
    /// 
    /// Creates a new input timestamps object that represents a subscription
    /// to high-resolution timestamp events for all wl_keyboard events that
    /// carry a timestamp.
    /// If the associated wl_keyboard object is invalidated, either through
    /// client action (e.g. release) or server-side changes, the input
    /// timestamps object becomes inert and the client should destroy it
    /// by calling zwp_input_timestamps_v1.destroy.
    /// 
    /// - Parameters:
    ///   - keyboard: the wl_keyboard object for which to get timestamp events
    ///   - queue: queue to associated with created objects
    public func getKeyboardTimestamps(keyboard: WlKeyboard, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpInputTimestampsV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpInputTimestampsV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(keyboard.id),
        ])
        return id
    }

    /// Subscribe To High-Resolution Pointer Timestamp Events
    /// 
    /// Creates a new input timestamps object that represents a subscription
    /// to high-resolution timestamp events for all wl_pointer events that
    /// carry a timestamp.
    /// If the associated wl_pointer object is invalidated, either through
    /// client action (e.g. release) or server-side changes, the input
    /// timestamps object becomes inert and the client should destroy it
    /// by calling zwp_input_timestamps_v1.destroy.
    /// 
    /// - Parameters:
    ///   - pointer: the wl_pointer object for which to get timestamp events
    ///   - queue: queue to associated with created objects
    public func getPointerTimestamps(pointer: WlPointer, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpInputTimestampsV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpInputTimestampsV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(id.id),
            .object(pointer.id),
        ])
        return id
    }

    /// Subscribe To High-Resolution Touch Timestamp Events
    /// 
    /// Creates a new input timestamps object that represents a subscription
    /// to high-resolution timestamp events for all wl_touch events that
    /// carry a timestamp.
    /// If the associated wl_touch object becomes invalid, either through
    /// client action (e.g. release) or server-side changes, the input
    /// timestamps object becomes inert and the client should destroy it
    /// by calling zwp_input_timestamps_v1.destroy.
    /// 
    /// - Parameters:
    ///   - touch: the wl_touch object for which to get timestamp events
    ///   - queue: queue to associated with created objects
    public func getTouchTimestamps(touch: WlTouch, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpInputTimestampsV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpInputTimestampsV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 3, [
            .object(id.id),
            .object(touch.id),
        ])
        return id
    }

    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: InputTimestampsUnstableV1)
    }
    public typealias Event = NoEvent
}
/// Context Object For Input Timestamps
/// 
/// Provides high-resolution timestamp events for a set of subscribed input
/// events. The set of subscribed input events is determined by the
/// zwp_input_timestamps_manager_v1 request used to create this object.
public final class ZwpInputTimestampsV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_input_timestamps_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "timestamp",
                    arguments: [
                    Argument(
                        name: "tv_sec_hi",
                        type: .uint,
                    ),
                    Argument(
                        name: "tv_sec_lo",
                        type: .uint,
                    ),
                    Argument(
                        name: "tv_nsec",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
    /// Destroy The Input Timestamps Object
    /// 
    /// Informs the server that the client will no longer be using this
    /// protocol object. After the server processes the request, no more
    /// timestamp events will be emitted.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: InputTimestampsUnstableV1)
    }
    public enum Event: Decodable {
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
        case timestamp(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.timestamp(tvSecHi: r.uint(), tvSecLo: r.uint(), tvNsec: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let InputTimestampsUnstableV1 = Protocol(
        name: "input_timestamps_unstable_v1",
        interfaces: [
            ZwpInputTimestampsManagerV1.interface,
ZwpInputTimestampsV1.interface
        ]
    )

#endif