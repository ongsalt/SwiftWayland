import Foundation
import SwiftWayland

public final class ZxdgImporterV2: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func importToplevel(handle: String) -> ZxdgImportedV2 {
        let id = connection.createProxy(type: ZxdgImportedV2.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .string(handle)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
