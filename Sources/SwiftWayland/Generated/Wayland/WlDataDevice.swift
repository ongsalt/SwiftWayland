import Foundation

public final class WlDataDevice: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func startDrag(source: WlDataSource, origin: WlSurface, icon: WlSurface, serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .object(source),
            .object(origin),
            .object(icon),
            .uint(serial)
        ])
        connection.queueSend(message: message)
    }
    
    public func setSelection(source: WlDataSource, serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(source),
            .uint(serial)
        ])
        connection.queueSend(message: message)
    }
    
    public func release() {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case role = 0
        case usedSource = 1
    }
    
    public enum Event: WlEventEnum {
        case dataOffer(id: WlDataOffer)
        case enter(serial: UInt32, surface: WlSurface, x: Double, y: Double, id: WlDataOffer)
        case leave
        case motion(time: UInt32, x: Double, y: Double)
        case drop
        case selection(id: WlDataOffer)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.dataOffer(id: connection.createProxy(type: WlDataOffer.self, id: r.readNewId()))
            case 1:
                return Self.enter(serial: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!, x: r.readFixed(), y: r.readFixed(), id: connection.get(as: WlDataOffer.self, id: r.readObjectId())!)
            case 2:
                return Self.leave
            case 3:
                return Self.motion(time: r.readUInt(), x: r.readFixed(), y: r.readFixed())
            case 4:
                return Self.drop
            case 5:
                return Self.selection(id: connection.get(as: WlDataOffer.self, id: r.readObjectId())!)
            default:
                fatalError("Unknown message")
            }
        }
    }
}
