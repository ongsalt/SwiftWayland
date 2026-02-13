import Foundation
import SwiftWayland

public final class XdgPopup: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_popup"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case popupDone
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.popupDone
            default:
                fatalError("Unknown message")
            }
        }
    }
}
