import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Appmenu Dbus Address Interface
/// 
/// This interface allows a client to link a window (or wl_surface) to an com.canonical.dbusmenu
/// interface registered on DBus.
public final class KdeAppmenuManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_appmenu_manager",
            version: 2,
            requests: [
                Message(
                    name: "create",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_appmenu",
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                    ],
                ),
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [],
                    since: 2
                ),
            ],
        )
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeAppmenu {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeAppmenu.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    /// Destroy The Org_Kde_Kwin_Appmenu_Manager Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: AppmenuProtocol)
    }
    
    var destructor: Destructor? = .release

    enum Destructor {
        case release
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .release: try? self.release()
                case nil: break
            }
        }
    }

    public typealias Event = NoEvent
}

/// Appmenu Dbus Address Interface
/// 
/// The DBus service name and object path where the appmenu interface is present
/// The object should be registered on the session bus before sending this request.
/// If not applicable, clients should remove this object.
public final class KdeAppmenu: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_appmenu",
            version: 2,
            requests: [
                Message(
                    name: "set_address",
                    arguments: [
                        Argument(
                            name: "service_name",
                            type: .string,
                        ),
                        Argument(
                            name: "object_path",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [],
                ),
            ],
        )
    /// Initialise Or Update The Location Of The Appmenu Interface
    /// 
    /// Set or update the service name and object path.
    /// Strings should be formatted in Latin-1 matching the relevant DBus specifications.
    /// 
    /// - Parameters:
    public func setAddress(serviceName: String, objectPath: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(serviceName),
            .string(objectPath),
        ])
    }

    /// Release The Appmenu Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: AppmenuProtocol)
    }
    
    var destructor: Destructor? = .release

    enum Destructor {
        case release
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .release: try? self.release()
                case nil: break
            }
        }
    }

    public typealias Event = NoEvent
}


public let AppmenuProtocol = Protocol(
        name: "appmenu",
        interfaces: [
            KdeAppmenuManager.interface,
KdeAppmenu.interface
        ]
    )

#endif