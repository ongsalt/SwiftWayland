import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if UNSTABLE
/// Get Relative Pointer Objects
/// 
/// A global interface used for getting the relative pointer object for a
/// given pointer.
public final class ZwpRelativePointerManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_relative_pointer_manager_v1",
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
                    name: "get_relative_pointer",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_relative_pointer_v1"
                    ),
                    Argument(
                        name: "pointer",
                        type: .object,
                        interface: "wl_pointer"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Relative Pointer Manager Object
    /// 
    /// Used by the client to notify the server that it will no longer use this
    /// relative pointer manager object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Get A Relative Pointer Object
    /// 
    /// Create a relative pointer interface given a wl_pointer object. See the
    /// wp_relative_pointer interface for more details.
    /// 
    /// - Parameters:
    public func getRelativePointer(pointer: WlPointer, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpRelativePointerV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpRelativePointerV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(pointer.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: RelativePointerUnstableV1)
    }
    
    public typealias Event = NoEvent
}
/// Relative Pointer Object
/// 
/// A wp_relative_pointer object is an extension to the wl_pointer interface
/// used for emitting relative pointer events. It shares the same focus as
/// wl_pointer objects of the same seat and will only emit events when it has
/// focus.
public final class ZwpRelativePointerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_relative_pointer_v1",
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
                    name: "relative_motion",
                    arguments: [
                    Argument(
                        name: "utime_hi",
                        type: .uint,
                    ),
                    Argument(
                        name: "utime_lo",
                        type: .uint,
                    ),
                    Argument(
                        name: "dx",
                        type: .fixed,
                    ),
                    Argument(
                        name: "dy",
                        type: .fixed,
                    ),
                    Argument(
                        name: "dx_unaccel",
                        type: .fixed,
                    ),
                    Argument(
                        name: "dy_unaccel",
                        type: .fixed,
                    ),
                    ],
                ),
                ],
        )
    /// Release The Relative Pointer Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: RelativePointerUnstableV1)
    }
    
    public enum Event: Decodable {
        /// Relative Pointer Motion
        /// 
        /// Relative x/y pointer motion from the pointer of the seat associated with
        /// this object.
        /// A relative motion is in the same dimension as regular wl_pointer motion
        /// events, except they do not represent an absolute position. For example,
        /// moving a pointer from (x, y) to (x', y') would have the equivalent
        /// relative motion (x' - x, y' - y). If a pointer motion caused the
        /// absolute pointer position to be clipped by for example the edge of the
        /// monitor, the relative motion is unaffected by the clipping and will
        /// represent the unclipped motion.
        /// This event also contains non-accelerated motion deltas. The
        /// non-accelerated delta is, when applicable, the regular pointer motion
        /// delta as it was before having applied motion acceleration and other
        /// transformations such as normalization.
        /// Note that the non-accelerated delta does not represent 'raw' events as
        /// they were read from some device. Pointer motion acceleration is device-
        /// and configuration-specific and non-accelerated deltas and accelerated
        /// deltas may have the same value on some devices.
        /// Relative motions are not coupled to wl_pointer.motion events, and can be
        /// sent in combination with such events, but also independently. There may
        /// also be scenarios where wl_pointer.motion is sent, but there is no
        /// relative motion. The order of an absolute and relative motion event
        /// originating from the same physical motion is not guaranteed.
        /// If the client needs button events or focus state, it can receive them
        /// from a wl_pointer object of the same seat that the wp_relative_pointer
        /// object is associated with.
        case relativeMotion(utimeHi: UInt32, utimeLo: UInt32, dx: Double, dy: Double, dxUnaccel: Double, dyUnaccel: Double)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.relativeMotion(utimeHi: r.uint(), utimeLo: r.uint(), dx: r.fixed(), dy: r.fixed(), dxUnaccel: r.fixed(), dyUnaccel: r.fixed())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let RelativePointerUnstableV1 = Protocol(
        name: "relative_pointer_unstable_v1",
        interfaces: [
            ZwpRelativePointerManagerV1.interface,
ZwpRelativePointerV1.interface
        ]
    )

#endif