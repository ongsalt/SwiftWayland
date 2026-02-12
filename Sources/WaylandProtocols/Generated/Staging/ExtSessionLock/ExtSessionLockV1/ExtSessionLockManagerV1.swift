import Foundation
import SwiftWayland

public final class ExtSessionLockManagerV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func lock() -> ExtSessionLockV1 {
        let id = connection.createProxy(type: ExtSessionLockV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
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
