import Foundation

public final class ZwpTabletPadRingV2: WlProxyBase, WlProxy {
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
    
    public enum Source: UInt32, WlEnum {
        case finger = 1
    }
    
    public enum Event: WlEventEnum {
        case source(source: UInt32)
        case angle(degrees: Double)
        case stop
        case frame(time: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.source(source: r.readUInt())
            case 1:
                return Self.angle(degrees: r.readFixed())
            case 2:
                return Self.stop
            case 3:
                return Self.frame(time: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
