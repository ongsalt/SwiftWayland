import Foundation
import SwiftWayland

public final class ExtIdleNotifierV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getIdleNotification(timeout: UInt32, seat: WlSeat) -> ExtIdleNotificationV1 {
        let id = connection.createProxy(type: ExtIdleNotificationV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .uint(timeout),
            .object(seat)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func getInputIdleNotification(timeout: UInt32, seat: WlSeat) -> ExtIdleNotificationV1 {
        let id = connection.createProxy(type: ExtIdleNotificationV1.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id),
            .uint(timeout),
            .object(seat)
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
