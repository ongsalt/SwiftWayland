import Foundation
import SwiftWayland

public final class WpFractionalScaleManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_fractional_scale_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getFractionalScale(surface: WlSurface) -> WpFractionalScaleV1 {
        let id = connection.createProxy(type: WpFractionalScaleV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case fractionalScaleExists = 0
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
