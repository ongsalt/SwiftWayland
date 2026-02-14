import Foundation
import SwiftWayland

/// Manage Xdg_Output Objects
/// 
/// A global factory interface for xdg_output objects.
public final class ZxdgOutputManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_output_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Xdg_Output_Manager Object
    /// 
    /// Using this request a client can tell the server that it is not
    /// going to use the xdg_output_manager object anymore.
    /// Any objects already created through this instance are not affected.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create An Xdg Output From A Wl_Output
    /// 
    /// This creates a new xdg_output object for the given wl_output.
    public func getXdgOutput(output: WlOutput) throws(WaylandProxyError) -> ZxdgOutputV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZxdgOutputV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(output)
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
