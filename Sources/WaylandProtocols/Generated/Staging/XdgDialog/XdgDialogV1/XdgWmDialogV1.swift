import Foundation
import SwiftWayland

public final class XdgWmDialogV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_wm_dialog_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func getXdgDialog(toplevel: XdgToplevel) -> XdgDialogV1 {
        let id = connection.createProxy(type: XdgDialogV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(toplevel)
        ])
        connection.send(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case alreadyUsed = 0
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
