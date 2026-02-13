import Foundation
import SwiftWayland

public final class ZwpInputTimestampsManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_input_timestamps_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getKeyboardTimestamps(keyboard: WlKeyboard) -> ZwpInputTimestampsV1 {
        let id = connection.createProxy(type: ZwpInputTimestampsV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(keyboard)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func getPointerTimestamps(pointer: WlPointer) -> ZwpInputTimestampsV1 {
        let id = connection.createProxy(type: ZwpInputTimestampsV1.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id),
            .object(pointer)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func getTouchTimestamps(touch: WlTouch) -> ZwpInputTimestampsV1 {
        let id = connection.createProxy(type: ZwpInputTimestampsV1.self)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .newId(id.id),
            .object(touch)
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
