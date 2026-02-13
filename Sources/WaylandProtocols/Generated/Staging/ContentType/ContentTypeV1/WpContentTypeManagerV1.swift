import Foundation
import SwiftWayland

public final class WpContentTypeManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_content_type_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getSurfaceContentType(surface: WlSurface) -> WpContentTypeV1 {
        let id = connection.createProxy(type: WpContentTypeV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case alreadyConstructed = 0
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
