import Foundation
import SwiftWayland

public final class ZwpTextInputManagerV3: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_text_input_manager_v3"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func getTextInput(seat: WlSeat) -> ZwpTextInputV3 {
        let id = connection.createProxy(type: ZwpTextInputV3.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(seat)
        ])
        connection.send(message: message)
        return id
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
