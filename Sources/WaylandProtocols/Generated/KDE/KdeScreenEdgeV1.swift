import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Screen Edge Manager
/// 
/// This interface allows clients to associate actions with screen edges. For
/// example, showing a surface by moving the pointer to a screen edge.
/// Potential ways to trigger the screen edge are subject to compositor
/// policies. As an example, the compositor may consider the screen edge to be
/// triggered if the pointer hits its associated screen border. Other ways may
/// include using touchscreen or touchpad gestures.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class KdeScreenEdgeManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_screen_edge_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "get_auto_hide_screen_edge",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "kde_auto_hide_screen_edge_v1",
                        ),
                        Argument(
                            name: "border",
                            type: .uint,
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                    ],
                ),
            ],
        )
    /// Destroy The Screen Edge Manager
    /// 
    /// Destroy the screen edge manager. This doesn't destroy objects created
    /// with this manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create An Auto Hide Edge
    /// 
    /// Create a new auto hide screen edge object associated with the specified
    /// surface and the border.
    /// Creating a kde_auto_hide_screen_edge_v1 object does not change the
    /// visibility of the surface. The kde_auto_hide_screen_edge_v1.activate
    /// request must be issued in order to hide the surface.
    /// The "border" argument must be a valid enum entry, otherwise the
    /// invalid_border protocol error is raised.
    /// The invalid_role protocol error will be raised if the specified surface
    /// does not have layer_surface role.
    /// 
    /// - Parameters:
    ///   - border: the associated screen border
    ///   - surface: the surface
    /// 
    /// - Returns: the new screen edge
    public func getAutoHideScreenEdge(border: Border, surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeAutoHideScreenEdgeV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeAutoHideScreenEdgeV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .uint(border.rawValue),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdeScreenEdgeV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// the specified border value is invalid
        case invalidBorder = 0

        /// the surface has invalid role
        case invalidRole = 1

        /// the surface already has a screen edge
        case alreadyConstructed = 2
    }

    public enum Border: UInt32 {
        /// top screen edge
        case top = 1

        /// bottom screen edge
        case bottom = 2

        /// left screen edge
        case `left` = 3

        /// right screen edge
        case `right` = 4
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

/// Auto Hide Screen Edge
/// 
/// The auto hide screen edge object allows to hide the surface and make it
/// visible by triggering the screen edge. The screen edge is inactive and
/// the surface is visible by default.
/// This interface can be used to implement user interface elements such as
/// auto-hide panels or docks.
/// kde_auto_hide_screen_edge_v1.activate activates the screen edge and makes
/// the surface hidden. The surface can be made visible by triggering the
/// screen edge or calling kde_auto_hide_screen_edge_v1.deactivate.
/// If the screen edge has been triggered, it won't be re-activated again.
/// Another kde_auto_hide_screen_edge_v1.activate request must be made by the
/// client to activate the screen edge.
public final class KdeAutoHideScreenEdgeV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_auto_hide_screen_edge_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "deactivate",
                    arguments: [],
                ),
                Message(
                    name: "activate",
                    arguments: [],
                ),
            ],
        )
    /// Destroy The Auto Hide Screen Edge Object
    /// 
    /// Destroy the auto hide screen edge object. If the screen edge is active,
    /// it will be deactivated and the surface will be made visible.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Deactivate The Screen Edge
    /// 
    /// Deactivate the screen edge. The surface will be made visible.
    public func deactivate() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    /// Activate The Screen Edge
    /// 
    /// Activate the screen edge. The surface will be hidden until the screen
    /// edge is triggered.
    public func activate() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdeScreenEdgeV1Protocol)
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


public let KdeScreenEdgeV1Protocol = Protocol(
        name: "kde_screen_edge_v1",
        interfaces: [
            KdeScreenEdgeManagerV1.interface,
KdeAutoHideScreenEdgeV1.interface
        ]
    )

#endif