import Foundation
import SwiftWayland

public final class ZwpPrimarySelectionDeviceManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_primary_selection_device_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func createSource() throws(WaylandProxyError)  -> ZwpPrimarySelectionSourceV1 {
        let id = connection.createProxy(type: ZwpPrimarySelectionSourceV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getDevice(seat: WlSeat) throws(WaylandProxyError)  -> ZwpPrimarySelectionDeviceV1 {
        let id = connection.createProxy(type: ZwpPrimarySelectionDeviceV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(seat)
        ])
        connection.send(message: message)
        return id
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
