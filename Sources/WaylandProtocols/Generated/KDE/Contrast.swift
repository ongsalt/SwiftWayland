import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
public final class KdeContrastManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_contrast_manager",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "create",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "org_kde_kwin_contrast"
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
                ],
            events: [
                ],
        )
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeContrast {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeContrast.self, version: self.version, queue: _queue ?? self.queue)
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
        CRuntimeInfo.shared.addIfNotExists(protocol: ContrastProtocol)
    }
    
    public typealias Event = NoEvent
}
public final class KdeContrast: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_contrast",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "commit",
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_region",
                    arguments: [
                    Argument(
                        name: "region",
                        type: .object,
                        interface: "wl_region"
                    ),
                    ],
                ),
                Message(
                    name: "set_contrast",
                    arguments: [
                    Argument(
                        name: "contrast",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "set_intensity",
                    arguments: [
                    Argument(
                        name: "intensity",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "set_saturation",
                    arguments: [
                    Argument(
                        name: "saturation",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_frost",
                    arguments: [
                    Argument(
                        name: "red",
                        type: .int,
                    ),
                    Argument(
                        name: "green",
                        type: .int,
                    ),
                    Argument(
                        name: "blue",
                        type: .int,
                    ),
                    Argument(
                        name: "alpha",
                        type: .int,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "unset_frost",
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
    public func setRegion(_ region: WlRegion? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(region?.id ?? 0),
        ])
    }

    /// 
    /// - Parameters:
    public func setContrast(_ contrast: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .fixed(contrast),
        ])
    }

    /// 
    /// - Parameters:
    public func setIntensity(_ intensity: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .fixed(intensity),
        ])
    }

    /// 
    /// - Parameters:
    public func setSaturation(_ saturation: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .fixed(saturation),
        ])
    }

    /// Release The Contrast Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 5, [
        ])
    }

    /// Opt Into Frost Effect W/ Given Colour
    /// 
    /// enables 'frost' variant of contrast effect.
    /// 'frost' is an enhanced version of the contrast effect that
    /// uses different colour arithmetic to get backgrounds simultaneously
    /// higher in contrast and (apparent) transparency.
    /// r, g, b, a are channels from 0-255, indicating a colour to use in contrast calculation.
    /// should be based off of the "main" background colour of the surface.
    /// 
    /// - Parameters:
    public func setFrost(red: Int32, green: Int32, blue: Int32, alpha: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 6, [
            .int(red),
            .int(green),
            .int(blue),
            .int(alpha),
        ])
    }

    /// Opts Out Of Frost Effect
    /// 
    /// 
    public func unsetFrost() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 7, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ContrastProtocol)
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

public let ContrastProtocol = Protocol(
        name: "contrast",
        interfaces: [
            KdeContrastManager.interface,
KdeContrast.interface
        ]
    )

#endif