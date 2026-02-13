import Foundation
import SwiftWayland

public final class ExtTransientSeatManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_transient_seat_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func create() throws(WaylandProxyError)  -> ExtTransientSeatV1 {
        let seat = connection.createProxy(type: ExtTransientSeatV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(seat.id)
        ])
        connection.send(message: message)
        return seat
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
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
