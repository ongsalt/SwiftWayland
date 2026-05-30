import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if STAGING
/// Fractional Surface Scale Information
/// 
/// A global interface for requesting surfaces to use fractional scales.
public final class WpFractionalScaleManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_fractional_scale_manager_v1",
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
                    name: "get_fractional_scale",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wp_fractional_scale_v1"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Unbind The Fractional Surface Scale Interface
    /// 
    /// Informs the server that the client will not be using this protocol
    /// object anymore. This does not affect any other objects,
    /// wp_fractional_scale_v1 objects included.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Extend Surface Interface For Scale Information
    /// 
    /// Create an add-on object for the the wl_surface to let the compositor
    /// request fractional scales. If the given wl_surface already has a
    /// wp_fractional_scale_v1 object associated, the fractional_scale_exists
    /// protocol error is raised.
    /// 
    /// - Parameters:
    ///   - surface: the surface
    /// 
    /// - Returns: the new surface scale info interface id
    public func getFractionalScale(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpFractionalScaleV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpFractionalScaleV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: FractionalScaleV1)
    }
    
    public enum Error: UInt32 {
        /// the surface already has a fractional_scale object associated
        case fractionalScaleExists = 0
    }

    public typealias Event = NoEvent
}
/// Fractional Scale Interface To A Wl_Surface
/// 
/// An additional interface to a wl_surface object which allows the compositor
/// to inform the client of the preferred scale.
public final class WpFractionalScaleV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_fractional_scale_v1",
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
                    name: "preferred_scale",
                    arguments: [
                    Argument(
                        name: "scale",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
    /// Remove Surface Scale Information For Surface
    /// 
    /// Destroy the fractional scale object. When this object is destroyed,
    /// preferred_scale events will no longer be sent.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: FractionalScaleV1)
    }
    
    public enum Event: Decodable {
        /// Notify Of New Preferred Scale
        /// 
        /// Notification of a new preferred scale for this surface that the
        /// compositor suggests that the client should use.
        /// The sent scale is the numerator of a fraction with a denominator of 120.
        case preferredScale(scale: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.preferredScale(scale: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let FractionalScaleV1 = Protocol(
        name: "fractional_scale_v1",
        interfaces: [
            WpFractionalScaleManagerV1.interface,
WpFractionalScaleV1.interface
        ]
    )

#endif