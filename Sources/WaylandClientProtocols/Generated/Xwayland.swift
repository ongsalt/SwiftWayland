import Foundation
import WaylandClient

#if XWAYLAND
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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_xwayland_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "xwayland_surface_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
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
        let id = connection.sendConstructor(self, 1, XwaylandSurfaceV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = XwaylandShellV1Protocol
    
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
            requests: [
                Message(
                    name: "set_serial",
                    arguments: [
                        Argument(
                            name: "serial_lo",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "serial_hi",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
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

    
    public static let `protocol`: Protocol = XwaylandShellV1Protocol
    
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


public let XwaylandShellV1Protocol = Protocol(
        name: "xwayland_shell_v1",
        interfaces: [
            XwaylandShellV1.interface,
XwaylandSurfaceV1.interface
        ]
    )

/// Context Object For Keyboard Grab Manager
/// 
/// A global interface used for grabbing the keyboard.
public final class ZwpXwaylandKeyboardGrabManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_xwayland_keyboard_grab_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "grab_keyboard",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_xwayland_keyboard_grab_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Keyboard Grab Manager
    /// 
    /// Destroy the keyboard grab manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Grab The Keyboard To A Surface
    /// 
    /// The grab_keyboard request asks for a grab of the keyboard, forcing
    /// the keyboard focus for the given seat upon the given surface.
    /// The protocol provides no guarantee that the grab is ever satisfied,
    /// and does not require the compositor to send an error if the grab
    /// cannot ever be satisfied. It is thus possible to request a keyboard
    /// grab that will never be effective.
    /// The protocol:
    /// * does not guarantee that the grab itself is applied for a surface,
    /// the grab request may be silently ignored by the compositor,
    /// * does not guarantee that any events are sent to this client even
    /// if the grab is applied to a surface,
    /// * does not guarantee that events sent to this client are exhaustive,
    /// a compositor may filter some events for its own consumption,
    /// * does not guarantee that events sent to this client are continuous,
    /// a compositor may change and reroute keyboard events while the grab
    /// is nominally active.
    /// 
    /// - Parameters:
    ///   - surface: surface to report keyboard events to
    ///   - seat: the seat for which the keyboard should be grabbed
    public func grabKeyboard(surface: WlSurface, seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpXwaylandKeyboardGrabV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZwpXwaylandKeyboardGrabV1.self, version, _queue, [
            .newId,
            .object(surface),
            .object(seat),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = XwaylandKeyboardGrabUnstableV1Protocol
    
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

/// Interface For Grabbing The Keyboard
/// 
/// A global interface used for grabbing the keyboard.
public final class ZwpXwaylandKeyboardGrabV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_xwayland_keyboard_grab_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Grabbed Keyboard Object
    /// 
    /// Destroy the grabbed keyboard object. If applicable, the compositor
    /// will ungrab the keyboard.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = XwaylandKeyboardGrabUnstableV1Protocol
    
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


public let XwaylandKeyboardGrabUnstableV1Protocol = Protocol(
        name: "xwayland_keyboard_grab_unstable_v1",
        interfaces: [
            ZwpXwaylandKeyboardGrabManagerV1.interface,
ZwpXwaylandKeyboardGrabV1.interface
        ]
    )

#endif
