import Foundation
import SwiftWayland

public final class ExtImageCopyCaptureManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_image_copy_capture_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func createSession(source: ExtImageCaptureSourceV1, options: UInt32) throws(WaylandProxyError)  -> ExtImageCopyCaptureSessionV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let session = connection.createProxy(type: ExtImageCopyCaptureSessionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(session.id),
            .object(source),
            .uint(options)
        ])
        connection.send(message: message)
        return session
    }
    
    public func createPointerCursorSession(source: ExtImageCaptureSourceV1, pointer: WlPointer) throws(WaylandProxyError)  -> ExtImageCopyCaptureCursorSessionV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let session = connection.createProxy(type: ExtImageCopyCaptureCursorSessionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(session.id),
            .object(source),
            .object(pointer)
        ])
        connection.send(message: message)
        return session
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidOption = 1
    }
    
    public enum Options: UInt32, WlEnum {
        case paintCursors = 1
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
