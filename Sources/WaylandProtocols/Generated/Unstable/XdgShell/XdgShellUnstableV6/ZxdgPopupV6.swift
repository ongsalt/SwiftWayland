import Foundation
import SwiftWayland

public final class ZxdgPopupV6: WlProxyBase, WlProxy {
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
    
    public enum Error: UInt32, WlEnum {
        case invalidGrab = 0
    }
    
    public enum Event: WlEventEnum {
        case configure(x: Int32, y: Int32, width: Int32, height: Int32)
        case popupDone
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.configure(x: r.readInt(), y: r.readInt(), width: r.readInt(), height: r.readInt())
            case 1:
                return Self.popupDone
            default:
                fatalError("Unknown message")
            }
        }
    }
}
