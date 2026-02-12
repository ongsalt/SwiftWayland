import Foundation
import SwiftWayland

public final class ZwpKeyboardShortcutsInhibitorV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case active
        case inactive
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.active
            case 1:
                return Self.inactive
            default:
                fatalError("Unknown message")
            }
        }
    }
}
