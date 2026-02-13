import Foundation
import SwiftWayland

public final class WpTearingControlV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_tearing_control_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func setPresentationHint(hint: UInt32) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .uint(hint)
        ])
        connection.queueSend(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum PresentationHint: UInt32, WlEnum {
        case vsync = 0
        case `async` = 1
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
