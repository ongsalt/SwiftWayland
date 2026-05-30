import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Text Input
/// 
/// An object used for text input. Adds support for text input and input
/// methods to applications. A text-input object is created from a
/// wl_text_input_manager and corresponds typically to a text entry in an
/// application.
/// Requests are used to activate/deactivate the text-input object and set
/// state information like surrounding and selected text or the content type.
/// The information about entered text is sent to the text-input object via
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
public final class WlTextInput: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wl_text_input",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "activate",
                    arguments: [
                    Argument(
                        name: "seat",
                        type: .object,
                        interface: "wl_seat"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "deactivate",
                    arguments: [
                    Argument(
                        name: "seat",
                        type: .object,
                        interface: "wl_seat"
                    ),
                    ],
                ),
                Message(
                    name: "show_input_panel",
                    arguments: [
                    ],
                ),
                Message(
                    name: "hide_input_panel",
                    arguments: [
                    ],
                ),
                Message(
                    name: "reset",
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
                        type: .uint,
                    ),
                    Argument(
                        name: "anchor",
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
                    name: "set_preferred_language",
                    arguments: [
                    Argument(
                        name: "language",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "commit_state",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "invoke_action",
                    arguments: [
                    Argument(
                        name: "button",
                        type: .uint,
                    ),
                    Argument(
                        name: "index",
                        type: .uint,
                    ),
                    ],
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
                    ],
                ),
                Message(
                    name: "modifiers_map",
                    arguments: [
                    Argument(
                        name: "map",
                        type: .array,
                    ),
                    ],
                ),
                Message(
                    name: "input_panel_state",
                    arguments: [
                    Argument(
                        name: "state",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "preedit_string",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "text",
                        type: .string,
                    ),
                    Argument(
                        name: "commit",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "preedit_styling",
                    arguments: [
                    Argument(
                        name: "index",
                        type: .uint,
                    ),
                    Argument(
                        name: "length",
                        type: .uint,
                    ),
                    Argument(
                        name: "style",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "preedit_cursor",
                    arguments: [
                    Argument(
                        name: "index",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "commit_string",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "text",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "cursor_position",
                    arguments: [
                    Argument(
                        name: "index",
                        type: .int,
                    ),
                    Argument(
                        name: "anchor",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "delete_surrounding_text",
                    arguments: [
                    Argument(
                        name: "index",
                        type: .int,
                    ),
                    Argument(
                        name: "length",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "keysym",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "time",
                        type: .uint,
                    ),
                    Argument(
                        name: "sym",
                        type: .uint,
                    ),
                    Argument(
                        name: "state",
                        type: .uint,
                    ),
                    Argument(
                        name: "modifiers",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "language",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "language",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "text_direction",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "direction",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
    /// Request Activation
    /// 
    /// Requests the text-input object to be activated (typically when the
    /// text entry gets focus).
    /// The seat argument is a wl_seat which maintains the focus for this
    /// activation. The surface argument is a wl_surface assigned to the
    /// text-input object and tracked for focus lost. The enter event
    /// is emitted on successful activation.
    /// 
    /// - Parameters:
    public func activate(seat: WlSeat, surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(seat.id),
            .object(surface.id),
        ])
    }

    /// Request Deactivation
    /// 
    /// Requests the text-input object to be deactivated (typically when the
    /// text entry lost focus). The seat argument is a wl_seat which was used
    /// for activation.
    /// 
    /// - Parameters:
    public func deactivate(seat: WlSeat) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(seat.id),
        ])
    }

    /// Show Input Panels
    /// 
    /// Requests input panels (virtual keyboard) to show.
    public func showInputPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    /// Hide Input Panels
    /// 
    /// Requests input panels (virtual keyboard) to hide.
    public func hideInputPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
        ])
    }

    /// Reset
    /// 
    /// Should be called by an editor widget when the input state should be
    /// reset, for example after the text was changed outside of the normal
    /// input method flow.
    public func reset() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
        ])
    }

    /// Sets The Surrounding Text
    /// 
    /// Sets the plain surrounding text around the input position. Text is
    /// UTF-8 encoded. Cursor is the byte offset within the
    /// surrounding text. Anchor is the byte offset of the
    /// selection anchor within the surrounding text. If there is no selected
    /// text anchor is the same as cursor.
    /// 
    /// - Parameters:
    public func setSurroundingText(text: String, cursor: UInt32, anchor: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .string(text),
            .uint(cursor),
            .uint(anchor),
        ])
    }

    /// Set Content Purpose And Hint
    /// 
    /// Sets the content purpose and content hint. While the purpose is the
    /// basic purpose of an input field, the hint flags allow to modify some
    /// of the behavior.
    /// When no content type is explicitly set, a normal content purpose with
    /// default hints (auto completion, auto correction, auto capitalization)
    /// should be assumed.
    /// 
    /// - Parameters:
    public func setContentType(hint: UInt32, purpose: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .uint(hint),
            .uint(purpose),
        ])
    }

    /// 
    /// - Parameters:
    public func setCursorRectangle(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
            .int(x),
            .int(y),
            .int(width),
            .int(height),
        ])
    }

    /// Sets Preferred Language
    /// 
    /// Sets a specific language. This allows for example a virtual keyboard to
    /// show a language specific layout. The "language" argument is a RFC-3066
    /// format language tag.
    /// It could be used for example in a word processor to indicate language of
    /// currently edited document or in an instant message application which tracks
    /// languages of contacts.
    /// 
    /// - Parameters:
    public func setPreferredLanguage(language: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .string(language),
        ])
    }

    /// 
    /// - Parameters:
    ///   - serial: used to identify the known state
    public func commitState(serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 9, [
            .uint(serial),
        ])
    }

    /// 
    /// - Parameters:
    public func invokeAction(button: UInt32, index: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 10, [
            .uint(button),
            .uint(index),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TextProtocol)
    }
    
    public enum ContentHint: UInt32 {
        /// no special behaviour
        case `none` = 0

        /// auto completion, correction and capitalization
        case `default` = 7

        /// hidden and sensitive text
        case password = 192

        /// suggest word completions
        case autoCompletion = 1

        /// suggest word corrections
        case autoCorrection = 2

        /// switch to uppercase letters at the start of a sentence
        case autoCapitalization = 4

        /// prefer lowercase letters
        case lowercase = 8

        /// prefer uppercase letters
        case uppercase = 16

        /// prefer casing for titles and headings (can be language dependent)
        case titlecase = 32

        /// characters should be hidden
        case hiddenText = 64

        /// typed text should not be stored
        case sensitiveData = 128

        /// just latin characters should be entered
        case latin = 256

        /// the text input is multiline
        case multiline = 512
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

        /// input a password (combine with password or sensitive_data hint)
        case password = 8

        /// input a date
        case date = 9

        /// input a time
        case time = 10

        /// input a date and time
        case datetime = 11

        /// input for a terminal
        case terminal = 12
    }

    public enum PreeditStyle: UInt32 {
        /// default style for composing text
        case `default` = 0

        /// style should be the same as in non-composing text
        case `none` = 1

        case active = 2

        case inactive = 3

        case highlight = 4

        case underline = 5

        case selection = 6

        case incorrect = 7
    }

    public enum TextDirection: UInt32 {
        /// automatic text direction based on text and language
        case auto = 0

        /// left-to-right
        case ltr = 1

        /// right-to-left
        case rtl = 2
    }

    public enum Event: Decodable {
        /// Enter Event
        /// 
        /// Notify the text-input object when it received focus. Typically in
        /// response to an activate request.
        case enter(surface: WlSurface)

        /// Leave Event
        /// 
        /// Notify the text-input object when it lost focus. Either in response
        /// to a deactivate request or when the assigned surface lost focus or was
        /// destroyed.
        case leave

        /// Modifiers Map
        /// 
        /// Transfer an array of 0-terminated modifiers names. The position in
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
        /// result of some composing (pre-edit). It could be also an empty text
        /// when some text should be removed (see delete_surrounding_text) or when
        /// the input cursor should be moved (see cursor_position).
        /// Any previously set composing text should be removed.
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
        /// the wl_keyboard key event convention. Sym is a XKB keysym, state a
        /// wl_keyboard key_state. Modifiers are a mask for effective modifiers
        /// (where the modifier indices are set by the modifiers_map event)
        case keysym(serial: UInt32, time: UInt32, sym: UInt32, state: UInt32, modifiers: UInt32)

        /// Language
        /// 
        /// Sets the language of the input text. The "language" argument is a RFC-3066
        /// format language tag.
        case language(serial: UInt32, language: String)

        /// Text Direction
        /// 
        /// Sets the text direction of input text.
        /// It is mainly needed for showing input cursor on correct side of the
        /// editor when there is no input yet done and making sure neutral
        /// direction text is laid out properly.
        case textDirection(serial: UInt32, direction: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.enter(surface: r.object(type: WlSurface.self))
            case 1:
                self = Self.leave
            case 2:
                self = Self.modifiersMap(map: r.array())
            case 3:
                self = Self.inputPanelState(state: r.uint())
            case 4:
                self = Self.preeditString(serial: r.uint(), text: r.string(), commit: r.string())
            case 5:
                self = Self.preeditStyling(index: r.uint(), length: r.uint(), style: r.uint())
            case 6:
                self = Self.preeditCursor(index: r.int())
            case 7:
                self = Self.commitString(serial: r.uint(), text: r.string())
            case 8:
                self = Self.cursorPosition(index: r.int(), anchor: r.int())
            case 9:
                self = Self.deleteSurroundingText(index: r.int(), length: r.uint())
            case 10:
                self = Self.keysym(serial: r.uint(), time: r.uint(), sym: r.uint(), state: r.uint(), modifiers: r.uint())
            case 11:
                self = Self.language(serial: r.uint(), language: r.string())
            case 12:
                self = Self.textDirection(serial: r.uint(), direction: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Text Input Manager
/// 
/// A factory for text-input objects. This object is a global singleton.
public final class WlTextInputManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wl_text_input_manager",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "create_text_input",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wl_text_input"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Create Text Input
    /// 
    /// Creates a new text-input object.
    public func createTextInput(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WlTextInput {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlTextInput.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TextProtocol)
    }
    
    public typealias Event = NoEvent
}

public let TextProtocol = Protocol(
        name: "text",
        interfaces: [
            WlTextInput.interface,
WlTextInputManager.interface
        ]
    )

#endif