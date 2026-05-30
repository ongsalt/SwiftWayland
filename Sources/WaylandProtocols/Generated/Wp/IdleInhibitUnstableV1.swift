import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// Control Behavior When Display Idles
/// 
/// This interface permits inhibiting the idle behavior such as screen
/// blanking, locking, and screensaving.  The client binds the idle manager
/// globally, then creates idle-inhibitor objects for each surface.
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZwpIdleInhibitManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_idle_inhibit_manager_v1",
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
                    name: "create_inhibitor",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_idle_inhibitor_v1"
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
    /// Destroy The Idle Inhibitor Object
    /// 
    /// Destroy the inhibit manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A New Inhibitor Object
    /// 
    /// Create a new inhibitor object associated with the given surface.
    /// 
    /// - Parameters:
    ///   - surface: the surface that inhibits the idle behavior
    public func createInhibitor(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpIdleInhibitorV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpIdleInhibitorV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: IdleInhibitUnstableV1)
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
/// Context Object For Inhibiting Idle Behavior
/// 
/// An idle inhibitor prevents the output that the associated surface is
/// visible on from being set to a state where it is not visually usable due
/// to lack of user interaction (e.g. blanked, dimmed, locked, set to power
/// save, etc.)  Any screensaver processes are also blocked from displaying.
/// If the surface is destroyed, unmapped, becomes occluded, loses
/// visibility, or otherwise becomes not visually relevant for the user, the
/// idle inhibitor will not be honored by the compositor; if the surface
/// subsequently regains visibility the inhibitor takes effect once again.
/// Likewise, the inhibitor isn't honored if the system was already idled at
/// the time the inhibitor was established, although if the system later
/// de-idles and re-idles the inhibitor will take effect.
public final class ZwpIdleInhibitorV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_idle_inhibitor_v1",
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
    /// Destroy The Idle Inhibitor Object
    /// 
    /// Remove the inhibitor effect from the associated wl_surface.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: IdleInhibitUnstableV1)
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

public let IdleInhibitUnstableV1 = Protocol(
        name: "idle_inhibit_unstable_v1",
        interfaces: [
            ZwpIdleInhibitManagerV1.interface,
ZwpIdleInhibitorV1.interface
        ]
    )

#endif