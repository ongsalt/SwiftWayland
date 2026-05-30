import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
public final class KdeShadowManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_shadow_manager",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "create",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "org_kde_kwin_shadow"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "unset",
                    arguments: [
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 2
                ),
                ],
            events: [
                ],
        )
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeShadow {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeShadow.self, version: self.version, queue: _queue ?? self.queue)
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

    /// Destroy The Org_Kde_Kwin_Shadow_Manager
    /// 
    /// Destroy the org_kde_kwin_shadow_manager object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        self.markDead()
        connection.send(self, 2, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ShadowProtocol)
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
public final class KdeShadow: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_shadow",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "commit",
                    arguments: [
                    ],
                ),
                Message(
                    name: "attach_left",
                    arguments: [
                    Argument(
                        name: "buffer",
                        type: .object,
                        interface: "wl_buffer"
                    ),
                    ],
                ),
                Message(
                    name: "attach_top_left",
                    arguments: [
                    Argument(
                        name: "buffer",
                        type: .object,
                        interface: "wl_buffer"
                    ),
                    ],
                ),
                Message(
                    name: "attach_top",
                    arguments: [
                    Argument(
                        name: "buffer",
                        type: .object,
                        interface: "wl_buffer"
                    ),
                    ],
                ),
                Message(
                    name: "attach_top_right",
                    arguments: [
                    Argument(
                        name: "buffer",
                        type: .object,
                        interface: "wl_buffer"
                    ),
                    ],
                ),
                Message(
                    name: "attach_right",
                    arguments: [
                    Argument(
                        name: "buffer",
                        type: .object,
                        interface: "wl_buffer"
                    ),
                    ],
                ),
                Message(
                    name: "attach_bottom_right",
                    arguments: [
                    Argument(
                        name: "buffer",
                        type: .object,
                        interface: "wl_buffer"
                    ),
                    ],
                ),
                Message(
                    name: "attach_bottom",
                    arguments: [
                    Argument(
                        name: "buffer",
                        type: .object,
                        interface: "wl_buffer"
                    ),
                    ],
                ),
                Message(
                    name: "attach_bottom_left",
                    arguments: [
                    Argument(
                        name: "buffer",
                        type: .object,
                        interface: "wl_buffer"
                    ),
                    ],
                ),
                Message(
                    name: "set_left_offset",
                    arguments: [
                    Argument(
                        name: "offset",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "set_top_offset",
                    arguments: [
                    Argument(
                        name: "offset",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "set_right_offset",
                    arguments: [
                    Argument(
                        name: "offset",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "set_bottom_offset",
                    arguments: [
                    Argument(
                        name: "offset",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 2
                ),
                ],
            events: [
                ],
        )
    public func commit() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// 
    /// - Parameters:
    public func attachLeft(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachTopLeft(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachTop(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachTopRight(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachRight(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachBottomRight(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachBottom(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachBottomLeft(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func setLeftOffset(offset: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 9, [
            .fixed(offset),
        ])
    }

    /// 
    /// - Parameters:
    public func setTopOffset(offset: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 10, [
            .fixed(offset),
        ])
    }

    /// 
    /// - Parameters:
    public func setRightOffset(offset: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 11, [
            .fixed(offset),
        ])
    }

    /// 
    /// - Parameters:
    public func setBottomOffset(offset: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 12, [
            .fixed(offset),
        ])
    }

    /// Destroy The Org_Kde_Kwin_Shadow
    /// 
    /// Destroy the org_kde_kwin_shadow object. If the org_kde_kwin_shadow is
    /// still set on a wl_surface the shadow will be immediately removed.
    /// Prefer to first call the request unset on the org_kde_kwin_shadow_manager and
    /// commit the wl_surface to apply the change.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        self.markDead()
        connection.send(self, 13, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ShadowProtocol)
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

public let ShadowProtocol = Protocol(
        name: "shadow",
        interfaces: [
            KdeShadowManager.interface,
KdeShadow.interface
        ]
    )

#endif