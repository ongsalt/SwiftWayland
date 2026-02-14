import Foundation

/// The Compositor Singleton
/// 
/// A compositor.  This object is a singleton global.  The
/// compositor is in charge of combining the contents of multiple
/// surfaces into one displayable output.
public final class WlCompositor: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_compositor"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create New Surface
    /// 
    /// Ask the compositor to create a new surface.
    public func createSurface() throws(WaylandProxyError) -> WlSurface {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlSurface.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Create New Region
    /// 
    /// Ask the compositor to create a new region.
    public func createRegion() throws(WaylandProxyError) -> WlRegion {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlRegion.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
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
