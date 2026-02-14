import Foundation
import SwiftWayland

/// Text Input
/// 
/// The zwp_text_input_v3 interface represents text input and input methods
/// associated with a seat. It provides enter/leave events to follow the
/// text input focus for a seat.
/// Requests are used to enable/disable the text-input object and set
/// state information like surrounding and selected text or the content type.
/// The information about the entered text is sent to the text-input object
/// via the preedit_string and commit_string events.
/// Text is valid UTF-8 encoded, indices and lengths are in bytes. Indices
/// must not point to middle bytes inside a code point: they must either
/// point to the first byte of a code point or to the end of the buffer.
/// Lengths must be measured between two valid indices.
/// Focus moving throughout surfaces will result in the emission of
/// zwp_text_input_v3.enter and zwp_text_input_v3.leave events. The focused
/// surface must commit zwp_text_input_v3.enable and
/// zwp_text_input_v3.disable requests as the keyboard focus moves across
/// editable and non-editable elements of the UI. Those two requests are not
/// expected to be paired with each other, the compositor must be able to
/// handle consecutive series of the same request.
/// State is sent by the state requests (set_surrounding_text,
/// set_content_type and set_cursor_rectangle) and a commit request. After an
/// enter event or disable request all state information is invalidated and
/// needs to be resent by the client.
public final class ZwpTextInputV3: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_text_input_v3"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Wp_Text_Input
    /// 
    /// Destroy the wp_text_input object. Also disables all surfaces enabled
    /// through this wp_text_input object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Request Text Input To Be Enabled
    /// 
    /// Requests text input on the surface previously obtained from the enter
    /// event.
    /// This request must be issued every time the focused text input changes
    /// to a new one, including within the current surface. Use
    /// zwp_text_input_v3.disable when there is no longer any input focus on
    /// the current surface.
    /// Clients must not enable more than one text input on the single seat
    /// and should disable the current text input before enabling the new one.
    /// Requests to enable a text input when another text input is enabled
    /// on the same seat must be ignored by compositor.
    /// This request resets all state associated with previous enable, disable,
    /// set_surrounding_text, set_text_change_cause, set_content_type, and
    /// set_cursor_rectangle requests, as well as the state associated with
    /// preedit_string, commit_string, and delete_surrounding_text events.
    /// The set_surrounding_text, set_content_type and set_cursor_rectangle
    /// requests must follow if the text input supports the necessary
    /// functionality.
    /// State set with this request is double-buffered. It will get applied on
    /// the next zwp_text_input_v3.commit request, and stay valid until the
    /// next committed enable or disable request.
    /// The changes must be applied by the compositor after issuing a
    /// zwp_text_input_v3.commit request.
    public func enable() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    /// Disable Text Input On A Surface
    /// 
    /// Explicitly disable text input on the current surface (typically when
    /// there is no focus on any text entry inside the surface).
    /// State set with this request is double-buffered. It will get applied on
    /// the next zwp_text_input_v3.commit request.
    public func disable() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
    }
    
    /// Sets The Surrounding Text
    /// 
    /// Sets the surrounding plain text around the input, excluding the preedit
    /// text.
    /// The client should notify the compositor of any changes in any of the
    /// values carried with this request, including changes caused by handling
    /// incoming text-input events as well as changes caused by other
    /// mechanisms like keyboard typing.
    /// If the client is unaware of the text around the cursor, it should not
    /// issue this request, to signify lack of support to the compositor.
    /// Text is UTF-8 encoded, and should include the cursor position, the
    /// complete selection and additional characters before and after them.
    /// There is a maximum length of wayland messages, so text can not be
    /// longer than 4000 bytes.
    /// Cursor is the byte offset of the cursor within text buffer.
    /// Anchor is the byte offset of the selection anchor within text buffer.
    /// If there is no selected text, anchor is the same as cursor.
    /// If any preedit text is present, it is replaced with a cursor for the
    /// purpose of this event.
    /// Values set with this request are double-buffered. They will get applied
    /// on the next zwp_text_input_v3.commit request, and stay valid until the
    /// next committed enable or disable request.
    /// The initial state for affected fields is empty, meaning that the text
    /// input does not support sending surrounding text. If the empty values
    /// get applied, subsequent attempts to change them may have no effect.
    public func setSurroundingText(text: String, cursor: Int32, anchor: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.string(text),
            WaylandData.int(cursor),
            WaylandData.int(anchor)
        ])
        connection.send(message: message)
    }
    
    /// Indicates The Cause Of Surrounding Text Change
    /// 
    /// Tells the compositor why the text surrounding the cursor changed.
    /// Whenever the client detects an external change in text, cursor, or
    /// anchor posision, it must issue this request to the compositor. This
    /// request is intended to give the input method a chance to update the
    /// preedit text in an appropriate way, e.g. by removing it when the user
    /// starts typing with a keyboard.
    /// cause describes the source of the change.
    /// The value set with this request is double-buffered. It must be applied
    /// and reset to initial at the next zwp_text_input_v3.commit request.
    /// The initial value of cause is input_method.
    public func setTextChangeCause(cause: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.uint(cause)
        ])
        connection.send(message: message)
    }
    
    /// Set Content Purpose And Hint
    /// 
    /// Sets the content purpose and content hint. While the purpose is the
    /// basic purpose of an input field, the hint flags allow to modify some of
    /// the behavior.
    /// Values set with this request are double-buffered. They will get applied
    /// on the next zwp_text_input_v3.commit request.
    /// Subsequent attempts to update them may have no effect. The values
    /// remain valid until the next committed enable or disable request.
    /// The initial value for hint is none, and the initial value for purpose
    /// is normal.
    public func setContentType(hint: UInt32, purpose: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.uint(hint),
            WaylandData.uint(purpose)
        ])
        connection.send(message: message)
    }
    
    /// Set Cursor Position
    /// 
    /// Marks an area around the cursor as a x, y, width, height rectangle in
    /// surface local coordinates.
    /// Allows the compositor to put a window with word suggestions near the
    /// cursor, without obstructing the text being input.
    /// If the client is unaware of the position of edited text, it should not
    /// issue this request, to signify lack of support to the compositor.
    /// Values set with this request are double-buffered. They will get applied
    /// on the next zwp_text_input_v3.commit request, and stay valid until the
    /// next committed enable or disable request.
    /// The initial values describing a cursor rectangle are empty. That means
    /// the text input does not support describing the cursor area. If the
    /// empty values get applied, subsequent attempts to change them may have
    /// no effect.
    public func setCursorRectangle(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            WaylandData.int(x),
            WaylandData.int(y),
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    /// Commit State
    /// 
    /// Atomically applies state changes recently sent to the compositor.
    /// The commit request establishes and updates the state of the client, and
    /// must be issued after any changes to apply them.
    /// Text input state (enabled status, content purpose, content hint,
    /// surrounding text and change cause, cursor rectangle) is conceptually
    /// double-buffered within the context of a text input, i.e. between a
    /// committed enable request and the following committed enable or disable
    /// request.
    /// Protocol requests modify the pending state, as opposed to the current
    /// state in use by the input method. A commit request atomically applies
    /// all pending state, replacing the current state. After commit, the new
    /// pending state is as documented for each related request.
    /// Requests are applied in the order of arrival.
    /// Neither current nor pending state are modified unless noted otherwise.
    /// The compositor must count the number of commit requests coming from
    /// each zwp_text_input_v3 object and use the count as the serial in done
    /// events.
    public func commit() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 7, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Text Change Reason
    /// 
    /// Reason for the change of surrounding text or cursor posision.
    public enum ChangeCause: UInt32, WlEnum {
        /// Input Method Caused The Change
        case inputMethod = 0
        
        /// Something Else Than The Input Method Caused The Change
        case other = 1
    }
    
    /// Content Hint
    /// 
    /// Content hint is a bitmask to allow to modify the behavior of the text
    /// input.
    public enum ContentHint: UInt32, WlEnum {
        /// No Special Behavior
        case `none` = 0x0
        
        /// Suggest Word Completions
        case completion = 0x1
        
        /// Suggest Word Corrections
        case spellcheck = 0x2
        
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
        
        /// Input A Password (Combine With Sensitive_Data Hint)
        case password = 8
        
        /// Input Is A Numeric Password (Combine With Sensitive_Data Hint)
        case pin = 9
        
        /// Input A Date
        case date = 10
        
        /// Input A Time
        case time = 11
        
        /// Input A Date And Time
        case datetime = 12
        
        /// Input For A Terminal
        case terminal = 13
    }
    
    public enum Event: WlEventEnum {
        /// Enter Event
        /// 
        /// Notification that this seat's text-input focus is on a certain surface.
        /// If client has created multiple text input objects, compositor must send
        /// this event to all of them.
        /// When the seat has the keyboard capability the text-input focus follows
        /// the keyboard focus. This event sets the current surface for the
        /// text-input object.
        case enter(surface: WlSurface)
        
        /// Leave Event
        /// 
        /// Notification that this seat's text-input focus is no longer on a
        /// certain surface. The client should reset any preedit string previously
        /// set.
        /// The leave notification clears the current surface. It is sent before
        /// the enter notification for the new focus. After leave event, compositor
        /// must ignore requests from any text input instances until next enter
        /// event.
        /// When the seat has the keyboard capability the text-input focus follows
        /// the keyboard focus.
        case leave(surface: WlSurface)
        
        /// Pre-Edit
        /// 
        /// Notify when a new composing text (pre-edit) should be set at the
        /// current cursor position. Any previously set composing text must be
        /// removed. Any previously existing selected text must be removed.
        /// The argument text contains the pre-edit string buffer.
        /// The parameters cursor_begin and cursor_end are counted in bytes
        /// relative to the beginning of the submitted text buffer. Cursor should
        /// be hidden when both are equal to -1.
        /// They could be represented by the client as a line if both values are
        /// the same, or as a text highlight otherwise.
        /// Values set with this event are double-buffered. They must be applied
        /// and reset to initial on the next zwp_text_input_v3.done event.
        /// The initial value of text is an empty string, and cursor_begin,
        /// cursor_end and cursor_hidden are all 0.
        case preeditString(text: String, cursorBegin: Int32, cursorEnd: Int32)
        
        /// Text Commit
        /// 
        /// Notify when text should be inserted into the editor widget. The text to
        /// commit could be either just a single character after a key press or the
        /// result of some composing (pre-edit).
        /// Values set with this event are double-buffered. They must be applied
        /// and reset to initial on the next zwp_text_input_v3.done event.
        /// The initial value of text is an empty string.
        case commitString(text: String)
        
        /// Delete Surrounding Text
        /// 
        /// Notify when the text around the current cursor position should be
        /// deleted.
        /// Before_length and after_length are the number of bytes before and after
        /// the current cursor index (excluding the selection) to delete.
        /// If a preedit text is present, in effect before_length is counted from
        /// the beginning of it, and after_length from its end (see done event
        /// sequence).
        /// Values set with this event are double-buffered. They must be applied
        /// and reset to initial on the next zwp_text_input_v3.done event.
        /// The initial values of both before_length and after_length are 0.
        /// 
        /// - Parameters:
        ///   - BeforeLength: length of text before current cursor position
        ///   - AfterLength: length of text after current cursor position
        case deleteSurroundingText(beforeLength: UInt32, afterLength: UInt32)
        
        /// Apply Changes
        /// 
        /// Instruct the application to apply changes to state requested by the
        /// preedit_string, commit_string and delete_surrounding_text events. The
        /// state relating to these events is double-buffered, and each one
        /// modifies the pending state. This event replaces the current state with
        /// the pending state.
        /// The application must proceed by evaluating the changes in the following
        /// order:
        /// 1. Replace existing preedit string with the cursor.
        /// 2. Delete requested surrounding text.
        /// 3. Insert commit string with the cursor at its end.
        /// 4. Calculate surrounding text to send.
        /// 5. Insert new preedit text in cursor position.
        /// 6. Place cursor inside preedit text.
        /// The serial number reflects the last state of the zwp_text_input_v3
        /// object known to the compositor. The value of the serial argument must
        /// be equal to the number of commit requests already issued on that object.
        /// When the client receives a done event with a serial different than the
        /// number of past commit requests, it must proceed with evaluating and
        /// applying the changes as normal, except it should not change the current
        /// state of the zwp_text_input_v3 object. All pending state requests
        /// (set_surrounding_text, set_content_type and set_cursor_rectangle) on
        /// the zwp_text_input_v3 object should be sent and committed after
        /// receiving a zwp_text_input_v3.done event with a matching serial.
        case done(serial: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.enter(surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 1:
                return Self.leave(surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 2:
                return Self.preeditString(text: r.readString(), cursorBegin: r.readInt(), cursorEnd: r.readInt())
            case 3:
                return Self.commitString(text: r.readString())
            case 4:
                return Self.deleteSurroundingText(beforeLength: r.readUInt(), afterLength: r.readUInt())
            case 5:
                return Self.done(serial: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
