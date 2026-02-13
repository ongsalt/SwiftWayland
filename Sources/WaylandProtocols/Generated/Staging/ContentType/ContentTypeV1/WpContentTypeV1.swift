import Foundation
import SwiftWayland

public final class WpContentTypeV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_content_type_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func setContentType(contentType: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .uint(contentType)
        ])
        connection.send(message: message)
    }
    
    public enum `Type`: UInt32, WlEnum {
        case `none` = 0
        case photo = 1
        case video = 2
        case game = 3
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
