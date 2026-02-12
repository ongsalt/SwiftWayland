import Foundation
import SwiftWayland

public final class ExtTransientSeatManagerV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func create() -> ExtTransientSeatV1 {
        let seat = connection.createProxy(type: ExtTransientSeatV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(seat.id)
        ])
        connection.queueSend(message: message)
        return seat
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
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
