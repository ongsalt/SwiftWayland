import Foundation
import SwiftWayland

public final class WpSecurityContextV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setSandboxEngine(name: String) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .string(name)
        ])
        connection.queueSend(message: message)
    }
    
    public func setAppId(appId: String) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .string(appId)
        ])
        connection.queueSend(message: message)
    }
    
    public func setInstanceId(instanceId: String) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .string(instanceId)
        ])
        connection.queueSend(message: message)
    }
    
    public func commit() {
        let message = Message(objectId: self.id, opcode: 4, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case alreadyUsed = 1
        case alreadySet = 2
        case invalidMetadata = 3
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
