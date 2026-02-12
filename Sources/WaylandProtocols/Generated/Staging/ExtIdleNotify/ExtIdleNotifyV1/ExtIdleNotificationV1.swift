import Foundation
import SwiftWayland

public final class ExtIdleNotificationV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case idled
        case resumed
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.idled
            case 1:
                return Self.resumed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
