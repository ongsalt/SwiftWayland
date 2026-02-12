import Foundation
import SwiftWayland

public final class ExtTransientSeatV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case ready(globalName: UInt32)
        case denied
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.ready(globalName: r.readUInt())
            case 1:
                return Self.denied
            default:
                fatalError("Unknown message")
            }
        }
    }
}
