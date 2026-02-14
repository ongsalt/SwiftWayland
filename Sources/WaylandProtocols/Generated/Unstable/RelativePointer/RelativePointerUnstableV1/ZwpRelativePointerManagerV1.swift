import Foundation
import SwiftWayland

/// Get Relative Pointer Objects
/// 
/// A global interface used for getting the relative pointer object for a
/// given pointer.
public final class ZwpRelativePointerManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_relative_pointer_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Relative Pointer Manager Object
    /// 
    /// Used by the client to notify the server that it will no longer use this
    /// relative pointer manager object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Get A Relative Pointer Object
    /// 
    /// Create a relative pointer interface given a wl_pointer object. See the
    /// wp_relative_pointer interface for more details.
    public func getRelativePointer(pointer: WlPointer) throws(WaylandProxyError) -> ZwpRelativePointerV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpRelativePointerV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(pointer)
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
