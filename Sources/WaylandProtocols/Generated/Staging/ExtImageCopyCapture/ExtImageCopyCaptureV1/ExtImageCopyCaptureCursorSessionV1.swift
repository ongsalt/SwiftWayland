import Foundation
import SwiftWayland

public final class ExtImageCopyCaptureCursorSessionV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getCaptureSession() -> ExtImageCopyCaptureSessionV1 {
        let session = connection.createProxy(type: ExtImageCopyCaptureSessionV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(session.id)
        ])
        connection.queueSend(message: message)
        return session
    }
    
    public enum Error: UInt32, WlEnum {
        case duplicateSession = 1
    }
    
    public enum Event: WlEventEnum {
        case enter
        case leave
        case position(x: Int32, y: Int32)
        case hotspot(x: Int32, y: Int32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
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
