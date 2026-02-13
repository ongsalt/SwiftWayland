import Foundation
import SwiftWayland

public final class ZwpKeyboardShortcutsInhibitorV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_keyboard_shortcuts_inhibitor_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public enum Event: WlEventEnum {
        case active
        case inactive
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
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
