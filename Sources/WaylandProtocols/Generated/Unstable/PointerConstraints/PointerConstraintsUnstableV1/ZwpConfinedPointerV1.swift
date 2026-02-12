import Foundation
import SwiftWayland

public final class ZwpConfinedPointerV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setRegion(region: WlRegion) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(region)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case confined
        case unconfined
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.confined
            case 1:
                return Self.unconfined
            default:
                fatalError("Unknown message")
            }
        }
    }
}
