import Foundation
import SwiftWayland

public final class ZwpXwaylandKeyboardGrabManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_xwayland_keyboard_grab_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func grabKeyboard(surface: WlSurface, seat: WlSeat) throws(WaylandProxyError)  -> ZwpXwaylandKeyboardGrabV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpXwaylandKeyboardGrabV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface),
            .object(seat)
        ])
        connection.send(message: message)
        return id
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
