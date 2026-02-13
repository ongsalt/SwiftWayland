import Foundation
import SwiftWayland

public final class ZwpPrimarySelectionDeviceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_primary_selection_device_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func setSelection(source: ZwpPrimarySelectionSourceV1, serial: UInt32) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .object(source),
            .uint(serial)
        ])
        connection.send(message: message)
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case dataOffer(offer: ZwpPrimarySelectionOfferV1)
        case selection(id: ZwpPrimarySelectionOfferV1)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
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
