import Foundation
import SwiftWayland

public final class ZwpTabletSeatV2: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case tabletAdded(id: ZwpTabletV2)
        case toolAdded(id: ZwpTabletToolV2)
        case padAdded(id: ZwpTabletPadV2)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.tabletAdded(id: connection.createProxy(type: ZwpTabletV2.self, id: r.readNewId()))
            case 1:
                return Self.toolAdded(id: connection.createProxy(type: ZwpTabletToolV2.self, id: r.readNewId()))
            case 2:
                return Self.padAdded(id: connection.createProxy(type: ZwpTabletPadV2.self, id: r.readNewId()))
            default:
                fatalError("Unknown message")
            }
        }
    }
}
