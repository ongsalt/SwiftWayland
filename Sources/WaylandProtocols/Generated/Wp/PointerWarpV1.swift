import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// Reposition The Pointer To A Location On A Surface
/// 
/// This global interface allows applications to request the pointer to be
/// moved to a position relative to a wl_surface.
/// Note that if the desired behavior is to constrain the pointer to an area
/// or lock it to a position, this protocol does not provide a reliable way
/// to do that. The pointer constraint and pointer lock protocols should be
/// used for those use cases instead.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpPointerWarpV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_pointer_warp_v1",
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
                    name: "warp_pointer",
                    arguments: [
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    Argument(
                        name: "pointer",
                        type: .object,
                        interface: "wl_pointer"
                    ),
                    Argument(
                        name: "x",
                        type: .fixed,
                    ),
                    Argument(
                        name: "y",
                        type: .fixed,
                    ),
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Warp Manager
    /// 
    /// Destroy the pointer warp manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Reposition The Pointer
    /// 
    /// Request the compositor to move the pointer to a surface-local position.
    /// Whether or not the compositor honors the request is implementation defined,
    /// but it should
    /// - honor it if the surface has pointer focus, including
    /// when it has an implicit pointer grab
    /// - reject it if the enter serial is incorrect
    /// - reject it if the requested position is outside of the surface
    /// Note that the enter serial is valid for any surface of the client,
    /// and does not have to be from the surface the pointer is warped to.
    /// 
    /// - Parameters:
    ///   - surface: surface to position the pointer on
    ///   - pointer: the pointer that should be repositioned
    ///   - serial: serial number of the enter event
    public func warpPointer(surface: WlSurface, pointer: WlPointer, x: Double, y: Double, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface.id),
            .object(pointer.id),
            .fixed(x),
            .fixed(y),
            .uint(serial),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: PointerWarpV1Protocol)
    }
    
    var destructor: Destructor? = .destroy

    enum Destructor {
        case destroy
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .destroy: try? self.destroy()
                case nil: break
            }
        }
    }

    public typealias Event = NoEvent
}

public let PointerWarpV1Protocol = Protocol(
        name: "pointer_warp_v1",
        interfaces: [
            WpPointerWarpV1.interface
        ]
    )

#endif