import Foundation
import SwiftWayland

public final class ZwpInputPanelSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_input_panel_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func setToplevel(output: WlOutput, position: UInt32) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .object(output),
            .uint(position)
        ])
        connection.send(message: message)
    }
    
    public func setOverlayPanel() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    public enum Position: UInt32, WlEnum {
        case centerBottom = 0
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
