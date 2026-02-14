import Foundation
import SwiftWayland

/// Context Object For Keyboard Shortcuts Inhibitor
/// 
/// A keyboard shortcuts inhibitor instructs the compositor to ignore
/// its own keyboard shortcuts when the associated surface has keyboard
/// focus. As a result, when the surface has keyboard focus on the given
/// seat, it will receive all key events originating from the specified
/// seat, even those which would normally be caught by the compositor for
/// its own shortcuts.
/// The Wayland compositor is however under no obligation to disable
/// all of its shortcuts, and may keep some special key combo for its own
/// use, including but not limited to one allowing the user to forcibly
/// restore normal keyboard events routing in the case of an unwilling
/// client. The compositor may also use the same key combo to reactivate
/// an existing shortcut inhibitor that was previously deactivated on
/// user request.
/// When the compositor restores its own keyboard shortcuts, an
/// "inactive" event is emitted to notify the client that the keyboard
/// shortcuts inhibitor is not effectively active for the surface and
/// seat any more, and the client should not expect to receive all
/// keyboard events.
/// When the keyboard shortcuts inhibitor is inactive, the client has
/// no way to forcibly reactivate the keyboard shortcuts inhibitor.
/// The user can chose to re-enable a previously deactivated keyboard
/// shortcuts inhibitor using any mechanism the compositor may offer,
/// in which case the compositor will send an "active" event to notify
/// the client.
/// If the surface is destroyed, unmapped, or loses the seat's keyboard
/// focus, the keyboard shortcuts inhibitor becomes irrelevant and the
/// compositor will restore its own keyboard shortcuts but no "inactive"
/// event is emitted in this case.
public final class ZwpKeyboardShortcutsInhibitorV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_keyboard_shortcuts_inhibitor_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Keyboard Shortcuts Inhibitor Object
    /// 
    /// Remove the keyboard shortcuts inhibitor from the associated wl_surface.
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
        /// Shortcuts Are Inhibited
        /// 
        /// This event indicates that the shortcut inhibitor is active.
        /// The compositor sends this event every time compositor shortcuts
        /// are inhibited on behalf of the surface. When active, the client
        /// may receive input events normally reserved by the compositor
        /// (see zwp_keyboard_shortcuts_inhibitor_v1).
        /// This occurs typically when the initial request "inhibit_shortcuts"
        /// first becomes active or when the user instructs the compositor to
        /// re-enable and existing shortcuts inhibitor using any mechanism
        /// offered by the compositor.
        case active
        
        /// Shortcuts Are Restored
        /// 
        /// This event indicates that the shortcuts inhibitor is inactive,
        /// normal shortcuts processing is restored by the compositor.
        case inactive
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.active
            case 1:
                return Self.inactive
            default:
                fatalError("Unknown message")
            }
        }
    }
}
