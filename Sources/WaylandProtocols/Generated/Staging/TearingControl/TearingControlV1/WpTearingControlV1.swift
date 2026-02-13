import Foundation
import SwiftWayland

public final class WpTearingControlV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_tearing_control_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func setPresentationHint(hint: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.uint(hint)
        ])
        connection.send(message: message)
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
    
    public enum PresentationHint: UInt32, WlEnum {
        case vsync = 0
        case `async` = 1
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
