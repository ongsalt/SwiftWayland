import Foundation
import SwiftWayland

public final class WpSecurityContextManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_security_context_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func createListener(listenFd: FileHandle, closeFd: FileHandle) -> WpSecurityContextV1 {
        let id = connection.createProxy(type: WpSecurityContextV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .fd(listenFd),
            .fd(closeFd)
        ])
        connection.send(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidListenFd = 1
        case nested = 2
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
