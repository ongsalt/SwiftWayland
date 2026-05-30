import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if STAGING
/// Context Object For Xwayland Shell
/// 
/// xwayland_shell_v1 is a singleton global object that
/// provides the ability to create a xwayland_surface_v1 object
/// for a given wl_surface.
/// This interface is intended to be bound by the Xwayland server.
/// A compositor must not allow clients other than Xwayland to
/// bind to this interface. A compositor should hide this global
/// from other clients' wl_registry.
/// A client the compositor does not consider to be an Xwayland
/// server attempting to bind this interface will result in
/// an implementation-defined error.
/// An Xwayland server that has bound this interface must not
/// set the `WL_SURFACE_ID` atom on a window.
public final class XwaylandShellV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xwayland_shell_v1",
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
                    name: "get_xwayland_surface",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "xwayland_surface_v1"
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
    /// Destroy The Xwayland Shell Object
    /// 
    /// Destroy the xwayland_shell_v1 object.
    /// The child objects created via this interface are unaffected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Assign The Xwayland_Surface Surface Role
    /// 
    /// Create an xwayland_surface_v1 interface for a given wl_surface
    /// object and gives it the xwayland_surface role.
    /// 
    /// It is illegal to create an xwayland_surface_v1 for a wl_surface
    /// which already has an assigned role and this will result in the
    /// `role` protocol error.
    /// See the documentation of xwayland_surface_v1 for more details
    /// about what an xwayland_surface_v1 is and how it is used.
    /// 
    /// - Parameters:
    public func getXwaylandSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XwaylandSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XwaylandSurfaceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XwaylandShellV1)
    }
    
    public enum Error: UInt32 {
        /// given wl_surface has another role
        case role = 0
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
/// Interface For Associating Xwayland Windows To Wl_Surfaces
/// 
/// An Xwayland surface is a surface managed by an Xwayland server.
/// It is used for associating surfaces to Xwayland windows.
/// The Xwayland server associated with actions in this interface is
/// determined by the Wayland client making the request.
/// The client must call wl_surface.commit on the corresponding wl_surface
/// for the xwayland_surface_v1 state to take effect.
public final class XwaylandSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xwayland_surface_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "set_serial",
                    arguments: [
                    Argument(
                        name: "serial_lo",
                        type: .uint,
                    ),
                    Argument(
                        name: "serial_hi",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Associates A Xwayland Window To A Wl_Surface
    /// 
    /// Associates an Xwayland window to a wl_surface.
    /// The association state is double-buffered, see wl_surface.commit.
    /// The `serial_lo` and `serial_hi` parameters specify a non-zero
    /// monotonic serial number which is entirely unique and provided by the
    /// Xwayland server equal to the serial value provided by a client message
    /// with a message type of the `WL_SURFACE_SERIAL` atom on the X11 window
    /// for this surface to be associated to.
    /// The serial value in the `WL_SURFACE_SERIAL` client message is specified
    /// as having the lo-bits specified in `l[0]` and the hi-bits specified
    /// in `l[1]`.
    /// If the serial value provided by `serial_lo` and `serial_hi` is not
    /// valid, the `invalid_serial` protocol error will be raised.
    /// An X11 window may be associated with multiple surfaces throughout its
    /// lifespan. (eg. unmapping and remapping a window).
    /// 
    /// For each wl_surface, this state must not be committed more than once,
    /// otherwise the `already_associated` protocol error will be raised.
    /// 
    /// - Parameters:
    ///   - serialLo: The lower 32-bits of the serial number associated with the X11 window
    ///   - serialHi: The upper 32-bits of the serial number associated with the X11 window
    public func setSerial(serialLo: UInt32, serialHi: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(serialLo),
            .uint(serialHi),
        ])
    }

    /// Destroy The Xwayland Surface Object
    /// 
    /// Destroy the xwayland_surface_v1 object.
    /// Any already existing associations are unaffected by this action.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XwaylandShellV1)
    }
    
    public enum Error: UInt32 {
        /// given wl_surface is already associated with an X11 window
        case alreadyAssociated = 0

        /// serial was not valid
        case invalidSerial = 1
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

public let XwaylandShellV1 = Protocol(
        name: "xwayland_shell_v1",
        interfaces: [
            XwaylandShellV1.interface,
XwaylandSurfaceV1.interface
        ]
    )

#endif