import Foundation
import SwiftWayland

public final class ZwpTabletSeatV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case tabletAdded(id: ZwpTabletV1)
        case toolAdded(id: ZwpTabletToolV1)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.tabletAdded(id: connection.createProxy(type: ZwpTabletV1.self, id: r.readNewId()))
            case 1:
                return Self.toolAdded(id: connection.createProxy(type: ZwpTabletToolV1.self, id: r.readNewId()))
            default:
                fatalError("Unknown message")
            }
        }
    }
}
