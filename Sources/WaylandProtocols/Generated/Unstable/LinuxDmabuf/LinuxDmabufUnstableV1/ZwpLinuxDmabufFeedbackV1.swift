import Foundation
import SwiftWayland

public final class ZwpLinuxDmabufFeedbackV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_linux_dmabuf_feedback_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum TrancheFlags: UInt32, WlEnum {
        case scanout = 1
    }
    
    public enum Event: WlEventEnum {
        case done
        case formatTable(fd: FileHandle, size: UInt32)
        case mainDevice(device: Data)
        case trancheDone
        case trancheTargetDevice(device: Data)
        case trancheFormats(indices: Data)
        case trancheFlags(flags: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.done
            case 1:
                return Self.formatTable(fd: r.readFd(), size: r.readUInt())
            case 2:
                return Self.mainDevice(device: r.readArray())
            case 3:
                return Self.trancheDone
            case 4:
                return Self.trancheTargetDevice(device: r.readArray())
            case 5:
                return Self.trancheFormats(indices: r.readArray())
            case 6:
                return Self.trancheFlags(flags: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
