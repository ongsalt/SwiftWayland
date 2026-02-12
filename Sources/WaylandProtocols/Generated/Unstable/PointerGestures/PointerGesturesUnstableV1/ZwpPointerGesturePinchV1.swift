import Foundation
import SwiftWayland

public final class ZwpPointerGesturePinchV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case begin(serial: UInt32, time: UInt32, surface: WlSurface, fingers: UInt32)
        case update(time: UInt32, dx: Double, dy: Double, scale: Double, rotation: Double)
        case end(serial: UInt32, time: UInt32, cancelled: Int32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.begin(serial: r.readUInt(), time: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!, fingers: r.readUInt())
            case 1:
                return Self.update(time: r.readUInt(), dx: r.readFixed(), dy: r.readFixed(), scale: r.readFixed(), rotation: r.readFixed())
            case 2:
                return Self.end(serial: r.readUInt(), time: r.readUInt(), cancelled: r.readInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
