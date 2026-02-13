import Foundation
import SwiftWayland

public final class ExtDataControlManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_data_control_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func createDataSource() -> ExtDataControlSourceV1 {
        let id = connection.createProxy(type: ExtDataControlSourceV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func getDataDevice(seat: WlSeat) -> ExtDataControlDeviceV1 {
        let id = connection.createProxy(type: ExtDataControlDeviceV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(seat)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
