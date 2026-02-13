import Foundation
import SwiftWayland

public final class ExtIdleNotificationV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_idle_notification_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case idled
        case resumed
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.idled
            case 1:
                return Self.resumed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
