import Foundation
import SwiftWayland

public final class XdgWmDialogV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getXdgDialog(toplevel: XdgToplevel) -> XdgDialogV1 {
        let id = connection.createProxy(type: XdgDialogV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(toplevel)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case alreadyUsed = 0
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
