import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if UNSTABLE
/// Window Decoration Manager
/// 
/// This interface allows a compositor to announce support for server-side
/// decorations.
/// A window decoration is a set of window controls as deemed appropriate by
/// the party managing them, such as user interface components used to move,
/// resize and change a window's state.
/// A client can use this protocol to request being decorated by a supporting
/// compositor.
/// If compositor and client do not negotiate the use of a server-side
/// decoration using this protocol, clients continue to self-decorate as they
/// see fit.
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZxdgDecorationManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_decoration_manager_v1",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "get_toplevel_decoration",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zxdg_toplevel_decoration_v1"
                    ),
                    Argument(
                        name: "toplevel",
                        type: .object,
                        interface: "xdg_toplevel"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Decoration Manager Object
    /// 
    /// Destroy the decoration manager. This doesn't destroy objects created
    /// with the manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A New Toplevel Decoration Object
    /// 
    /// Create a new decoration object associated with the given toplevel.
    /// For objects of version 1, creating an xdg_toplevel_decoration from an
    /// xdg_toplevel which has a buffer attached or committed is a client
    /// error, and any attempts by a client to attach or manipulate a buffer
    /// prior to the first xdg_toplevel_decoration.configure event must also be
    /// treated as errors.
    /// For objects of version 2 or newer, creating an xdg_toplevel_decoration
    /// from an xdg_toplevel which has a buffer attached or committed is
    /// allowed. The initial decoration mode of the surface if a buffer is
    /// already attached depends on whether a xdg_toplevel_decoration object
    /// has been associated with the surface or not prior to this request.
    /// If an xdg_toplevel_decoration was associated with the surface, then
    /// destroyed without a surface commit, the previous decoration mode is
    /// retained.
    /// If no xdg_toplevel_decoration was associated with the surface prior to
    /// this request, or if a surface commit has been performed after a previous
    /// xdg_toplevel_decoration object associated with the surface was
    /// destroyed, the decoration mode is assumed to be client-side.
    /// 
    /// - Parameters:
    public func getToplevelDecoration(toplevel: XdgToplevel, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZxdgToplevelDecorationV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZxdgToplevelDecorationV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(toplevel.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgDecorationUnstableV1)
    }
    
    public typealias Event = NoEvent
}
/// Decoration Object For A Toplevel Surface
/// 
/// The decoration object allows the compositor to toggle server-side window
/// decorations for a toplevel surface. The client can request to switch to
/// another mode.
/// The xdg_toplevel_decoration object must be destroyed before its
/// xdg_toplevel.
public final class ZxdgToplevelDecorationV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_toplevel_decoration_v1",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_mode",
                    arguments: [
                    Argument(
                        name: "mode",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "unset_mode",
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "configure",
                    arguments: [
                    Argument(
                        name: "mode",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
    /// Destroy The Decoration Object
    /// 
    /// Switch back to a mode without any server-side decorations at the next
    /// commit, unless a new xdg_toplevel_decoration is created for the surface
    /// first.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set The Decoration Mode
    /// 
    /// Set the toplevel surface decoration mode. This informs the compositor
    /// that the client prefers the provided decoration mode.
    /// After requesting a decoration mode, the compositor will respond by
    /// emitting an xdg_surface.configure event. The client should then update
    /// its content, drawing it without decorations if the received mode is
    /// server-side decorations. The client must also acknowledge the configure
    /// when committing the new content (see xdg_surface.ack_configure).
    /// The compositor can decide not to use the client's mode and enforce a
    /// different mode instead.
    /// Clients whose decoration mode depend on the xdg_toplevel state may send
    /// a set_mode request in response to an xdg_surface.configure event and wait
    /// for the next xdg_surface.configure event to prevent unwanted state.
    /// Such clients are responsible for preventing configure loops and must
    /// make sure not to send multiple successive set_mode requests with the
    /// same decoration mode.
    /// If an invalid mode is supplied by the client, the invalid_mode protocol
    /// error is raised by the compositor.
    /// 
    /// - Parameters:
    ///   - _: the decoration mode
    public func setMode(_ mode: Mode) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(mode.rawValue),
        ])
    }

    /// Unset The Decoration Mode
    /// 
    /// Unset the toplevel surface decoration mode. This informs the compositor
    /// that the client doesn't prefer a particular decoration mode.
    /// This request has the same semantics as set_mode.
    public func unsetMode() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgDecorationUnstableV1)
    }
    
    public enum Error: UInt32 {
        /// xdg_toplevel has a buffer attached before configure
        case unconfiguredBuffer = 0

        /// xdg_toplevel already has a decoration object
        case alreadyConstructed = 1

        /// xdg_toplevel destroyed before the decoration object
        case orphaned = 2

        /// invalid mode
        case invalidMode = 3
    }

    public enum Mode: UInt32 {
        /// no server-side window decoration
        case clientSide = 1

        /// server-side window decoration
        case serverSide = 2
    }

    public enum Event: Decodable {
        /// Notify A Decoration Mode Change
        /// 
        /// The configure event configures the effective decoration mode. The
        /// configured state should not be applied immediately. Clients must send an
        /// ack_configure in response to this event. See xdg_surface.configure and
        /// xdg_surface.ack_configure for details.
        /// A configure event can be sent at any time. The specified mode must be
        /// obeyed by the client.
        case configure(mode: Mode)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.configure(mode: try _parseEnum(into: Mode.self, r.uint()))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let XdgDecorationUnstableV1 = Protocol(
        name: "xdg_decoration_unstable_v1",
        interfaces: [
            ZxdgDecorationManagerV1.interface,
ZxdgToplevelDecorationV1.interface
        ]
    )

#endif