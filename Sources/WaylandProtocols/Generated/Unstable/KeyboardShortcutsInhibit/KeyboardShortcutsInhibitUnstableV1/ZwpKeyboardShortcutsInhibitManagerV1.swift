import Foundation
import SwiftWayland

public final class ZwpKeyboardShortcutsInhibitManagerV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func inhibitShortcuts(surface: WlSurface, seat: WlSeat) -> ZwpKeyboardShortcutsInhibitorV1 {
        let id = connection.createProxy(type: ZwpKeyboardShortcutsInhibitorV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface),
            .object(seat)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case alreadyInhibited = 0
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
