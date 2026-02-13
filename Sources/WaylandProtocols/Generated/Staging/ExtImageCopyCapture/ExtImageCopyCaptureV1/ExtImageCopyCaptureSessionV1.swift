import Foundation
import SwiftWayland

public final class ExtImageCopyCaptureSessionV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_image_copy_capture_session_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func createFrame() throws(WaylandProxyError)  -> ExtImageCopyCaptureFrameV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let frame = connection.createProxy(type: ExtImageCopyCaptureFrameV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(frame.id)
        ])
        connection.send(message: message)
        return frame
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
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
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
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
