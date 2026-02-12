import Foundation
import SwiftWayland

public final class ZwpInputPanelSurfaceV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func setToplevel(output: WlOutput, position: UInt32) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .object(output),
            .uint(position)
        ])
        connection.queueSend(message: message)
    }
    
    public func setOverlayPanel() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Position: UInt32, WlEnum {
        case centerBottom = 0
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
