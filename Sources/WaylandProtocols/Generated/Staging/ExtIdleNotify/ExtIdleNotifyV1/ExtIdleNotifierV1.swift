import Foundation
import SwiftWayland

public final class ExtIdleNotifierV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_idle_notifier_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getIdleNotification(timeout: UInt32, seat: WlSeat) throws(WaylandProxyError)  -> ExtIdleNotificationV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ExtIdleNotificationV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .uint(timeout),
            .object(seat)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getInputIdleNotification(timeout: UInt32, seat: WlSeat) throws(WaylandProxyError)  -> ExtIdleNotificationV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let id = connection.createProxy(type: ExtIdleNotificationV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id),
            .uint(timeout),
            .object(seat)
        ])
        connection.send(message: message)
        return id
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
