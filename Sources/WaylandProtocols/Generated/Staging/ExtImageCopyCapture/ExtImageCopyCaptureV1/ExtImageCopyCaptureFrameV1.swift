import Foundation
import SwiftWayland

public final class ExtImageCopyCaptureFrameV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_image_copy_capture_frame_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func attachBuffer(buffer: WlBuffer) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(buffer)
        ])
        connection.send(message: message)
    }
    
    public func damageBuffer(x: Int32, y: Int32, width: Int32, height: Int32) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .int(x),
            .int(y),
            .int(width),
            .int(height)
        ])
        connection.send(message: message)
    }
    
    public func capture() {
        let message = Message(objectId: self.id, opcode: 3, contents: [])
        connection.send(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case noBuffer = 1
        case invalidBufferDamage = 2
        case alreadyCaptured = 3
    }
    
    public enum FailureReason: UInt32, WlEnum {
        case unknown = 0
        case bufferConstraints = 1
        case stopped = 2
    }
    
    public enum Event: WlEventEnum {
        case transform(transform: UInt32)
        case damage(x: Int32, y: Int32, width: Int32, height: Int32)
        case presentationTime(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32)
        case ready
        case failed(reason: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.transform(transform: r.readUInt())
            case 1:
                return Self.damage(x: r.readInt(), y: r.readInt(), width: r.readInt(), height: r.readInt())
            case 2:
                return Self.presentationTime(tvSecHi: r.readUInt(), tvSecLo: r.readUInt(), tvNsec: r.readUInt())
            case 3:
                return Self.ready
            case 4:
                return Self.failed(reason: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
