import Foundation
import SwiftWayland

public final class WpAlphaModifierV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_alpha_modifier_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getSurface(surface: WlSurface) throws(WaylandProxyError)  -> WpAlphaModifierSurfaceV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpAlphaModifierSurfaceV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case alreadyConstructed = 0
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
