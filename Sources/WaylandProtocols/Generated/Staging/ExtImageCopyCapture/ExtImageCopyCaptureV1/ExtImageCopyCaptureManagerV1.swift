import Foundation
import SwiftWayland

public final class ExtImageCopyCaptureManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_image_copy_capture_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func createSession(source: ExtImageCaptureSourceV1, options: UInt32) -> ExtImageCopyCaptureSessionV1 {
        let session = connection.createProxy(type: ExtImageCopyCaptureSessionV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(session.id),
            .object(source),
            .uint(options)
        ])
        connection.queueSend(message: message)
        return session
    }
    
    public func createPointerCursorSession(source: ExtImageCaptureSourceV1, pointer: WlPointer) -> ExtImageCopyCaptureCursorSessionV1 {
        let session = connection.createProxy(type: ExtImageCopyCaptureCursorSessionV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(session.id),
            .object(source),
            .object(pointer)
        ])
        connection.queueSend(message: message)
        return session
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidOption = 1
    }
    
    public enum Options: UInt32, WlEnum {
        case paintCursors = 1
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
