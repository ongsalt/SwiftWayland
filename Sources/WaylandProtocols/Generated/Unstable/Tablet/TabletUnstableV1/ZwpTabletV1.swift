import Foundation
import SwiftWayland

public final class ZwpTabletV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case name(name: String)
        case id(vid: UInt32, pid: UInt32)
        case path(path: String)
        case done
        case removed
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.name(name: r.readString())
            case 1:
                return Self.id(vid: r.readUInt(), pid: r.readUInt())
            case 2:
                return Self.path(path: r.readString())
            case 3:
                return Self.done
            case 4:
                return Self.removed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
