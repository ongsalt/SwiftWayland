import Foundation
import SwiftWayland

/// Manager To Control Data Devices
/// 
/// This interface is a manager that allows creating per-seat data device
/// controls.
public final class ExtDataControlManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_data_control_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create A New Data Source
    /// 
    /// Create a new data source.
    public func createDataSource() throws(WaylandProxyError) -> ExtDataControlSourceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ExtDataControlSourceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Get A Data Device For A Seat
    /// 
    /// Create a data device that can be used to manage a seat's selection.
    public func getDataDevice(seat: WlSeat) throws(WaylandProxyError) -> ExtDataControlDeviceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ExtDataControlDeviceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(seat)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Destroy The Manager
    /// 
    /// All objects created by the manager will still remain valid, until their
    /// appropriate destroy request has been called.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
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
