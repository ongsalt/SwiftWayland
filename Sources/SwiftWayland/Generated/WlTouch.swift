import Foundation

public final class WlTouch: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func release() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case down(serial: UInt32, time: UInt32, surface: WlSurface, id: Int32, x: Double, y: Double)
        case up(serial: UInt32, time: UInt32, id: Int32)
        case motion(time: UInt32, id: Int32, x: Double, y: Double)
        case frame
        case cancel
        case shape(id: Int32, major: Double, minor: Double)
        case orientation(id: Int32, orientation: Double)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.down(serial: r.readUInt(), time: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!, id: r.readInt(), x: r.readFixed(), y: r.readFixed())
            case 1:
                return Self.up(serial: r.readUInt(), time: r.readUInt(), id: r.readInt())
            case 2:
                return Self.motion(time: r.readUInt(), id: r.readInt(), x: r.readFixed(), y: r.readFixed())
            case 3:
                return Self.frame
            case 4:
                return Self.cancel
            case 5:
                return Self.shape(id: r.readInt(), major: r.readFixed(), minor: r.readFixed())
            case 6:
                return Self.orientation(id: r.readInt(), orientation: r.readFixed())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
