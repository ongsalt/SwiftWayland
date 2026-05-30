import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if UNSTABLE
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
public final class ZwpTextInputV3: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_text_input_v3",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "enable",
                    arguments: [
                    ],
                ),
                Message(
                    name: "disable",
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_surrounding_text",
                    arguments: [
                    Argument(
                        name: "text",
                        type: .string,
                    ),
                    Argument(
                        name: "cursor",
                        type: .int,
                    ),
                    Argument(
                        name: "anchor",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "set_text_change_cause",
                    arguments: [
                    Argument(
                        name: "cause",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_content_type",
                    arguments: [
                    Argument(
                        name: "hint",
                        type: .uint,
                    ),
                    Argument(
                        name: "purpose",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_cursor_rectangle",
                    arguments: [
                    Argument(
                        name: "x",
                        type: .int,
                    ),
                    Argument(
                        name: "y",
                        type: .int,
                    ),
                    Argument(
                        name: "width",
                        type: .int,
                    ),
                    Argument(
                        name: "height",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "commit",
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_available_actions",
                    arguments: [
                    Argument(
                        name: "available_actions",
                        type: .array,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "show_input_panel",
                    arguments: [
                    ],
                    since: 2
                ),
                Message(
                    name: "hide_input_panel",
                    arguments: [
                    ],
                    since: 2
                ),
                ],
            events: [
                Message(
                    name: "enter",
                    arguments: [
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "leave",
                    arguments: [
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "preedit_string",
                    arguments: [
                    Argument(
                        name: "text",
                        type: .string,
                    ),
                    Argument(
                        name: "cursor_begin",
                        type: .int,
                    ),
                    Argument(
                        name: "cursor_end",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "commit_string",
                    arguments: [
                    Argument(
                        name: "text",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "delete_surrounding_text",
                    arguments: [
                    Argument(
                        name: "before_length",
                        type: .uint,
                    ),
                    Argument(
                        name: "after_length",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "action",
                    arguments: [
                    Argument(
                        name: "action",
                        type: .uint,
                    ),
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "language",
                    arguments: [
                    Argument(
                        name: "language",
                        type: .string,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "preedit_hint",
                    arguments: [
                    Argument(
                        name: "start",
                        type: .uint,
                    ),
                    Argument(
                        name: "end",
                        type: .uint,
                    ),
                    Argument(
                        name: "hint",
                        type: .uint,
                    ),
                    ],
                    since: 2
                ),
                ],
        )
    /// Destroy The Wp_Text_Input
    /// 
    /// Destroy the wp_text_input object. Also disables all surfaces enabled
    /// through this wp_text_input object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
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
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    /// Disable Text Input On A Surface
    /// 
    /// Explicitly disable text input on the current surface (typically when
    /// there is no focus on any text entry inside the surface).
    /// State set with this request is double-buffered. It will get applied on
    /// the next zwp_text_input_v3.commit request.
    public func disable() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
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
    /// 
    /// - Parameters:
    public func setSurroundingText(text: String, cursor: Int32, anchor: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .string(text),
            .int(cursor),
            .int(anchor),
        ])
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
    /// 
    /// - Parameters:
    public func setTextChangeCause(cause: ChangeCause) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .uint(cause.rawValue),
        ])
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
    /// 
    /// - Parameters:
    public func setContentType(hint: ContentHint, purpose: ContentPurpose) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .uint(hint.rawValue),
            .uint(purpose.rawValue),
        ])
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
    /// As of version 2, the zwp_text_input_v3.commit request does not apply
    /// values sent with this request. Instead, it stores them in a separate
    /// "committed" area. The committed values, if still valid, get applied on
    /// the next wl_surface.commit request on the surface with text-input focus.
    /// Both committed and applied values get invalidated on:
    /// - the next committed enable or disable request, or
    /// - a change of the focused surface of the text-input (leave or enter events).
    /// This double stage application allows the compositor to position
    /// the input method popup in the same frame as the contents
    /// of the text on the surface are updated.
    /// 
    /// - Parameters:
    public func setCursorRectangle(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .int(x),
            .int(y),
            .int(width),
            .int(height),
        ])
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
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
        ])
    }

    /// Set The Available Actions
    /// 
    /// Set the actions available for this text input.
    /// Values set with this request are double-buffered. They will get applied
    /// on the next zwp_text_input_v3.commit request.
    /// If the available_actions array contains the none action, or contains the
    /// same action multiple times, the compositor must raise the invalid_action
    /// protocol error.
    /// Initially, no actions are available.
    /// 
    /// - Parameters:
    ///   - _: available actions
    public func setAvailableActions(_ availableActions: Data) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 8, [
            .array(availableActions),
        ])
    }

    /// Show Input Panel
    /// 
    /// Requests an input panel to be shown (e.g. a on-screen keyboard).
    /// This request only hints the desired interaction pattern from the
    /// client side, and its effect may be ignored by compositors given
    /// other environmental factors. Repeated calls will be ignored.
    public func showInputPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 9, [
        ])
    }

    /// Hide Input Panel
    /// 
    /// Requests an input panel to be hidden.
    /// This request only hints the desired interaction pattern from the
    /// client side, and its effect may be ignored by compositors given
    /// other environmental factors. Repeated calls will be ignored.
    public func hideInputPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 10, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TextInputUnstableV3)
    }
    
    public enum ChangeCause: UInt32 {
        /// input method caused the change
        case inputMethod = 0

        /// something else than the input method caused the change
        case other = 1
    }

    public struct ContentHint: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// no special behavior
        static let `none`: ContentHint = []

        /// suggest word completions
        static let completion = ContentHint(rawValue: 1)

        /// suggest word corrections
        static let spellcheck = ContentHint(rawValue: 2)

        /// switch to uppercase letters at the start of a sentence
        static let autoCapitalization = ContentHint(rawValue: 4)

        /// prefer lowercase letters
        static let lowercase = ContentHint(rawValue: 8)

        /// prefer uppercase letters
        static let uppercase = ContentHint(rawValue: 16)

        /// prefer casing for titles and headings (can be language dependent)
        static let titlecase = ContentHint(rawValue: 32)

        /// characters should be hidden
        static let hiddenText = ContentHint(rawValue: 64)

        /// typed text should not be stored
        static let sensitiveData = ContentHint(rawValue: 128)

        /// just Latin characters should be entered
        static let latin = ContentHint(rawValue: 256)

        /// the text input is multiline
        static let multiline = ContentHint(rawValue: 512)

        /// an on-screen way to fill in the input is already provided by the client
        static let onScreenInputProvided = ContentHint(rawValue: 1024)

        /// prefer not offering emoji support
        static let noEmoji = ContentHint(rawValue: 2048)

        /// the text input will display preedit text in place
        static let preeditShown = ContentHint(rawValue: 4096)
    }

    public enum ContentPurpose: UInt32 {
        /// default input, allowing all characters
        case normal = 0

        /// allow only alphabetic characters
        case alpha = 1

        /// allow only digits
        case digits = 2

        /// input a number (including decimal separator and sign)
        case number = 3

        /// input a phone number
        case phone = 4

        /// input an URL
        case url = 5

        /// input an email address
        case email = 6

        /// input a name of a person
        case name = 7

        /// input a password (combine with sensitive_data hint)
        case password = 8

        /// input is a numeric password (combine with sensitive_data hint)
        case pin = 9

        /// input a date
        case date = 16

        /// input a time
        case time = 17

        /// input a date and time
        case datetime = 18

        /// input for a terminal
        case terminal = 19
    }

    public enum Error: UInt32 {
        /// an invalid or duplicate action was specified
        case invalidAction = 0
    }

    public enum Action: UInt32 {
        /// no action
        case `none` = 0

        /// the action is submitted
        case submit = 1
    }

    public enum PreeditHint: UInt32 {
        /// simple pre-edit text style, typically underlined
        case whole = 1

        /// hint for a selected piece of text, e.g. per-character navigation and composition
        case selection = 2

        /// predicted text, not typed by the user
        case prediction = 3

        /// prefixed text not being currently edited, e.g. prior to a 'selection' section
        case `prefix` = 4

        /// suffixed text not being currently edited, e.g. after a 'selection' section
        case suffix = 5

        /// spelling error
        case spellingError = 6

        /// wrong composition, e.g. user input that can not be transliterated
        case composeError = 7
    }

    public enum Event: Decodable {
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
        case deleteSurroundingText(beforeLength: UInt32, afterLength: UInt32)

        /// Apply Changes
        /// 
        /// Instruct the application to apply changes to state requested by the
        /// preedit_string, commit_string delete_surrounding_text, and action
        /// events.
        /// The state relating to these events is double-buffered, and each one
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
        /// 7. Perform the requested action.
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

        /// Action Performed
        /// 
        /// An action was performed on this text input.
        /// Values set with this event are double-buffered. They must be applied
        /// and reset to initial on the next zwp_text_input_v3.done event.
        /// The initial value of action is none.
        case action(action: Action, serial: UInt32)

        /// Notify Of Language Selection
        /// 
        /// Notify the application of language used by the input method.
        /// This event will be sent on creation if known and for all subsequent changes.
        /// The language should be specified as an IETF BCP 47 tag.
        /// Setting an empty string will reset any known language back to the default unknown state.
        case language(language: String)

        /// Pre-Edit
        /// 
        /// Notify of contextual hints for the pre-edit string. This
        /// event is always sent together with a zwp_text_input_v3.preedit_string
        /// event.
        /// The parameters start and end are counted in bytes relative to the
        /// beginning of the text buffer submitted through
        /// zwp_text_input_v3.preedit_string, and represent the substring in the
        /// pre-edit text affected by the hint.
        /// Multiple events may be submitted if the preedit string has different
        /// sections. The extent of hints may overlap. The parts of the preedit
        /// string that are not covered by any zwp_text_input_v3.preedit_hint event,
        /// the text will be considered unhinted. This is also the case if no
        /// preedit_hint event is sent.
        /// Clients should provide recognizable visuals to these hints. if they are
        /// unable to comply with this requisition, it may be preferable for them
        /// keep the preedit_shown content hint disabled.
        /// Values set with this event are double-buffered. They must be applied
        /// and reset on the next zwp_text_input_v3.done event.
        case preeditHint(start: UInt32, end: UInt32, hint: PreeditHint)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.enter(surface: r.object(type: WlSurface.self))
            case 1:
                self = Self.leave(surface: r.object(type: WlSurface.self))
            case 2:
                self = Self.preeditString(text: r.string(), cursorBegin: r.int(), cursorEnd: r.int())
            case 3:
                self = Self.commitString(text: r.string())
            case 4:
                self = Self.deleteSurroundingText(beforeLength: r.uint(), afterLength: r.uint())
            case 5:
                self = Self.done(serial: r.uint())
            case 6:
                self = Self.action(action: try _parseEnum(into: Action.self, r.uint()), serial: r.uint())
            case 7:
                self = Self.language(language: r.string())
            case 8:
                self = Self.preeditHint(start: r.uint(), end: r.uint(), hint: try _parseEnum(into: PreeditHint.self, r.uint()))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Text Input Manager
/// 
/// A factory for text-input objects. This object is a global singleton.
public final class ZwpTextInputManagerV3: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_text_input_manager_v3",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "get_text_input",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_text_input_v3"
                    ),
                    Argument(
                        name: "seat",
                        type: .object,
                        interface: "wl_seat"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Wp_Text_Input_Manager
    /// 
    /// Destroy the wp_text_input_manager object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A New Text Input Object
    /// 
    /// Creates a new text-input object for a given seat.
    /// 
    /// - Parameters:
    public func getTextInput(seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpTextInputV3 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpTextInputV3.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(seat.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TextInputUnstableV3)
    }
    
    public typealias Event = NoEvent
}

public let TextInputUnstableV3 = Protocol(
        name: "text_input_unstable_v3",
        interfaces: [
            ZwpTextInputV3.interface,
ZwpTextInputManagerV3.interface
        ]
    )

#endif