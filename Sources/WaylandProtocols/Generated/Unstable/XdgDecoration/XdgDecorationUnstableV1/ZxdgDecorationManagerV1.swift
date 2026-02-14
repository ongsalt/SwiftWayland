import Foundation
import SwiftWayland

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
public final class ZxdgDecorationManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_decoration_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Decoration Manager Object
    /// 
    /// Destroy the decoration manager. This doesn't destroy objects created
    /// with the manager.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A New Toplevel Decoration Object
    /// 
    /// Create a new decoration object associated with the given toplevel.
    /// Creating an xdg_toplevel_decoration from an xdg_toplevel which has a
    /// buffer attached or committed is a client error, and any attempts by a
    /// client to attach or manipulate a buffer prior to the first
    /// xdg_toplevel_decoration.configure event must also be treated as
    /// errors.
    public func getToplevelDecoration(toplevel: XdgToplevel) throws(WaylandProxyError) -> ZxdgToplevelDecorationV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZxdgToplevelDecorationV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(toplevel)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
