import Foundation
import SwiftWayland

public final class ExtForeignToplevelImageCaptureSourceManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_foreign_toplevel_image_capture_source_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func createSource(toplevelHandle: ExtForeignToplevelHandleV1) -> ExtImageCaptureSourceV1 {
        let source = connection.createProxy(type: ExtImageCaptureSourceV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(source.id),
            .object(toplevelHandle)
        ])
        connection.send(message: message)
        return source
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
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
