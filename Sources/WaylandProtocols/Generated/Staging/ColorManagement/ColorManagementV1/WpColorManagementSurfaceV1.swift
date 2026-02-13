import Foundation
import SwiftWayland

public final class WpColorManagementSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_management_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setImageDescription(imageDescription: WpImageDescriptionV1, renderIntent: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(imageDescription),
            .uint(renderIntent)
        ])
        connection.queueSend(message: message)
    }
    
    public func unsetImageDescription() {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case renderIntent = 0
        case imageDescription = 1
        case inert = 2
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
