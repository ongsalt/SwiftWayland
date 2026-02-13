import Foundation
import SwiftWayland

public final class WpSecurityContextV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_security_context_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func setSandboxEngine(name: String) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .string(name)
        ])
        connection.send(message: message)
    }
    
    public func setAppId(appId: String) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .string(appId)
        ])
        connection.send(message: message)
    }
    
    public func setInstanceId(instanceId: String) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .string(instanceId)
        ])
        connection.send(message: message)
    }
    
    public func commit() {
        let message = Message(objectId: self.id, opcode: 4, contents: [])
        connection.send(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case alreadyUsed = 1
        case alreadySet = 2
        case invalidMetadata = 3
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
