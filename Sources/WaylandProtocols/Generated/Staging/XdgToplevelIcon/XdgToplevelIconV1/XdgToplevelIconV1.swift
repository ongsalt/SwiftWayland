import Foundation
import SwiftWayland

public final class XdgToplevelIconV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setName(iconName: String) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .string(iconName)
        ])
        connection.queueSend(message: message)
    }
    
    public func addBuffer(buffer: WlBuffer, scale: Int32) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(buffer),
            .int(scale)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidBuffer = 1
        case immutable = 2
        case noBuffer = 3
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
