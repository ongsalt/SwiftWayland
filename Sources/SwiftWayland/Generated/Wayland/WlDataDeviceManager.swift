import Foundation

public final class WlDataDeviceManager: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_data_device_manager"
    public var onEvent: (Event) -> Void = { _ in }

    public func createDataSource() -> WlDataSource {
        let id = connection.createProxy(type: WlDataSource.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func getDataDevice(seat: WlSeat) -> WlDataDevice {
        let id = connection.createProxy(type: WlDataDevice.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(seat)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum DndAction: UInt32, WlEnum {
        case `none` = 0
        case `copy` = 1
        case move = 2
        case ask = 4
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
