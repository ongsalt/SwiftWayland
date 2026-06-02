import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
public final class KdeBlurManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_blur_manager",
            version: 1,
            requests: [
                Message(
                    name: "create",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_blur",
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                    ],
                ),
                Message(
                    name: "unset",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                    ],
                ),
            ],
        )
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeBlur {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeBlur.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    /// 
    /// - Parameters:
    public func unset(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface.id),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: BlurProtocol)
    }
    
    public typealias Event = NoEvent
}

public final class KdeBlur: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_blur",
            version: 1,
            requests: [
                Message(
                    name: "commit",
                    arguments: [],
                ),
                Message(
                    name: "set_region",
                    arguments: [
                        Argument(
                            name: "region",
                            type: .object,
                            interface: "wl_region",
                            nullable: true,
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
    public func commit() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// 
    /// - Parameters:
    public func setRegion(_ region: WlRegion? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(region?.id ?? 0),
        ])
    }

    /// Release The Blur Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 2, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: BlurProtocol)
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


public let BlurProtocol = Protocol(
        name: "blur",
        interfaces: [
            KdeBlurManager.interface,
KdeBlur.interface
        ]
    )

#endif