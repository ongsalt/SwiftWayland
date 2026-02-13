import Foundation
import SwiftWayland

public final class ZxdgImportedV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_imported_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setParentOf(surface: WlSurface) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(surface)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case destroyed
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.destroyed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
