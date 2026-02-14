import Foundation
import SwiftWayland

/// Context Object For Keyboard Grab Manager
/// 
/// A global interface used for grabbing the keyboard.
public final class ZwpXwaylandKeyboardGrabManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_xwayland_keyboard_grab_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Keyboard Grab Manager
    /// 
    /// Destroy the keyboard grab manager.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Grab The Keyboard To A Surface
    /// 
    /// The grab_keyboard request asks for a grab of the keyboard, forcing
    /// the keyboard focus for the given seat upon the given surface.
    /// The protocol provides no guarantee that the grab is ever satisfied,
    /// and does not require the compositor to send an error if the grab
    /// cannot ever be satisfied. It is thus possible to request a keyboard
    /// grab that will never be effective.
    /// The protocol:
    /// * does not guarantee that the grab itself is applied for a surface,
    /// the grab request may be silently ignored by the compositor,
    /// * does not guarantee that any events are sent to this client even
    /// if the grab is applied to a surface,
    /// * does not guarantee that events sent to this client are exhaustive,
    /// a compositor may filter some events for its own consumption,
    /// * does not guarantee that events sent to this client are continuous,
    /// a compositor may change and reroute keyboard events while the grab
    /// is nominally active.
    /// 
    /// - Parameters:
    ///   - Surface: surface to report keyboard events to
    ///   - Seat: the seat for which the keyboard should be grabbed
    public func grabKeyboard(surface: WlSurface, seat: WlSeat) throws(WaylandProxyError) -> ZwpXwaylandKeyboardGrabV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpXwaylandKeyboardGrabV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface),
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
