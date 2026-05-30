import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if XWAYLAND
/// Context Object For Keyboard Grab Manager
/// 
/// A global interface used for grabbing the keyboard.
public final class ZwpXwaylandKeyboardGrabManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_xwayland_keyboard_grab_manager_v1",
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
                    name: "grab_keyboard",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_xwayland_keyboard_grab_v1",
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface",
                    ),
                    Argument(
                        name: "seat",
                        type: .object,
                        interface: "wl_seat",
                    ),
                    ],
                ),
                ],
            events: [
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
        let id = connection.createProxy(type: ZwpXwaylandKeyboardGrabV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
            .object(seat.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XwaylandKeyboardGrabUnstableV1Protocol)
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
/// Interface For Grabbing The Keyboard
/// 
/// A global interface used for grabbing the keyboard.
public final class ZwpXwaylandKeyboardGrabV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_xwayland_keyboard_grab_v1",
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

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XwaylandKeyboardGrabUnstableV1Protocol)
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

public let XwaylandKeyboardGrabUnstableV1Protocol = Protocol(
        name: "xwayland_keyboard_grab_unstable_v1",
        interfaces: [
            ZwpXwaylandKeyboardGrabManagerV1.interface,
ZwpXwaylandKeyboardGrabV1.interface
        ]
    )

#endif