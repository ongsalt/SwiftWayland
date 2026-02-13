import Foundation
import SwiftWayland

public final class ExtDataControlDeviceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_data_control_device_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func setSelection(source: ExtDataControlSourceV1) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .object(source)
        ])
        connection.send(message: message)
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func setPrimarySelection(source: ExtDataControlSourceV1) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(source)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case usedSource = 1
    }
    
    public enum Event: WlEventEnum {
        case dataOffer(id: ExtDataControlOfferV1)
        case selection(id: ExtDataControlOfferV1)
        case finished
        case primarySelection(id: ExtDataControlOfferV1)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.dataOffer(id: connection.createProxy(type: ExtDataControlOfferV1.self, version: version, id: r.readNewId()))
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
