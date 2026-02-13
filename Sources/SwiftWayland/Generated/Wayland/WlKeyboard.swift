import Foundation

public final class WlKeyboard: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_keyboard"
    public var onEvent: (Event) -> Void = { _ in }

    public func release() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum KeymapFormat: UInt32, WlEnum {
        case noKeymap = 0
        case xkbV1 = 1
    }
    
    public enum KeyState: UInt32, WlEnum {
        case released = 0
        case pressed = 1
        case repeated = 2
    }
    
    public enum Event: WlEventEnum {
        case keymap(format: UInt32, fd: FileHandle, size: UInt32)
        case enter(serial: UInt32, surface: WlSurface, keys: Data)
        case leave(serial: UInt32, surface: WlSurface)
        case key(serial: UInt32, time: UInt32, key: UInt32, state: UInt32)
        case modifiers(serial: UInt32, modsDepressed: UInt32, modsLatched: UInt32, modsLocked: UInt32, group: UInt32)
        case repeatInfo(rate: Int32, delay: Int32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.keymap(format: r.readUInt(), fd: r.readFd(), size: r.readUInt())
            case 1:
                return Self.enter(serial: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!, keys: r.readArray())
            case 2:
                return Self.leave(serial: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 3:
                return Self.key(serial: r.readUInt(), time: r.readUInt(), key: r.readUInt(), state: r.readUInt())
            case 4:
                return Self.modifiers(serial: r.readUInt(), modsDepressed: r.readUInt(), modsLatched: r.readUInt(), modsLocked: r.readUInt(), group: r.readUInt())
            case 5:
                return Self.repeatInfo(rate: r.readInt(), delay: r.readInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
