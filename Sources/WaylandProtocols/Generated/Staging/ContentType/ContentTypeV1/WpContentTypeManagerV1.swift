import Foundation
import SwiftWayland

/// Surface Content Type Manager
/// 
/// This interface allows a client to describe the kind of content a surface
/// will display, to allow the compositor to optimize its behavior for it.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpContentTypeManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_content_type_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Content Type Manager Object
    /// 
    /// Destroy the content type manager. This doesn't destroy objects created
    /// with the manager.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A New Content Type Object
    /// 
    /// Create a new content type object associated with the given surface.
    /// Creating a wp_content_type_v1 from a wl_surface which already has one
    /// attached is a client error: already_constructed.
    public func getSurfaceContentType(surface: WlSurface) throws(WaylandProxyError) -> WpContentTypeV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpContentTypeV1.self, version: self.version)
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
        /// Wl_Surface Already Has A Content Type Object
        case alreadyConstructed = 0
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
