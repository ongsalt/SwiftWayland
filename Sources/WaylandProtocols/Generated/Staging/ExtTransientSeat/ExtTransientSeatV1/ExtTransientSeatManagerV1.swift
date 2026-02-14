import Foundation
import SwiftWayland

/// Transient Seat Manager
/// 
/// The transient seat manager creates short-lived seats.
public final class ExtTransientSeatManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_transient_seat_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create A Transient Seat
    /// 
    /// Create a new seat that is removed when the client side transient seat
    /// object is destroyed.
    /// The actual seat may be removed sooner, in which case the transient seat
    /// object shall become inert.
    public func create() throws(WaylandProxyError) -> ExtTransientSeatV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let seat = connection.createProxy(type: ExtTransientSeatV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(seat.id)
        ])
        connection.send(message: message)
        return seat
    }
    
    /// Destroy The Manager
    /// 
    /// Destroy the manager.
    /// All objects created by the manager will remain valid until they are
    /// destroyed themselves.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
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
