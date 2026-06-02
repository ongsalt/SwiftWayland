import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Server Side Decoration Palette Manager Interface
/// 
/// This interface allows a client to alter the palette of a server side decoration.
public final class KdeServerDecorationPaletteManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_server_decoration_palette_manager",
            version: 1,
            requests: [
                Message(
                    name: "create",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_server_decoration_palette",
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
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeServerDecorationPalette {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeServerDecorationPalette.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ServerDecorationPaletteProtocol)
    }
    
    public typealias Event = NoEvent
}

/// Server Side Decoration Palette Interface
/// 
/// This interface allows a client to alter the palette of a server side decoration.
public final class KdeServerDecorationPalette: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_server_decoration_palette",
            version: 1,
            requests: [
                Message(
                    name: "set_palette",
                    arguments: [
                        Argument(
                            name: "palette",
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
    /// Set A On The Server Side Window Decoration
    /// 
    /// Color scheme that should be applied to the window decoration.
    /// Absolute file path, or name of palette in the user's config directory.
    /// The server may choose not to follow the requested style.
    /// 
    /// - Parameters:
    ///   - _: Absolute file path, or name of palette in the user's config directory
    public func setPalette(_ palette: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(palette),
        ])
    }

    /// Release The Palette Object
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
        CRuntimeInfo.shared.addIfNotExists(protocol: ServerDecorationPaletteProtocol)
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


public let ServerDecorationPaletteProtocol = Protocol(
        name: "server_decoration_palette",
        interfaces: [
            KdeServerDecorationPaletteManager.interface,
KdeServerDecorationPalette.interface
        ]
    )

#endif