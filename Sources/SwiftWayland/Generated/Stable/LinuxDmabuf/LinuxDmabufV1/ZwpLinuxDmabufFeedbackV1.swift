import Foundation

public final class ZwpLinuxDmabufFeedbackV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
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
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
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
