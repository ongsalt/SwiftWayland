import Foundation
import SwiftWayland

/// Fractional Surface Scale Information
/// 
/// A global interface for requesting surfaces to use fractional scales.
public final class WpFractionalScaleManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_fractional_scale_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Unbind The Fractional Surface Scale Interface
    /// 
    /// Informs the server that the client will not be using this protocol
    /// object anymore. This does not affect any other objects,
    /// wp_fractional_scale_v1 objects included.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Extend Surface Interface For Scale Information
    /// 
    /// Create an add-on object for the the wl_surface to let the compositor
    /// request fractional scales. If the given wl_surface already has a
    /// wp_fractional_scale_v1 object associated, the fractional_scale_exists
    /// protocol error is raised.
    /// 
    /// - Parameters:
    ///   - Surface: the surface
    public func getFractionalScale(surface: WlSurface) throws(WaylandProxyError) -> WpFractionalScaleV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpFractionalScaleV1.self, version: self.version)
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
        /// The Surface Already Has A Fractional_Scale Object Associated
        case fractionalScaleExists = 0
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
