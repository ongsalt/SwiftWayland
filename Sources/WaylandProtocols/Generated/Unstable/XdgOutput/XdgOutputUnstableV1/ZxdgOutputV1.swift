import Foundation
import SwiftWayland

public final class ZxdgOutputV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case logicalPosition(x: Int32, y: Int32)
        case logicalSize(width: Int32, height: Int32)
        case done
        case name(name: String)
        case description(description: String)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.logicalPosition(x: r.readInt(), y: r.readInt())
            case 1:
                return Self.logicalSize(width: r.readInt(), height: r.readInt())
            case 2:
                return Self.done
            case 3:
                return Self.name(name: r.readString())
            case 4:
                return Self.description(description: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
