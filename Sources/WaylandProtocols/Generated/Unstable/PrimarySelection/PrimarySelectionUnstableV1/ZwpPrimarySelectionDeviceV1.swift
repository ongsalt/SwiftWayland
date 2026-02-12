import Foundation
import SwiftWayland

public final class ZwpPrimarySelectionDeviceV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func setSelection(source: ZwpPrimarySelectionSourceV1, serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .object(source),
            .uint(serial)
        ])
        connection.queueSend(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case dataOffer(offer: ZwpPrimarySelectionOfferV1)
        case selection(id: ZwpPrimarySelectionOfferV1)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.dataOffer(offer: connection.createProxy(type: ZwpPrimarySelectionOfferV1.self, id: r.readNewId()))
            case 1:
                return Self.selection(id: connection.get(as: ZwpPrimarySelectionOfferV1.self, id: r.readObjectId())!)
            default:
                fatalError("Unknown message")
            }
        }
    }
}
