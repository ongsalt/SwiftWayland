import Foundation
import SwiftWayland

public final class ZwpInputTimestampsV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case timestamp(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.timestamp(tvSecHi: r.readUInt(), tvSecLo: r.readUInt(), tvNsec: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
