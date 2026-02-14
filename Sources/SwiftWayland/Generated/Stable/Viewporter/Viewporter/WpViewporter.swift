import Foundation

/// Surface Cropping And Scaling
/// 
/// The global interface exposing surface cropping and scaling
/// capabilities is used to instantiate an interface extension for a
/// wl_surface object. This extended interface will then allow
/// cropping and scaling the surface contents, effectively
/// disconnecting the direct relationship between the buffer and the
/// surface size.
public final class WpViewporter: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_viewporter"
    public var onEvent: (Event) -> Void = { _ in }

    /// Unbind From The Cropping And Scaling Interface
    /// 
    /// Informs the server that the client will not be using this
    /// protocol object anymore. This does not affect any other objects,
    /// wp_viewport objects included.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Extend Surface Interface For Crop And Scale
    /// 
    /// Instantiate an interface extension for the given wl_surface to
    /// crop and scale its content. If the given wl_surface already has
    /// a wp_viewport object associated, the viewport_exists
    /// protocol error is raised.
    /// 
    /// - Parameters:
    ///   - Surface: the surface
    public func getViewport(surface: WlSurface) throws(WaylandProxyError) -> WpViewport {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpViewport.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// The Surface Already Has A Viewport Object Associated
        case viewportExists = 0
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
