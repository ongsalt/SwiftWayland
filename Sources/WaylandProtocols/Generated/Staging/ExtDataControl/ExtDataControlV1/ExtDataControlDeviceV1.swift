import Foundation
import SwiftWayland

public final class ExtDataControlDeviceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_data_control_device_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func setSelection(source: ExtDataControlSourceV1) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .object(source)
        ])
        connection.queueSend(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setPrimarySelection(source: ExtDataControlSourceV1) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(source)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case usedSource = 1
    }
    
    public enum Event: WlEventEnum {
        case dataOffer(id: ExtDataControlOfferV1)
        case selection(id: ExtDataControlOfferV1)
        case finished
        case primarySelection(id: ExtDataControlOfferV1)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.dataOffer(id: connection.createProxy(type: ExtDataControlOfferV1.self, id: r.readNewId()))
            case 1:
                return Self.selection(id: connection.get(as: ExtDataControlOfferV1.self, id: r.readObjectId())!)
            case 2:
                return Self.finished
            case 3:
                return Self.primarySelection(id: connection.get(as: ExtDataControlOfferV1.self, id: r.readObjectId())!)
            default:
                fatalError("Unknown message")
            }
        }
    }
}
