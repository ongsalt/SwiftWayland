import Foundation

public final class WlDataDeviceManager: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_data_device_manager"
    public var onEvent: (Event) -> Void = { _ in }

    public func createDataSource() throws(WaylandProxyError) -> WlDataSource {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlDataSource.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getDataDevice(seat: WlSeat) throws(WaylandProxyError) -> WlDataDevice {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlDataDevice.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(seat)
        ])
        connection.send(message: message)
        return id
    }
    
    public enum DndAction: UInt32, WlEnum {
        case `none` = 0
        case `copy` = 1
        case move = 2
        case ask = 4
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
