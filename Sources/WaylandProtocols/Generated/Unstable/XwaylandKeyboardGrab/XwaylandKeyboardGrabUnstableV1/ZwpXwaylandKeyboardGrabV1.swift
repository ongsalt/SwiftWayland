import Foundation
import SwiftWayland

/// Interface For Grabbing The Keyboard
/// 
/// A global interface used for grabbing the keyboard.
public final class ZwpXwaylandKeyboardGrabV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_xwayland_keyboard_grab_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Grabbed Keyboard Object
    /// 
    /// Destroy the grabbed keyboard object. If applicable, the compositor
    /// will ungrab the keyboard.
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
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
