import Foundation
import SwiftWayland

public final class ZwpTextInputManagerV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func createTextInput() -> ZwpTextInputV1 {
        let id = connection.createProxy(type: ZwpTextInputV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id)
        ])
        connection.queueSend(message: message)
        return id
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
