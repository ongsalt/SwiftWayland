import Foundation

public final class ZwpTabletPadDialV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_pad_dial_v2"
    public var onEvent: (Event) -> Void = { _ in }

    public func setFeedback(description: String, serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .string(description),
            .uint(serial)
        ])
        connection.queueSend(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case delta(value120: Int32)
        case frame(time: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.delta(value120: r.readInt())
            case 1:
                return Self.frame(time: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
