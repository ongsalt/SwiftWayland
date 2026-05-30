import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Text Input
/// 
/// The zwp_text_input_v2 interface represents text input and input methods
/// associated with a seat. It provides enter/leave events to follow the
/// text input focus for a seat.
/// Requests are used to enable/disable the text-input object and set
/// state information like surrounding and selected text or the content type.
/// The information about the entered text is sent to the text-input object
/// via the pre-edit and commit events. Using this interface removes the need
/// for applications to directly process hardware key events and compose text
/// out of them.
/// Text is valid UTF-8 encoded, indices and lengths are in bytes. Indices
/// have to always point to the first byte of an UTF-8 encoded code point.
/// Lengths are not allowed to contain just a part of an UTF-8 encoded code
/// point.
/// State is sent by the state requests (set_surrounding_text,
/// set_content_type, set_cursor_rectangle and set_preferred_language) and
/// an update_state request. After an enter or an input_method_change event
/// all state information is invalidated and needs to be resent from the
/// client. A reset or entering a new widget on client side also
/// invalidates all current state information.
public final class ZwpTextInputV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_text_input_v2",
            version: 1,
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
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "disable",
                    arguments: [
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
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
                    name: "update_state",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "reason",
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
                        name: "serial",
                        type: .uint,
                    ),
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
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
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
                    name: "preedit_string",
                    arguments: [
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
                    name: "modifiers_map",
                    arguments: [
                    Argument(
                        name: "map",
                        type: .array,
                    ),
                    ],
                ),
                Message(
                    name: "keysym",
                    arguments: [
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
                        name: "language",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "text_direction",
                    arguments: [
                    Argument(
                        name: "direction",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "configure_surrounding_text",
                    arguments: [
                    Argument(
                        name: "before_cursor",
                        type: .int,
                    ),
                    Argument(
                        name: "after_cursor",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "input_method_changed",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "flags",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
    /// Destroy The Wp_Text_Input
    /// 
    /// Destroy the wp_text_input object. Also disables all surfaces enabled
    /// through this wp_text_input object
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Enable Text Input For Surface
    /// 
    /// Enable text input in a surface (usually when a text entry inside of it
    /// has focus).
    /// This can be called before or after a surface gets text (or keyboard)
    /// focus via the enter event. Text input to a surface is only active
    /// when it has the current text (or keyboard) focus and is enabled.
    /// 
    /// - Parameters:
    public func enable(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface.id),
        ])
    }

    /// Disable Text Input For Surface
    /// 
    /// Disable text input in a surface (typically when there is no focus on any
    /// text entry inside the surface).
    /// 
    /// - Parameters:
    public func disable(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(surface.id),
        ])
    }

    /// Show Input Panels
    /// 
    /// Requests input panels (virtual keyboard) to show.
    /// This should be used for example to show a virtual keyboard again
    /// (with a tap) after it was closed by pressing on a close button on the
    /// keyboard.
    public func showInputPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
        ])
    }

    /// Hide Input Panels
    /// 
    /// Requests input panels (virtual keyboard) to hide.
    public func hideInputPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
        ])
    }

    /// Sets The Surrounding Text
    /// 
    /// Sets the plain surrounding text around the input position. Text is
    /// UTF-8 encoded. Cursor is the byte offset within the surrounding text.
    /// Anchor is the byte offset of the selection anchor within the
    /// surrounding text. If there is no selected text, anchor is the same as
    /// cursor.
    /// Make sure to always send some text before and after the cursor
    /// except when the cursor is at the beginning or end of text.
    /// When there was a configure_surrounding_text event take the
    /// before_cursor and after_cursor arguments into account for picking how
    /// much surrounding text to send.
    /// There is a maximum length of wayland messages so text can not be
    /// longer than 4000 bytes.
    /// 
    /// - Parameters:
    public func setSurroundingText(text: String, cursor: Int32, anchor: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .string(text),
            .int(cursor),
            .int(anchor),
        ])
    }

    /// Set Content Purpose And Hint
    /// 
    /// Sets the content purpose and content hint. While the purpose is the
    /// basic purpose of an input field, the hint flags allow to modify some
    /// of the behavior.
    /// When no content type is explicitly set, a normal content purpose with
    /// none hint should be assumed.
    /// 
    /// - Parameters:
    public func setContentType(hint: ContentHint, purpose: ContentPurpose) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .uint(hint.rawValue),
            .uint(purpose.rawValue),
        ])
    }

    /// Set Cursor Position
    /// 
    /// Sets the cursor outline as a x, y, width, height rectangle in surface
    /// local coordinates.
    /// Allows the compositor to put a window with word suggestions near the
    /// cursor.
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
    /// currently edited document or in an instant message application which
    /// tracks languages of contacts.
    /// 
    /// - Parameters:
    public func setPreferredLanguage(language: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .string(language),
        ])
    }

    /// Update State
    /// 
    /// Allows to atomically send state updates from client.
    /// This request should follow after a batch of state updating requests
    /// like set_surrounding_text, set_content_type, set_cursor_rectangle and
    /// set_preferred_language.
    /// The flags field indicates why an updated state is sent to the input
    /// method.
    /// Reset should be used by an editor widget after the text was changed
    /// outside of the normal input method flow.
    /// For "change" it is enough to send the changed state, else the full
    /// state should be send.
    /// Serial should be set to the serial from the last enter or
    /// input_method_changed event.
    /// To make sure to not receive outdated input method events after a
    /// reset or switching to a new widget wl_display_sync() should be used
    /// after update_state in these cases.
    /// 
    /// - Parameters:
    ///   - serial: serial of the enter or input_method_changed event
    public func updateState(serial: UInt32, reason: UpdateState) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 9, [
            .uint(serial),
            .uint(reason.rawValue),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TextInputUnstableV2)
    }
    
    public struct ContentHint: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// no special behaviour
        static let `none`: ContentHint = []

        /// suggest word completions
        static let autoCompletion = ContentHint(rawValue: 1)

        /// suggest word corrections
        static let autoCorrection = ContentHint(rawValue: 2)

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

        /// just latin characters should be entered
        static let latin = ContentHint(rawValue: 256)

        /// the text input is multiline
        static let multiline = ContentHint(rawValue: 512)
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
        case time = 16

        /// input a date and time
        case datetime = 17

        /// input for a terminal
        case terminal = 18
    }

    public enum UpdateState: UInt32 {
        /// updated state because it changed
        case change = 0

        /// full state after enter or input_method_changed event
        case full = 1

        /// full state after reset
        case reset = 2

        /// full state after switching focus to a different widget on client side
        case enter = 3
    }

    public enum InputPanelVisibility: UInt32 {
        /// the input panel (virtual keyboard) is hidden
        case hidden = 0

        /// the input panel (virtual keyboard) is visible
        case visible = 1
    }

    public enum PreeditStyle: UInt32 {
        /// default style for composing text
        case `default` = 0

        /// composing text should be shown the same as non-composing text
        case `none` = 1

        /// composing text might be bold
        case active = 2

        /// composing text might be cursive
        case inactive = 3

        /// composing text might have a different background color
        case highlight = 4

        /// composing text might be underlined
        case underline = 5

        /// composing text should be shown the same as selected text
        case selection = 6

        /// composing text might be underlined with a red wavy line
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

    var destructor: Destructor? = .destroy

    enum Destructor {
        case destroy
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .destroy: try? self.destroy()
                case nil: break
            }
        }
    }

    public enum Event: Decodable {
        /// Enter Event
        /// 
        /// Notification that this seat's text-input focus is on a certain surface.
        /// When the seat has the keyboard capability the text-input focus follows
        /// the keyboard focus.
        case enter(serial: UInt32, surface: WlSurface)

        /// Leave Event
        /// 
        /// Notification that this seat's text-input focus is no longer on
        /// a certain surface.
        /// The leave notification is sent before the enter notification
        /// for the new focus.
        /// When the seat has the keyboard capability the text-input focus follows
        /// the keyboard focus.
        case leave(serial: UInt32, surface: WlSurface)

        /// State Of The Input Panel
        /// 
        /// Notification that the visibility of the input panel (virtual keyboard)
        /// changed.
        /// The rectangle x, y, width, height defines the area overlapped by the
        /// input panel (virtual keyboard) on the surface having the text
        /// focus in surface local coordinates.
        /// That can be used to make sure widgets are visible and not covered by
        /// a virtual keyboard.
        case inputPanelState(state: InputPanelVisibility, x: Int32, y: Int32, width: Int32, height: Int32)

        /// Pre-Edit
        /// 
        /// Notify when a new composing text (pre-edit) should be set around the
        /// current cursor position. Any previously set composing text should
        /// be removed.
        /// The commit text can be used to replace the composing text in some cases
        /// (for example when losing focus).
        /// The text input should also handle all preedit_style and preedit_cursor
        /// events occurring directly before preedit_string.
        case preeditString(text: String, commit: String)

        /// Pre-Edit Styling
        /// 
        /// Sets styling information on composing text. The style is applied for
        /// length bytes from index relative to the beginning of the composing
        /// text (as byte offset). Multiple styles can be applied to a composing
        /// text by sending multiple preedit_styling events.
        /// This event is handled as part of a following preedit_string event.
        case preeditStyling(index: UInt32, length: UInt32, style: PreeditStyle)

        /// Pre-Edit Cursor
        /// 
        /// Sets the cursor position inside the composing text (as byte
        /// offset) relative to the start of the composing text. When index is a
        /// negative number no cursor is shown.
        /// When no preedit_cursor event is sent the cursor will be at the end of
        /// the composing text by default.
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
        case commitString(text: String)

        /// Set Cursor To New Position
        /// 
        /// Notify when the cursor or anchor position should be modified.
        /// This event should be handled as part of a following commit_string
        /// event.
        /// The text between anchor and index should be selected.
        case cursorPosition(index: Int32, anchor: Int32)

        /// Delete Surrounding Text
        /// 
        /// Notify when the text around the current cursor position should be
        /// deleted. BeforeLength and afterLength is the length (in bytes) of text
        /// before and after the current cursor position (excluding the selection)
        /// to delete.
        /// This event should be handled as part of a following commit_string
        /// or preedit_string event.
        case deleteSurroundingText(beforeLength: UInt32, afterLength: UInt32)

        /// Modifiers Map
        /// 
        /// Transfer an array of 0-terminated modifiers names. The position in
        /// the array is the index of the modifier as used in the modifiers
        /// bitmask in the keysym event.
        case modifiersMap(map: Data)

        /// Keysym
        /// 
        /// Notify when a key event was sent. Key events should not be used
        /// for normal text input operations, which should be done with
        /// commit_string, delete_surrounding_text, etc. The key event follows
        /// the wl_keyboard key event convention. Sym is a XKB keysym, state a
        /// wl_keyboard key_state. Modifiers are a mask for effective modifiers
        /// (where the modifier indices are set by the modifiers_map event)
        case keysym(time: UInt32, sym: UInt32, state: UInt32, modifiers: UInt32)

        /// Language
        /// 
        /// Sets the language of the input text. The "language" argument is a RFC-3066
        /// format language tag.
        case language(language: String)

        /// Text Direction
        /// 
        /// Sets the text direction of input text.
        /// It is mainly needed for showing input cursor on correct side of the
        /// editor when there is no input yet done and making sure neutral
        /// direction text is laid out properly.
        case textDirection(direction: TextDirection)

        /// Configure Amount Of Surrounding Text To Be Sent
        /// 
        /// Configure what amount of surrounding text is expected by the
        /// input method. The surrounding text will be sent in the
        /// set_surrounding_text request on the following state information updates.
        case configureSurroundingText(beforeCursor: Int32, afterCursor: Int32)

        /// Notifies About A Changed Input Method
        /// 
        /// The input method changed on compositor side, which invalidates all
        /// current state information. New state information should be sent from
        /// the client via state requests (set_surrounding_text,
        /// set_content_hint, ...) and update_state.
        case inputMethodChanged(serial: UInt32, flags: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.enter(serial: r.uint(), surface: r.object(type: WlSurface.self))
            case 1:
                self = Self.leave(serial: r.uint(), surface: r.object(type: WlSurface.self))
            case 2:
                self = Self.inputPanelState(state: try _parseEnum(into: InputPanelVisibility.self, r.uint()), x: r.int(), y: r.int(), width: r.int(), height: r.int())
            case 3:
                self = Self.preeditString(text: r.string(), commit: r.string())
            case 4:
                self = Self.preeditStyling(index: r.uint(), length: r.uint(), style: try _parseEnum(into: PreeditStyle.self, r.uint()))
            case 5:
                self = Self.preeditCursor(index: r.int())
            case 6:
                self = Self.commitString(text: r.string())
            case 7:
                self = Self.cursorPosition(index: r.int(), anchor: r.int())
            case 8:
                self = Self.deleteSurroundingText(beforeLength: r.uint(), afterLength: r.uint())
            case 9:
                self = Self.modifiersMap(map: r.array())
            case 10:
                self = Self.keysym(time: r.uint(), sym: r.uint(), state: r.uint(), modifiers: r.uint())
            case 11:
                self = Self.language(language: r.string())
            case 12:
                self = Self.textDirection(direction: try _parseEnum(into: TextDirection.self, r.uint()))
            case 13:
                self = Self.configureSurroundingText(beforeCursor: r.int(), afterCursor: r.int())
            case 14:
                self = Self.inputMethodChanged(serial: r.uint(), flags: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Text Input Manager
/// 
/// A factory for text-input objects. This object is a global singleton.
public final class ZwpTextInputManagerV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_text_input_manager_v2",
            version: 1,
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
                        interface: "zwp_text_input_v2"
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
    public func getTextInput(seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpTextInputV2 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpTextInputV2.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(seat.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TextInputUnstableV2)
    }
    
    var destructor: Destructor? = .destroy

    enum Destructor {
        case destroy
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .destroy: try? self.destroy()
                case nil: break
            }
        }
    }

    public typealias Event = NoEvent
}

public let TextInputUnstableV2 = Protocol(
        name: "text_input_unstable_v2",
        interfaces: [
            ZwpTextInputV2.interface,
ZwpTextInputManagerV2.interface
        ]
    )

#endif