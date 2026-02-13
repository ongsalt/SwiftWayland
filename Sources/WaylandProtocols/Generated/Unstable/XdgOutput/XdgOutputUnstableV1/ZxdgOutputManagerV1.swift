import Foundation
import SwiftWayland

public final class ZxdgOutputManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_output_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getXdgOutput(output: WlOutput) throws(WaylandProxyError) -> ZxdgOutputV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZxdgOutputV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(output)
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
