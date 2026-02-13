import Foundation
import SwiftWayland

public final class ZwpLinuxBufferParamsV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_linux_buffer_params_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func add(fd: FileHandle, planeIdx: UInt32, offset: UInt32, stride: UInt32, modifierHi: UInt32, modifierLo: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .fd(fd),
            .uint(planeIdx),
            .uint(offset),
            .uint(stride),
            .uint(modifierHi),
            .uint(modifierLo)
        ])
        connection.queueSend(message: message)
    }
    
    public func create(width: Int32, height: Int32, format: UInt32, flags: UInt32) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .int(width),
            .int(height),
            .uint(format),
            .uint(flags)
        ])
        connection.queueSend(message: message)
    }
    
    public func createImmed(width: Int32, height: Int32, format: UInt32, flags: UInt32) -> WlBuffer {
        let bufferId = connection.createProxy(type: WlBuffer.self)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .newId(bufferId.id),
            .int(width),
            .int(height),
            .uint(format),
            .uint(flags)
        ])
        connection.queueSend(message: message)
        return bufferId
    }
    
    public enum Error: UInt32, WlEnum {
        case alreadyUsed = 0
        case planeIdx = 1
        case planeSet = 2
        case incomplete = 3
        case invalidFormat = 4
        case invalidDimensions = 5
        case outOfBounds = 6
        case invalidWlBuffer = 7
    }
    
    public enum Flags: UInt32, WlEnum {
        case yInvert = 1
        case interlaced = 2
        case bottomFirst = 4
    }
    
    public enum Event: WlEventEnum {
        case created(buffer: WlBuffer)
        case failed
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.created(buffer: connection.createProxy(type: WlBuffer.self, id: r.readNewId()))
            case 1:
                return Self.failed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
