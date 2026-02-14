import Foundation
import SwiftWayland

/// Decoration Object For A Toplevel Surface
/// 
/// The decoration object allows the compositor to toggle server-side window
/// decorations for a toplevel surface. The client can request to switch to
/// another mode.
/// The xdg_toplevel_decoration object must be destroyed before its
/// xdg_toplevel.
public final class ZxdgToplevelDecorationV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_toplevel_decoration_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Decoration Object
    /// 
    /// Switch back to a mode without any server-side decorations at the next
    /// commit.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
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
    ///   - Mode: the decoration mode
    public func setMode(mode: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.uint(mode)
        ])
        connection.send(message: message)
    }
    
    /// Unset The Decoration Mode
    /// 
    /// Unset the toplevel surface decoration mode. This informs the compositor
    /// that the client doesn't prefer a particular decoration mode.
    /// This request has the same semantics as set_mode.
    public func unsetMode() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Xdg_Toplevel Has A Buffer Attached Before Configure
        case unconfiguredBuffer = 0
        
        /// Xdg_Toplevel Already Has A Decoration Object
        case alreadyConstructed = 1
        
        /// Xdg_Toplevel Destroyed Before The Decoration Object
        case orphaned = 2
        
        /// Invalid Mode
        case invalidMode = 3
    }
    
    /// Window Decoration Modes
    /// 
    /// These values describe window decoration modes.
    public enum Mode: UInt32, WlEnum {
        /// No Server-Side Window Decoration
        case clientSide = 1
        
        /// Server-Side Window Decoration
        case serverSide = 2
    }
    
    public enum Event: WlEventEnum {
        /// Notify A Decoration Mode Change
        /// 
        /// The configure event configures the effective decoration mode. The
        /// configured state should not be applied immediately. Clients must send an
        /// ack_configure in response to this event. See xdg_surface.configure and
        /// xdg_surface.ack_configure for details.
        /// A configure event can be sent at any time. The specified mode must be
        /// obeyed by the client.
        /// 
        /// - Parameters:
        ///   - Mode: the decoration mode
        case configure(mode: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(mode: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
