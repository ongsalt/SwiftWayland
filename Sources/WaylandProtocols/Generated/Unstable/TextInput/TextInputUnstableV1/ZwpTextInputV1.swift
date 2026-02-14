import Foundation
import SwiftWayland

/// Text Input
/// 
/// An object used for text input. Adds support for text input and input
/// methods to applications. A text_input object is created from a
/// wl_text_input_manager and corresponds typically to a text entry in an
/// application.
/// Requests are used to activate/deactivate the text_input object and set
/// state information like surrounding and selected text or the content type.
/// The information about entered text is sent to the text_input object via
/// the pre-edit and commit events. Using this interface removes the need
/// for applications to directly process hardware key events and compose text
/// out of them.
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
public final class ZwpTextInputV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_text_input_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Request Activation
    /// 
    /// Requests the text_input object to be activated (typically when the
    /// text entry gets focus).
    /// The seat argument is a wl_seat which maintains the focus for this
    /// activation. The surface argument is a wl_surface assigned to the
    /// text_input object and tracked for focus lost. The enter event
    /// is emitted on successful activation.
    public func activate(seat: WlSeat, surface: WlSurface) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.object(seat),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
    }
    
    /// Request Deactivation
    /// 
    /// Requests the text_input object to be deactivated (typically when the
    /// text entry lost focus). The seat argument is a wl_seat which was used
    /// for activation.
    public func deactivate(seat: WlSeat) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(seat)
        ])
        connection.send(message: message)
    }
    
    /// Show Input Panels
    /// 
    /// Requests input panels (virtual keyboard) to show.
    public func showInputPanel() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
    }
    
    /// Hide Input Panels
    /// 
    /// Requests input panels (virtual keyboard) to hide.
    public func hideInputPanel() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [])
        connection.send(message: message)
    }
    
    /// Reset
    /// 
    /// Should be called by an editor widget when the input state should be
    /// reset, for example after the text was changed outside of the normal
    /// input method flow.
    public func reset() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [])
        connection.send(message: message)
    }
    
    /// Sets The Surrounding Text
    /// 
    /// Sets the plain surrounding text around the input position. Text is
    /// UTF-8 encoded. Cursor is the byte offset within the
    /// surrounding text. Anchor is the byte offset of the
    /// selection anchor within the surrounding text. If there is no selected
    /// text anchor, then it is the same as cursor.
    public func setSurroundingText(text: String, cursor: UInt32, anchor: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.string(text),
            WaylandData.uint(cursor),
            WaylandData.uint(anchor)
        ])
        connection.send(message: message)
    }
    
    /// Set Content Purpose And Hint
    /// 
    /// Sets the content purpose and content hint. While the purpose is the
    /// basic purpose of an input field, the hint flags allow to modify some
    /// of the behavior.
    /// When no content type is explicitly set, a normal content purpose with
    /// default hints (auto completion, auto correction, auto capitalization)
    /// should be assumed.
    public func setContentType(hint: UInt32, purpose: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            WaylandData.uint(hint),
            WaylandData.uint(purpose)
        ])
        connection.send(message: message)
    }
    
    public func setCursorRectangle(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 7, contents: [
            WaylandData.int(x),
            WaylandData.int(y),
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    /// Sets Preferred Language
    /// 
    /// Sets a specific language. This allows for example a virtual keyboard to
    /// show a language specific layout. The "language" argument is an RFC-3066
    /// format language tag.
    /// It could be used for example in a word processor to indicate the
    /// language of the currently edited document or in an instant message
    /// application which tracks languages of contacts.
    public func setPreferredLanguage(language: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            WaylandData.string(language)
        ])
        connection.send(message: message)
    }
    
    /// - Parameters:
    ///   - Serial: used to identify the known state
    public func commitState(serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 9, contents: [
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    public func invokeAction(button: UInt32, index: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 10, contents: [
            WaylandData.uint(button),
            WaylandData.uint(index)
        ])
        connection.send(message: message)
    }
    
    /// Content Hint
    /// 
    /// Content hint is a bitmask to allow to modify the behavior of the text
    /// input.
    public enum ContentHint: UInt32, WlEnum {
        /// No Special Behaviour
        case `none` = 0x0
        
        /// Auto Completion, Correction And Capitalization
        case `default` = 0x7
        
        /// Hidden And Sensitive Text
        case password = 0xc0
        
        /// Suggest Word Completions
        case autoCompletion = 0x1
        
        /// Suggest Word Corrections
        case autoCorrection = 0x2
        
        /// Switch To Uppercase Letters At The Start Of A Sentence
        case autoCapitalization = 0x4
        
        /// Prefer Lowercase Letters
        case lowercase = 0x8
        
        /// Prefer Uppercase Letters
        case uppercase = 0x10
        
        /// Prefer Casing For Titles And Headings (Can Be Language Dependent)
        case titlecase = 0x20
        
        /// Characters Should Be Hidden
        case hiddenText = 0x40
        
        /// Typed Text Should Not Be Stored
        case sensitiveData = 0x80
        
        /// Just Latin Characters Should Be Entered
        case latin = 0x100
        
        /// The Text Input Is Multiline
        case multiline = 0x200
    }
    
    /// Content Purpose
    /// 
    /// The content purpose allows to specify the primary purpose of a text
    /// input.
    /// This allows an input method to show special purpose input panels with
    /// extra characters or to disallow some characters.
    public enum ContentPurpose: UInt32, WlEnum {
        /// Default Input, Allowing All Characters
        case normal = 0
        
        /// Allow Only Alphabetic Characters
        case alpha = 1
        
        /// Allow Only Digits
        case digits = 2
        
        /// Input A Number (Including Decimal Separator And Sign)
        case number = 3
        
        /// Input A Phone Number
        case phone = 4
        
        /// Input An Url
        case url = 5
        
        /// Input An Email Address
        case email = 6
        
        /// Input A Name Of A Person
        case name = 7
        
        /// Input A Password (Combine With Password Or Sensitive_Data Hint)
        case password = 8
        
        /// Input A Date
        case date = 9
        
        /// Input A Time
        case time = 10
        
        /// Input A Date And Time
        case datetime = 11
        
        /// Input For A Terminal
        case terminal = 12
    }
    
    public enum PreeditStyle: UInt32, WlEnum {
        /// Default Style For Composing Text
        case `default` = 0
        
        /// Style Should Be The Same As In Non-Composing Text
        case `none` = 1
        
        case active = 2
        
        case inactive = 3
        
        case highlight = 4
        
        case underline = 5
        
        case selection = 6
        
        case incorrect = 7
    }
    
    public enum TextDirection: UInt32, WlEnum {
        /// Automatic Text Direction Based On Text And Language
        case auto = 0
        
        /// Left-To-Right
        case ltr = 1
        
        /// Right-To-Left
        case rtl = 2
    }
    
    public enum Event: WlEventEnum {
        /// Enter Event
        /// 
        /// Notify the text_input object when it received focus. Typically in
        /// response to an activate request.
        case enter(surface: WlSurface)
        
        /// Leave Event
        /// 
        /// Notify the text_input object when it lost focus. Either in response
        /// to a deactivate request or when the assigned surface lost focus or was
        /// destroyed.
        case leave
        
        /// Modifiers Map
        /// 
        /// Transfer an array of 0-terminated modifier names. The position in
        /// the array is the index of the modifier as used in the modifiers
        /// bitmask in the keysym event.
        case modifiersMap(map: Data)
        
        /// State Of The Input Panel
        /// 
        /// Notify when the visibility state of the input panel changed.
        case inputPanelState(state: UInt32)
        
        /// Pre-Edit
        /// 
        /// Notify when a new composing text (pre-edit) should be set around the
        /// current cursor position. Any previously set composing text should
        /// be removed.
        /// The commit text can be used to replace the preedit text on reset
        /// (for example on unfocus).
        /// The text input should also handle all preedit_style and preedit_cursor
        /// events occurring directly before preedit_string.
        /// 
        /// - Parameters:
        ///   - Serial: serial of the latest known text input state
        case preeditString(serial: UInt32, text: String, commit: String)
        
        /// Pre-Edit Styling
        /// 
        /// Sets styling information on composing text. The style is applied for
        /// length bytes from index relative to the beginning of the composing
        /// text (as byte offset). Multiple styles can
        /// be applied to a composing text by sending multiple preedit_styling
        /// events.
        /// This event is handled as part of a following preedit_string event.
        case preeditStyling(index: UInt32, length: UInt32, style: UInt32)
        
        /// Pre-Edit Cursor
        /// 
        /// Sets the cursor position inside the composing text (as byte
        /// offset) relative to the start of the composing text. When index is a
        /// negative number no cursor is shown.
        /// This event is handled as part of a following preedit_string event.
        case preeditCursor(index: Int32)
        
        /// Commit
        /// 
        /// Notify when text should be inserted into the editor widget. The text to
        /// commit could be either just a single character after a key press or the
        /// result of some composing (pre-edit). It could also be an empty text
        /// when some text should be removed (see delete_surrounding_text) or when
        /// the input cursor should be moved (see cursor_position).
        /// Any previously set composing text should be removed.
        /// 
        /// - Parameters:
        ///   - Serial: serial of the latest known text input state
        case commitString(serial: UInt32, text: String)
        
        /// Set Cursor To New Position
        /// 
        /// Notify when the cursor or anchor position should be modified.
        /// This event should be handled as part of a following commit_string
        /// event.
        case cursorPosition(index: Int32, anchor: Int32)
        
        /// Delete Surrounding Text
        /// 
        /// Notify when the text around the current cursor position should be
        /// deleted.
        /// Index is relative to the current cursor (in bytes).
        /// Length is the length of deleted text (in bytes).
        /// This event should be handled as part of a following commit_string
        /// event.
        case deleteSurroundingText(index: Int32, length: UInt32)
        
        /// Keysym
        /// 
        /// Notify when a key event was sent. Key events should not be used
        /// for normal text input operations, which should be done with
        /// commit_string, delete_surrounding_text, etc. The key event follows
        /// the wl_keyboard key event convention. Sym is an XKB keysym, state a
        /// wl_keyboard key_state. Modifiers are a mask for effective modifiers
        /// (where the modifier indices are set by the modifiers_map event)
        /// 
        /// - Parameters:
        ///   - Serial: serial of the latest known text input state
        case keysym(serial: UInt32, time: UInt32, sym: UInt32, state: UInt32, modifiers: UInt32)
        
        /// Language
        /// 
        /// Sets the language of the input text. The "language" argument is an
        /// RFC-3066 format language tag.
        /// 
        /// - Parameters:
        ///   - Serial: serial of the latest known text input state
        case language(serial: UInt32, language: String)
        
        /// Text Direction
        /// 
        /// Sets the text direction of input text.
        /// It is mainly needed for showing an input cursor on the correct side of
        /// the editor when there is no input done yet and making sure neutral
        /// direction text is laid out properly.
        /// 
        /// - Parameters:
        ///   - Serial: serial of the latest known text input state
        case textDirection(serial: UInt32, direction: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.enter(surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 1:
                return Self.leave
            case 2:
                return Self.modifiersMap(map: r.readArray())
            case 3:
                return Self.inputPanelState(state: r.readUInt())
            case 4:
                return Self.preeditString(serial: r.readUInt(), text: r.readString(), commit: r.readString())
            case 5:
                return Self.preeditStyling(index: r.readUInt(), length: r.readUInt(), style: r.readUInt())
            case 6:
                return Self.preeditCursor(index: r.readInt())
            case 7:
                return Self.commitString(serial: r.readUInt(), text: r.readString())
            case 8:
                return Self.cursorPosition(index: r.readInt(), anchor: r.readInt())
            case 9:
                return Self.deleteSurroundingText(index: r.readInt(), length: r.readUInt())
            case 10:
                return Self.keysym(serial: r.readUInt(), time: r.readUInt(), sym: r.readUInt(), state: r.readUInt(), modifiers: r.readUInt())
            case 11:
                return Self.language(serial: r.readUInt(), language: r.readString())
            case 12:
                return Self.textDirection(serial: r.readUInt(), direction: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
