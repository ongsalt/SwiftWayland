import Foundation
import SwiftWayland

public final class WpColorManagementOutputV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getImageDescription() -> WpImageDescriptionV1 {
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(imageDescription.id)
        ])
        connection.queueSend(message: message)
        return imageDescription
    }
    
    public enum Event: WlEventEnum {
        case imageDescriptionChanged
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.imageDescriptionChanged
            default:
                fatalError("Unknown message")
            }
        }
    }
}
