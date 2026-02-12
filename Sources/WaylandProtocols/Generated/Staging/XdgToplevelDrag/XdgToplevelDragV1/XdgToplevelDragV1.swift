import Foundation
import SwiftWayland

public final class XdgToplevelDragV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func attach(toplevel: XdgToplevel, xOffset: Int32, yOffset: Int32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(toplevel),
            .int(xOffset),
            .int(yOffset)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case toplevelAttached = 0
        case ongoingDrag = 1
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
