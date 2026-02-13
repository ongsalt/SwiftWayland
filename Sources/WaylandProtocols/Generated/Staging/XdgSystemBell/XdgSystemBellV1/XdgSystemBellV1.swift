import Foundation
import SwiftWayland

public final class XdgSystemBellV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_system_bell_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func ring(surface: WlSurface) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(surface)
        ])
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
