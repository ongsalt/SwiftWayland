import Foundation

/// Create Desktop-Style Surfaces
/// 
/// This interface is implemented by servers that provide
/// desktop-style user interfaces.
/// It allows clients to associate a wl_shell_surface with
/// a basic surface.
/// Note! This protocol is deprecated and not intended for production use.
/// For desktop-style user interfaces, use xdg_shell. Compositors and clients
/// should not implement this interface.
public final class WlShell: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_shell"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create A Shell Surface From A Surface
    /// 
    /// Create a shell surface for an existing surface. This gives
    /// the wl_surface the role of a shell surface. If the wl_surface
    /// already has another role, it raises a protocol error.
    /// Only one shell surface can be associated with a given surface.
    /// 
    /// - Parameters:
    ///   - Surface: surface to be given the shell surface role
    public func getShellSurface(surface: WlSurface) throws(WaylandProxyError) -> WlShellSurface {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlShellSurface.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        /// Given Wl_Surface Has Another Role
        case role = 0
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
