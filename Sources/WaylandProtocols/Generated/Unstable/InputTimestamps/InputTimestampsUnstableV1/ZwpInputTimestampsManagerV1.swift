import Foundation
import SwiftWayland

/// Context Object For High-Resolution Input Timestamps
/// 
/// A global interface used for requesting high-resolution timestamps
/// for input events.
public final class ZwpInputTimestampsManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_input_timestamps_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Input Timestamps Manager Object
    /// 
    /// Informs the server that the client will no longer be using this
    /// protocol object. Existing objects created by this object are not
    /// affected.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Subscribe To High-Resolution Keyboard Timestamp Events
    /// 
    /// Creates a new input timestamps object that represents a subscription
    /// to high-resolution timestamp events for all wl_keyboard events that
    /// carry a timestamp.
    /// If the associated wl_keyboard object is invalidated, either through
    /// client action (e.g. release) or server-side changes, the input
    /// timestamps object becomes inert and the client should destroy it
    /// by calling zwp_input_timestamps_v1.destroy.
    /// 
    /// - Parameters:
    ///   - Keyboard: the wl_keyboard object for which to get timestamp events
    public func getKeyboardTimestamps(keyboard: WlKeyboard) throws(WaylandProxyError) -> ZwpInputTimestampsV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpInputTimestampsV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(keyboard)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Subscribe To High-Resolution Pointer Timestamp Events
    /// 
    /// Creates a new input timestamps object that represents a subscription
    /// to high-resolution timestamp events for all wl_pointer events that
    /// carry a timestamp.
    /// If the associated wl_pointer object is invalidated, either through
    /// client action (e.g. release) or server-side changes, the input
    /// timestamps object becomes inert and the client should destroy it
    /// by calling zwp_input_timestamps_v1.destroy.
    /// 
    /// - Parameters:
    ///   - Pointer: the wl_pointer object for which to get timestamp events
    public func getPointerTimestamps(pointer: WlPointer) throws(WaylandProxyError) -> ZwpInputTimestampsV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpInputTimestampsV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(pointer)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Subscribe To High-Resolution Touch Timestamp Events
    /// 
    /// Creates a new input timestamps object that represents a subscription
    /// to high-resolution timestamp events for all wl_touch events that
    /// carry a timestamp.
    /// If the associated wl_touch object becomes invalid, either through
    /// client action (e.g. release) or server-side changes, the input
    /// timestamps object becomes inert and the client should destroy it
    /// by calling zwp_input_timestamps_v1.destroy.
    /// 
    /// - Parameters:
    ///   - Touch: the wl_touch object for which to get timestamp events
    public func getTouchTimestamps(touch: WlTouch) throws(WaylandProxyError) -> ZwpInputTimestampsV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpInputTimestampsV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(touch)
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
