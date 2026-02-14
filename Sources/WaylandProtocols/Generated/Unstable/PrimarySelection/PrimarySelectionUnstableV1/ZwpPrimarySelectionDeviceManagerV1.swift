import Foundation
import SwiftWayland

/// X Primary Selection Emulation
/// 
/// The primary selection device manager is a singleton global object that
/// provides access to the primary selection. It allows to create
/// wp_primary_selection_source objects, as well as retrieving the per-seat
/// wp_primary_selection_device objects.
public final class ZwpPrimarySelectionDeviceManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_primary_selection_device_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create A New Primary Selection Source
    /// 
    /// Create a new primary selection source.
    public func createSource() throws(WaylandProxyError) -> ZwpPrimarySelectionSourceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpPrimarySelectionSourceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Create A New Primary Selection Device
    /// 
    /// Create a new data device for a given seat.
    public func getDevice(seat: WlSeat) throws(WaylandProxyError) -> ZwpPrimarySelectionDeviceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpPrimarySelectionDeviceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(seat)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Destroy The Primary Selection Device Manager
    /// 
    /// Destroy the primary selection device manager.
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
