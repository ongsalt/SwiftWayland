import Foundation
import SwiftWayland

public final class ExtOutputImageCaptureSourceManagerV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func createSource(output: WlOutput) -> ExtImageCaptureSourceV1 {
        let source = connection.createProxy(type: ExtImageCaptureSourceV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(source.id),
            .object(output)
        ])
        connection.queueSend(message: message)
        return source
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
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
