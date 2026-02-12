import Foundation
import SwiftWayland

public final class WpSecurityContextManagerV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func createListener(listenFd: FileHandle, closeFd: FileHandle) -> WpSecurityContextV1 {
        let id = connection.createProxy(type: WpSecurityContextV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .fd(listenFd),
            .fd(closeFd)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidListenFd = 1
        case nested = 2
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
