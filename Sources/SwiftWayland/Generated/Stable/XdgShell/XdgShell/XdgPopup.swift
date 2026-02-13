import Foundation

public final class XdgPopup: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_popup"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func grab(seat: WlSeat, serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(seat),
            .uint(serial)
        ])
        connection.queueSend(message: message)
    }
    
    public func reposition(positioner: XdgPositioner, token: UInt32) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(positioner),
            .uint(token)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidGrab = 0
    }
    
    public enum Event: WlEventEnum {
        case configure(x: Int32, y: Int32, width: Int32, height: Int32)
        case popupDone
        case repositioned(token: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.configure(x: r.readInt(), y: r.readInt(), width: r.readInt(), height: r.readInt())
            case 1:
                return Self.popupDone
            case 2:
                return Self.repositioned(token: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
