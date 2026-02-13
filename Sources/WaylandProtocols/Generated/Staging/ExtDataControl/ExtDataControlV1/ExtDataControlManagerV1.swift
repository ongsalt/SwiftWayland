import Foundation
import SwiftWayland

public final class ExtDataControlManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_data_control_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func createDataSource() throws(WaylandProxyError)  -> ExtDataControlSourceV1 {
        let id = connection.createProxy(type: ExtDataControlSourceV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getDataDevice(seat: WlSeat) throws(WaylandProxyError)  -> ExtDataControlDeviceV1 {
        let id = connection.createProxy(type: ExtDataControlDeviceV1.self)
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
