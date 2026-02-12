public final class WlPointer: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func setCursor(serial: UInt32, surface: WlSurface, hotspotX: Int32, hotspotY: Int32) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .uint(serial),
            .object(surface),
            .int(hotspotX),
            .int(hotspotY)
        ])
        connection.queueSend(message: message)
    }
    
    public func release() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case role = 0
    }
    
    public enum ButtonState: UInt32, WlEnum {
        case released = 0
        case pressed = 1
    }
    
    public enum Axis: UInt32, WlEnum {
        case verticalScroll = 0
        case horizontalScroll = 1
    }
    
    public enum AxisSource: UInt32, WlEnum {
        case wheel = 0
        case finger = 1
        case continuous = 2
        case wheelTilt = 3
    }
    
    public enum AxisRelativeDirection: UInt32, WlEnum {
        case identical = 0
        case inverted = 1
    }
    
    public enum Event: WlEventEnum {
        case enter(serial: UInt32, surface: WlSurface, surfaceX: Double, surfaceY: Double)
        case leave(serial: UInt32, surface: WlSurface)
        case motion(time: UInt32, surfaceX: Double, surfaceY: Double)
        case button(serial: UInt32, time: UInt32, button: UInt32, state: UInt32)
        case axis(time: UInt32, axis: UInt32, value: Double)
        case frame
        case axisSource(axisSource: UInt32)
        case axisStop(time: UInt32, axis: UInt32)
        case axisDiscrete(axis: UInt32, discrete: Int32)
        case axisValue120(axis: UInt32, value120: Int32)
        case axisRelativeDirection(axis: UInt32, direction: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments)
            switch message.opcode {
            case 0:
                return Self.enter(serial: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!, surfaceX: r.readFixed(), surfaceY: r.readFixed())
            case 1:
                return Self.leave(serial: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 2:
                return Self.motion(time: r.readUInt(), surfaceX: r.readFixed(), surfaceY: r.readFixed())
            case 3:
                return Self.button(serial: r.readUInt(), time: r.readUInt(), button: r.readUInt(), state: r.readUInt())
            case 4:
                return Self.axis(time: r.readUInt(), axis: r.readUInt(), value: r.readFixed())
            case 5:
                return Self.frame
            case 6:
                return Self.axisSource(axisSource: r.readUInt())
            case 7:
                return Self.axisStop(time: r.readUInt(), axis: r.readUInt())
            case 8:
                return Self.axisDiscrete(axis: r.readUInt(), discrete: r.readInt())
            case 9:
                return Self.axisValue120(axis: r.readUInt(), value120: r.readInt())
            case 10:
                return Self.axisRelativeDirection(axis: r.readUInt(), direction: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
