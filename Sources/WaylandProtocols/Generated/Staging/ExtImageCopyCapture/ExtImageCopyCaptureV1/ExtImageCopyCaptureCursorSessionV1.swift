import Foundation
import SwiftWayland

public final class ExtImageCopyCaptureCursorSessionV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_image_copy_capture_cursor_session_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getCaptureSession() throws(WaylandProxyError) -> ExtImageCopyCaptureSessionV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let session = connection.createProxy(type: ExtImageCopyCaptureSessionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(session.id)
        ])
        connection.send(message: message)
        return session
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case duplicateSession = 1
    }
    
    public enum Event: WlEventEnum {
        case enter
        case leave
        case position(x: Int32, y: Int32)
        case hotspot(x: Int32, y: Int32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.enter
            case 1:
                return Self.leave
            case 2:
                return Self.position(x: r.readInt(), y: r.readInt())
            case 3:
                return Self.hotspot(x: r.readInt(), y: r.readInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
