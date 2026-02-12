import Foundation
import SwiftWayland

public final class WpFifoV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func setBarrier() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func waitBarrier() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case surfaceDestroyed = 0
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
