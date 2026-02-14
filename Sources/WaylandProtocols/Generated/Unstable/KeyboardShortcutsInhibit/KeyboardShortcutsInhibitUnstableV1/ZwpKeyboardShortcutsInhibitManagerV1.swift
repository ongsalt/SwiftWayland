import Foundation
import SwiftWayland

/// Context Object For Keyboard Grab_Manager
/// 
/// A global interface used for inhibiting the compositor keyboard shortcuts.
public final class ZwpKeyboardShortcutsInhibitManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_keyboard_shortcuts_inhibit_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Keyboard Shortcuts Inhibitor Object
    /// 
    /// Destroy the keyboard shortcuts inhibitor manager.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A New Keyboard Shortcuts Inhibitor Object
    /// 
    /// Create a new keyboard shortcuts inhibitor object associated with
    /// the given surface for the given seat.
    /// If shortcuts are already inhibited for the specified seat and surface,
    /// a protocol error "already_inhibited" is raised by the compositor.
    /// 
    /// - Parameters:
    ///   - Surface: the surface that inhibits the keyboard shortcuts behavior
    ///   - Seat: the wl_seat for which keyboard shortcuts should be disabled
    public func inhibitShortcuts(surface: WlSurface, seat: WlSeat) throws(WaylandProxyError) -> ZwpKeyboardShortcutsInhibitorV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpKeyboardShortcutsInhibitorV1.self, version: self.version)
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
    
    public enum Error: UInt32, WlEnum {
        /// The Shortcuts Are Already Inhibited For This Surface
        case alreadyInhibited = 0
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
