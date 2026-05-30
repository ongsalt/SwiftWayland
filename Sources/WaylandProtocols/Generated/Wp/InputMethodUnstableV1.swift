import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
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
public final class ZwpInputMethodContextV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_input_method_context_v1",
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
                    name: "grab_keyboard",
                    arguments: [
                    Argument(
                        name: "keyboard",
                        type: .newId,
                        interface: "wl_keyboard"
                    ),
                    ],
                ),
                Message(
                    name: "key",
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
                        name: "key",
                        type: .uint,
                    ),
                    Argument(
                        name: "state",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "modifiers",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "mods_depressed",
                        type: .uint,
                    ),
                    Argument(
                        name: "mods_latched",
                        type: .uint,
                    ),
                    Argument(
                        name: "mods_locked",
                        type: .uint,
                    ),
                    Argument(
                        name: "group",
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
            events: [
                Message(
                    name: "surrounding_text",
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
                    name: "reset",
                    arguments: [
                    ],
                ),
                Message(
                    name: "content_type",
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
                    name: "preferred_language",
                    arguments: [
                    Argument(
                        name: "language",
                        type: .string,
                    ),
                    ],
                ),
                ],
        )
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
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
    ///   - serial: serial of the latest known text input state
    public func commitString(serial: UInt32, text: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(serial),
            .string(text),
        ])
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
    ///   - serial: serial of the latest known text input state
    public func preeditString(serial: UInt32, text: String, commit: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .uint(serial),
            .string(text),
            .string(commit),
        ])
    }

    /// Pre-Edit Styling
    /// 
    /// Set the styling information on composing text. The style is applied for
    /// length in bytes from index relative to the beginning of
    /// the composing text (as byte offset). Multiple styles can
    /// be applied to a composing text.
    /// This request should be sent before sending a preedit_string request.
    /// 
    /// - Parameters:
    public func preeditStyling(index: UInt32, length: UInt32, style: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(index),
            .uint(length),
            .uint(style),
        ])
    }

    /// Pre-Edit Cursor
    /// 
    /// Set the cursor position inside the composing text (as byte offset)
    /// relative to the start of the composing text.
    /// When index is negative no cursor should be displayed.
    /// This request should be sent before sending a preedit_string request.
    /// 
    /// - Parameters:
    public func preeditCursor(index: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .int(index),
        ])
    }

    /// Delete Text
    /// 
    /// Remove the surrounding text.
    /// This request will be handled on the text_input side directly following
    /// a commit_string request.
    /// 
    /// - Parameters:
    public func deleteSurroundingText(index: Int32, length: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .int(index),
            .uint(length),
        ])
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
    /// 
    /// - Parameters:
    public func cursorPosition(index: Int32, anchor: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .int(index),
            .int(anchor),
        ])
    }

    /// 
    /// - Parameters:
    public func modifiersMap(map: Data) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
            .array(map),
        ])
    }

    /// Keysym
    /// 
    /// Notify when a key event was sent. Key events should not be used for
    /// normal text input operations, which should be done with commit_string,
    /// delete_surrounding_text, etc. The key event follows the wl_keyboard key
    /// event convention. Sym is an XKB keysym, state is a wl_keyboard key_state.
    /// 
    /// - Parameters:
    ///   - serial: serial of the latest known text input state
    public func keysym(serial: UInt32, time: UInt32, sym: UInt32, state: UInt32, modifiers: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .uint(serial),
            .uint(time),
            .uint(sym),
            .uint(state),
            .uint(modifiers),
        ])
    }

    /// Grab Hardware Keyboard
    /// 
    /// Allow an input method to receive hardware keyboard input and process
    /// key events to generate text events (with pre-edit) over the wire. This
    /// allows input methods which compose multiple key events for inputting
    /// text like it is done for CJK languages.
    public func grabKeyboard(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WlKeyboard {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let keyboard = connection.createProxy(type: WlKeyboard.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 9, [
            .object(keyboard.id),
        ])
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
    ///   - serial: serial from wl_keyboard::key
    ///   - time: time from wl_keyboard::key
    ///   - key: key from wl_keyboard::key
    ///   - state: state from wl_keyboard::key
    public func key(serial: UInt32, time: UInt32, key: UInt32, state: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 10, [
            .uint(serial),
            .uint(time),
            .uint(key),
            .uint(state),
        ])
    }

    /// Forward Modifiers Event
    /// 
    /// Forward a wl_keyboard::modifiers event to the client that was not
    /// processed by the input method itself.  Should be used when filtering
    /// key events with grab_keyboard. The arguments should be the ones
    /// from the wl_keyboard::modifiers event.
    /// 
    /// - Parameters:
    ///   - serial: serial from wl_keyboard::modifiers
    ///   - modsDepressed: mods_depressed from wl_keyboard::modifiers
    ///   - modsLatched: mods_latched from wl_keyboard::modifiers
    ///   - modsLocked: mods_locked from wl_keyboard::modifiers
    ///   - group: group from wl_keyboard::modifiers
    public func modifiers(serial: UInt32, modsDepressed: UInt32, modsLatched: UInt32, modsLocked: UInt32, group: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 11, [
            .uint(serial),
            .uint(modsDepressed),
            .uint(modsLatched),
            .uint(modsLocked),
            .uint(group),
        ])
    }

    /// 
    /// - Parameters:
    ///   - serial: serial of the latest known text input state
    public func language(serial: UInt32, language: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 12, [
            .uint(serial),
            .string(language),
        ])
    }

    /// 
    /// - Parameters:
    ///   - serial: serial of the latest known text input state
    public func textDirection(serial: UInt32, direction: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 13, [
            .uint(serial),
            .uint(direction),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: InputMethodUnstableV1)
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

        case commitState(serial: UInt32)

        case preferredLanguage(language: String)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.surroundingText(text: r.string(), cursor: r.uint(), anchor: r.uint())
            case 1:
                self = Self.reset
            case 2:
                self = Self.contentType(hint: r.uint(), purpose: r.uint())
            case 3:
                self = Self.invokeAction(button: r.uint(), index: r.uint())
            case 4:
                self = Self.commitState(serial: r.uint())
            case 5:
                self = Self.preferredLanguage(language: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Input Method
/// 
/// An input method object is responsible for composing text in response to
/// input from hardware or virtual keyboards. There is one input method
/// object per seat. On activate there is a new input method context object
/// created which allows the input method to communicate with the text input.
public final class ZwpInputMethodV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_input_method_v1",
            version: 1,
            enums: [],
            requests: [
                ],
            events: [
                Message(
                    name: "activate",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_input_method_context_v1"
                    ),
                    ],
                ),
                Message(
                    name: "deactivate",
                    arguments: [
                    Argument(
                        name: "context",
                        type: .object,
                        interface: "zwp_input_method_context_v1"
                    ),
                    ],
                ),
                ],
        )
    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: InputMethodUnstableV1)
    }
    
    public enum Event: Decodable {
        /// Activate Event
        /// 
        /// A text input was activated. Creates an input method context object
        /// which allows communication with the text input.
        case activate(id: ZwpInputMethodContextV1)

        /// Deactivate Event
        /// 
        /// The text input corresponding to the context argument was deactivated.
        /// The input method context should be destroyed after deactivation is
        /// handled.
        case deactivate(context: ZwpInputMethodContextV1)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.activate(id: r.newId(type: ZwpInputMethodContextV1.self))
            case 1:
                self = Self.deactivate(context: r.object(type: ZwpInputMethodContextV1.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Interface For Implementing Keyboards
/// 
/// Only one client can bind this interface at a time.
public final class ZwpInputPanelV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_input_panel_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "get_input_panel_surface",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_input_panel_surface_v1"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// 
    /// - Parameters:
    public func getInputPanelSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpInputPanelSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpInputPanelSurfaceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: InputMethodUnstableV1)
    }
    
    public typealias Event = NoEvent
}
public final class ZwpInputPanelSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_input_panel_surface_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "set_toplevel",
                    arguments: [
                    Argument(
                        name: "output",
                        type: .object,
                        interface: "wl_output"
                    ),
                    Argument(
                        name: "position",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_overlay_panel",
                    arguments: [
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Set The Surface Type As A Keyboard
    /// 
    /// Set the input_panel_surface type to keyboard.
    /// A keyboard surface is only shown when a text input is active.
    /// 
    /// - Parameters:
    public func setToplevel(output: WlOutput, position: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(output.id),
            .uint(position),
        ])
    }

    /// Set The Surface Type As An Overlay Panel
    /// 
    /// Set the input_panel_surface to be an overlay panel.
    /// This is shown near the input cursor above the application window when
    /// a text input is active.
    public func setOverlayPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: InputMethodUnstableV1)
    }
    
    public enum Position: UInt32 {
        case centerBottom = 0
    }

    public typealias Event = NoEvent
}

public let InputMethodUnstableV1 = Protocol(
        name: "input_method_unstable_v1",
        interfaces: [
            ZwpInputMethodContextV1.interface,
ZwpInputMethodV1.interface,
ZwpInputPanelV1.interface,
ZwpInputPanelSurfaceV1.interface
        ]
    )

#endif