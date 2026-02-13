import Foundation
import SwiftWayland

public final class ExtTransientSeatManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_transient_seat_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func create() throws(WaylandProxyError) -> ExtTransientSeatV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let seat = connection.createProxy(type: ExtTransientSeatV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(seat.id)
        ])
        connection.send(message: message)
        return seat
    }
    
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
