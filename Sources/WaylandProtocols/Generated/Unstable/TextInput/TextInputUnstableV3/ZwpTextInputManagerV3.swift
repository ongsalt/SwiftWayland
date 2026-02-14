import Foundation
import SwiftWayland

/// Text Input Manager
/// 
/// A factory for text-input objects. This object is a global singleton.
public final class ZwpTextInputManagerV3: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_text_input_manager_v3"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Wp_Text_Input_Manager
    /// 
    /// Destroy the wp_text_input_manager object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A New Text Input Object
    /// 
    /// Creates a new text-input object for a given seat.
    public func getTextInput(seat: WlSeat) throws(WaylandProxyError) -> ZwpTextInputV3 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpTextInputV3.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(seat)
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
