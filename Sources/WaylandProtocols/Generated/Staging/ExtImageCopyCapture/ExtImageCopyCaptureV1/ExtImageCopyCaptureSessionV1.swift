import Foundation
import SwiftWayland

public final class ExtImageCopyCaptureSessionV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func createFrame() -> ExtImageCopyCaptureFrameV1 {
        let frame = connection.createProxy(type: ExtImageCopyCaptureFrameV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(frame.id)
        ])
        connection.queueSend(message: message)
        return frame
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case duplicateFrame = 1
    }
    
    public enum Event: WlEventEnum {
        case bufferSize(width: UInt32, height: UInt32)
        case shmFormat(format: UInt32)
        case dmabufDevice(device: Data)
        case dmabufFormat(format: UInt32, modifiers: Data)
        case done
        case stopped
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.bufferSize(width: r.readUInt(), height: r.readUInt())
            case 1:
                return Self.shmFormat(format: r.readUInt())
            case 2:
                return Self.dmabufDevice(device: r.readArray())
            case 3:
                return Self.dmabufFormat(format: r.readUInt(), modifiers: r.readArray())
            case 4:
                return Self.done
            case 5:
                return Self.stopped
            default:
                fatalError("Unknown message")
            }
        }
    }
}
