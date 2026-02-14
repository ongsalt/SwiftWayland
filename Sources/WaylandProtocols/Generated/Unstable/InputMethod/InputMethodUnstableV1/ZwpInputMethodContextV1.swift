import Foundation
import SwiftWayland

/// Input Method Context
/// 
/// Corresponds to a text input on the input method side. An input method context
/// is created on text input activation on the input method side. It allows
/// receiving information about the text input from the application via events.
/// Input method contexts do not keep state after deactivation and should be
/// destroyed after deactivation is handled.
/// Text is generally UTF-8 encoded, indices and lengths are in bytes.
/// Serials are used to synchronize the state between the text input and
/// an input method. New serials are sent by the text input in the
/// commit_state request and are used by the input method to indicate
/// the known text input state in events like preedit_string, commit_string,
/// and keysym. The text input can then ignore events from the input method
/// which are based on an outdated state (for example after a reset).
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZwpInputMethodContextV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_input_method_context_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Commit String
    /// 
    /// Send the commit string text for insertion to the application.
    /// The text to commit could be either just a single character after a key
    /// press or the result of some composing (pre-edit). It could be also an
    /// empty text when some text should be removed (see
    /// delete_surrounding_text) or when the input cursor should be moved (see
    /// cursor_position).
    /// Any previously set composing text will be removed.
    /// 
    /// - Parameters:
    ///   - Serial: serial of the latest known text input state
    public func commitString(serial: UInt32, text: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.uint(serial),
            WaylandData.string(text)
        ])
        connection.send(message: message)
    }
    
    /// Pre-Edit String
    /// 
    /// Send the pre-edit string text to the application text input.
    /// The commit text can be used to replace the pre-edit text on reset (for
    /// example on unfocus).
    /// Previously sent preedit_style and preedit_cursor requests are also
    /// processed by the text_input.
    /// 
    /// - Parameters:
    ///   - Serial: serial of the latest known text input state
    public func preeditString(serial: UInt32, text: String, commit: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.uint(serial),
            WaylandData.string(text),
            WaylandData.string(commit)
        ])
        connection.send(message: message)
    }
    
    /// Pre-Edit Styling
    /// 
    /// Set the styling information on composing text. The style is applied for
    /// length in bytes from index relative to the beginning of
    /// the composing text (as byte offset). Multiple styles can
    /// be applied to a composing text.
    /// This request should be sent before sending a preedit_string request.
    public func preeditStyling(index: UInt32, length: UInt32, style: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.uint(index),
            WaylandData.uint(length),
            WaylandData.uint(style)
        ])
        connection.send(message: message)
    }
    
    /// Pre-Edit Cursor
    /// 
    /// Set the cursor position inside the composing text (as byte offset)
    /// relative to the start of the composing text.
    /// When index is negative no cursor should be displayed.
    /// This request should be sent before sending a preedit_string request.
    public func preeditCursor(index: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.int(index)
        ])
        connection.send(message: message)
    }
    
    /// Delete Text
    /// 
    /// Remove the surrounding text.
    /// This request will be handled on the text_input side directly following
    /// a commit_string request.
    public func deleteSurroundingText(index: Int32, length: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.int(index),
            WaylandData.uint(length)
        ])
        connection.send(message: message)
    }
    
    /// Set Cursor To A New Position
    /// 
    /// Set the cursor and anchor to a new position. Index is the new cursor
    /// position in bytes (when >= 0 this is relative to the end of the inserted text,
    /// otherwise it is relative to the beginning of the inserted text). Anchor is
    /// the new anchor position in bytes (when >= 0 this is relative to the end of the
    /// inserted text, otherwise it is relative to the beginning of the inserted
    /// text). When there should be no selected text, anchor should be the same
    /// as index.
    /// This request will be handled on the text_input side directly following
    /// a commit_string request.
    public func cursorPosition(index: Int32, anchor: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            WaylandData.int(index),
            WaylandData.int(anchor)
        ])
        connection.send(message: message)
    }
    
    public func modifiersMap(map: Data) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 7, contents: [
            WaylandData.array(map)
        ])
        connection.send(message: message)
    }
    
    /// Keysym
    /// 
    /// Notify when a key event was sent. Key events should not be used for
    /// normal text input operations, which should be done with commit_string,
    /// delete_surrounding_text, etc. The key event follows the wl_keyboard key
    /// event convention. Sym is an XKB keysym, state is a wl_keyboard key_state.
    /// 
    /// - Parameters:
    ///   - Serial: serial of the latest known text input state
    public func keysym(serial: UInt32, time: UInt32, sym: UInt32, state: UInt32, modifiers: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            WaylandData.uint(serial),
            WaylandData.uint(time),
            WaylandData.uint(sym),
            WaylandData.uint(state),
            WaylandData.uint(modifiers)
        ])
        connection.send(message: message)
    }
    
    /// Grab Hardware Keyboard
    /// 
    /// Allow an input method to receive hardware keyboard input and process
    /// key events to generate text events (with pre-edit) over the wire. This
    /// allows input methods which compose multiple key events for inputting
    /// text like it is done for CJK languages.
    public func grabKeyboard() throws(WaylandProxyError) -> WlKeyboard {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let keyboard = connection.createProxy(type: WlKeyboard.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 9, contents: [
            WaylandData.newId(keyboard.id)
        ])
        connection.send(message: message)
        return keyboard
    }
    
    /// Forward Key Event
    /// 
    /// Forward a wl_keyboard::key event to the client that was not processed
    /// by the input method itself. Should be used when filtering key events
    /// with grab_keyboard.  The arguments should be the ones from the
    /// wl_keyboard::key event.
    /// For generating custom key events use the keysym request instead.
    /// 
    /// - Parameters:
    ///   - Serial: serial from wl_keyboard::key
    ///   - Time: time from wl_keyboard::key
    ///   - Key: key from wl_keyboard::key
    ///   - State: state from wl_keyboard::key
    public func key(serial: UInt32, time: UInt32, key: UInt32, state: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 10, contents: [
            WaylandData.uint(serial),
            WaylandData.uint(time),
            WaylandData.uint(key),
            WaylandData.uint(state)
        ])
        connection.send(message: message)
    }
    
    /// Forward Modifiers Event
    /// 
    /// Forward a wl_keyboard::modifiers event to the client that was not
    /// processed by the input method itself.  Should be used when filtering
    /// key events with grab_keyboard. The arguments should be the ones
    /// from the wl_keyboard::modifiers event.
    /// 
    /// - Parameters:
    ///   - Serial: serial from wl_keyboard::modifiers
    ///   - ModsDepressed: mods_depressed from wl_keyboard::modifiers
    ///   - ModsLatched: mods_latched from wl_keyboard::modifiers
    ///   - ModsLocked: mods_locked from wl_keyboard::modifiers
    ///   - Group: group from wl_keyboard::modifiers
    public func modifiers(serial: UInt32, modsDepressed: UInt32, modsLatched: UInt32, modsLocked: UInt32, group: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 11, contents: [
            WaylandData.uint(serial),
            WaylandData.uint(modsDepressed),
            WaylandData.uint(modsLatched),
            WaylandData.uint(modsLocked),
            WaylandData.uint(group)
        ])
        connection.send(message: message)
    }
    
    /// - Parameters:
    ///   - Serial: serial of the latest known text input state
    public func language(serial: UInt32, language: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 12, contents: [
            WaylandData.uint(serial),
            WaylandData.string(language)
        ])
        connection.send(message: message)
    }
    
    /// - Parameters:
    ///   - Serial: serial of the latest known text input state
    public func textDirection(serial: UInt32, direction: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 13, contents: [
            WaylandData.uint(serial),
            WaylandData.uint(direction)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// Surrounding Text Event
        /// 
        /// The plain surrounding text around the input position. Cursor is the
        /// position in bytes within the surrounding text relative to the beginning
        /// of the text. Anchor is the position in bytes of the selection anchor
        /// within the surrounding text relative to the beginning of the text. If
        /// there is no selected text then anchor is the same as cursor.
        case surroundingText(text: String, cursor: UInt32, anchor: UInt32)
        
        case reset
        
        case contentType(hint: UInt32, purpose: UInt32)
        
        case invokeAction(button: UInt32, index: UInt32)
        
        /// - Parameters:
        ///   - Serial: serial of text input state
        case commitState(serial: UInt32)
        
        case preferredLanguage(language: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.surroundingText(text: r.readString(), cursor: r.readUInt(), anchor: r.readUInt())
            case 1:
                return Self.reset
            case 2:
                return Self.contentType(hint: r.readUInt(), purpose: r.readUInt())
            case 3:
                return Self.invokeAction(button: r.readUInt(), index: r.readUInt())
            case 4:
                return Self.commitState(serial: r.readUInt())
            case 5:
                return Self.preferredLanguage(language: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
