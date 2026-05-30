import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Server Side Window Decoration Manager
/// 
/// This interface allows to coordinate whether the server should create
/// a server-side window decoration around a wl_surface representing a
/// shell surface (wl_shell_surface or similar). By announcing support
/// for this interface the server indicates that it supports server
/// side decorations.
/// Use in conjunction with zxdg_decoration_manager_v1 is undefined.
public final class KdeServerDecorationManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_server_decoration_manager",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "create",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "org_kde_kwin_server_decoration",
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface",
                    ),
                    ],
                ),
                ],
            events: [
                Message(
                    name: "default_mode",
                    arguments: [
                    Argument(
                        name: "mode",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
    /// Create A Server-Side Decoration Object For A Given Surface
    /// 
    /// When a client creates a server-side decoration object it indicates
    /// that it supports the protocol. The client is supposed to tell the
    /// server whether it wants server-side decorations or will provide
    /// client-side decorations.
    /// If the client does not create a server-side decoration object for
    /// a surface the server interprets this as lack of support for this
    /// protocol and considers it as client-side decorated. Nevertheless a
    /// client-side decorated surface should use this protocol to indicate
    /// to the server that it does not want a server-side deco.
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeServerDecoration {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeServerDecoration.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ServerDecorationProtocol)
    }
    
    public enum Mode: UInt32 {
        /// Undecorated: The surface is not decorated at all, neither server nor client-side. An example is a popup surface which should not be decorated.
        case `none` = 0

        /// Client-side decoration: The decoration is part of the surface and the client.
        case client = 1

        /// Server-side decoration: The server embeds the surface into a decoration frame.
        case server = 2
    }

    public enum Event: Decodable {
        /// The Default Mode Used On The Server
        /// 
        /// This event is emitted directly after binding the interface. It contains
        /// the default mode for the decoration. When a new server decoration object
        /// is created this new object will be in the default mode until the first
        /// request_mode is requested.
        /// The server may change the default mode at any time.
        case defaultMode(mode: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.defaultMode(mode: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
public final class KdeServerDecoration: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_server_decoration",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "request_mode",
                    arguments: [
                    Argument(
                        name: "mode",
                        type: .uint,
                    ),
                    ],
                ),
                ],
            events: [
                Message(
                    name: "mode",
                    arguments: [
                    Argument(
                        name: "mode",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
    /// Release The Server Decoration Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// The Decoration Mode The Surface Wants To Use.
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - mode: The mode this surface wants to use.
    public func requestMode(mode: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(mode),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ServerDecorationProtocol)
    }
    
    public enum Mode: UInt32 {
        /// Undecorated: The surface is not decorated at all, neither server nor client-side. An example is a popup surface which should not be decorated.
        case `none` = 0

        /// Client-side decoration: The decoration is part of the surface and the client.
        case client = 1

        /// Server-side decoration: The server embeds the surface into a decoration frame.
        case server = 2
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

    public enum Event: Decodable {
        /// The New Decoration Mode Applied By The Server
        /// 
        /// This event is emitted directly after the decoration is created and
        /// represents the base decoration policy by the server. E.g. a server
        /// which wants all surfaces to be client-side decorated will send Client,
        /// a server which wants server-side decoration will send Server.
        /// The client can request a different mode through the decoration request.
        /// The server will acknowledge this by another event with the same mode. So
        /// even if a server prefers server-side decoration it's possible to force a
        /// client-side decoration.
        /// The server may emit this event at any time. In this case the client can
        /// again request a different mode. It's the responsibility of the server to
        /// prevent a feedback loop.
        case mode(mode: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.mode(mode: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let ServerDecorationProtocol = Protocol(
        name: "server_decoration",
        interfaces: [
            KdeServerDecorationManager.interface,
KdeServerDecoration.interface
        ]
    )

#endif