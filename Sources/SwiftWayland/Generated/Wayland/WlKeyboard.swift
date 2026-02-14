import Foundation

/// Keyboard Input Device
/// 
/// The wl_keyboard interface represents one or more keyboards
/// associated with a seat.
/// Each wl_keyboard has the following logical state:
/// - an active surface (possibly null),
/// - the keys currently logically down,
/// - the active modifiers,
/// - the active group.
/// By default, the active surface is null, the keys currently logically down
/// are empty, the active modifiers and the active group are 0.
public final class WlKeyboard: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_keyboard"
    public var onEvent: (Event) -> Void = { _ in }

    /// Release The Keyboard Object
    /// 
    /// 
    /// 
    /// Available since version 3
    public consuming func release() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.release()
    }
    
    /// Keyboard Mapping Format
    /// 
    /// This specifies the format of the keymap provided to the
    /// client with the wl_keyboard.keymap event.
    public enum KeymapFormat: UInt32, WlEnum {
        /// No Keymap; Client Must Understand How To Interpret The Raw Keycode
        case noKeymap = 0
        
        /// Libxkbcommon Compatible, Null-Terminated String; To Determine The Xkb Keycode, Clients Must Add 8 To The Key Event Keycode
        case xkbV1 = 1
    }
    
    /// Physical Key State
    /// 
    /// Describes the physical state of a key that produced the key event.
    /// Since version 10, the key can be in a "repeated" pseudo-state which
    /// means the same as "pressed", but is used to signal repetition in the
    /// key event.
    /// The key may only enter the repeated state after entering the pressed
    /// state and before entering the released state. This event may be
    /// generated multiple times while the key is down.
    public enum KeyState: UInt32, WlEnum {
        /// Key Is Not Pressed
        case released = 0
        
        /// Key Is Pressed
        case pressed = 1
        
        /// Key Was Repeated
        case repeated = 2
    }
    
    public enum Event: WlEventEnum {
        /// Keyboard Mapping
        /// 
        /// This event provides a file descriptor to the client which can be
        /// memory-mapped in read-only mode to provide a keyboard mapping
        /// description.
        /// From version 7 onwards, the fd must be mapped with MAP_PRIVATE by
        /// the recipient, as MAP_SHARED may fail.
        /// 
        /// - Parameters:
        ///   - Format: keymap format
        ///   - Fd: keymap file descriptor
        ///   - Size: keymap size, in bytes
        case keymap(format: UInt32, fd: FileHandle, size: UInt32)
        
        /// Enter Event
        /// 
        /// Notification that this seat's keyboard focus is on a certain
        /// surface.
        /// The compositor must send the wl_keyboard.modifiers event after this
        /// event.
        /// In the wl_keyboard logical state, this event sets the active surface to
        /// the surface argument and the keys currently logically down to the keys
        /// in the keys argument. The compositor must not send this event if the
        /// wl_keyboard already had an active surface immediately before this event.
        /// Clients should not use the list of pressed keys to emulate key-press
        /// events. The order of keys in the list is unspecified.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the enter event
        ///   - Surface: surface gaining keyboard focus
        ///   - Keys: the keys currently logically down
        case enter(serial: UInt32, surface: WlSurface, keys: Data)
        
        /// Leave Event
        /// 
        /// Notification that this seat's keyboard focus is no longer on
        /// a certain surface.
        /// The leave notification is sent before the enter notification
        /// for the new focus.
        /// In the wl_keyboard logical state, this event resets all values to their
        /// defaults. The compositor must not send this event if the active surface
        /// of the wl_keyboard was not equal to the surface argument immediately
        /// before this event.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the leave event
        ///   - Surface: surface that lost keyboard focus
        case leave(serial: UInt32, surface: WlSurface)
        
        /// Key Event
        /// 
        /// A key was pressed or released.
        /// The time argument is a timestamp with millisecond
        /// granularity, with an undefined base.
        /// The key is a platform-specific key code that can be interpreted
        /// by feeding it to the keyboard mapping (see the keymap event).
        /// If this event produces a change in modifiers, then the resulting
        /// wl_keyboard.modifiers event must be sent after this event.
        /// In the wl_keyboard logical state, this event adds the key to the keys
        /// currently logically down (if the state argument is pressed) or removes
        /// the key from the keys currently logically down (if the state argument is
        /// released). The compositor must not send this event if the wl_keyboard
        /// did not have an active surface immediately before this event. The
        /// compositor must not send this event if state is pressed (resp. released)
        /// and the key was already logically down (resp. was not logically down)
        /// immediately before this event.
        /// Since version 10, compositors may send key events with the "repeated"
        /// key state when a wl_keyboard.repeat_info event with a rate argument of
        /// 0 has been received. This allows the compositor to take over the
        /// responsibility of key repetition.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the key event
        ///   - Time: timestamp with millisecond granularity
        ///   - Key: key that produced the event
        ///   - State: physical state of the key
        case key(serial: UInt32, time: UInt32, key: UInt32, state: UInt32)
        
        /// Modifier And Group State
        /// 
        /// Notifies clients that the modifier and/or group state has
        /// changed, and it should update its local state.
        /// The compositor may send this event without a surface of the client
        /// having keyboard focus, for example to tie modifier information to
        /// pointer focus instead. If a modifier event with pressed modifiers is sent
        /// without a prior enter event, the client can assume the modifier state is
        /// valid until it receives the next wl_keyboard.modifiers event. In order to
        /// reset the modifier state again, the compositor can send a
        /// wl_keyboard.modifiers event with no pressed modifiers.
        /// In the wl_keyboard logical state, this event updates the modifiers and
        /// group.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the modifiers event
        ///   - ModsDepressed: depressed modifiers
        ///   - ModsLatched: latched modifiers
        ///   - ModsLocked: locked modifiers
        ///   - Group: keyboard layout
        case modifiers(serial: UInt32, modsDepressed: UInt32, modsLatched: UInt32, modsLocked: UInt32, group: UInt32)
        
        /// Repeat Rate And Delay
        /// 
        /// Informs the client about the keyboard's repeat rate and delay.
        /// This event is sent as soon as the wl_keyboard object has been created,
        /// and is guaranteed to be received by the client before any key press
        /// event.
        /// Negative values for either rate or delay are illegal. A rate of zero
        /// will disable any repeating (regardless of the value of delay).
        /// This event can be sent later on as well with a new value if necessary,
        /// so clients should continue listening for the event past the creation
        /// of wl_keyboard.
        /// 
        /// - Parameters:
        ///   - Rate: the rate of repeating keys in characters per second
        ///   - Delay: delay in milliseconds since key down until repeating starts
        /// 
        /// Available since version 4
        case repeatInfo(rate: Int32, delay: Int32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.keymap(format: r.readUInt(), fd: r.readFd(), size: r.readUInt())
            case 1:
                return Self.enter(serial: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!, keys: r.readArray())
            case 2:
                return Self.leave(serial: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 3:
                return Self.key(serial: r.readUInt(), time: r.readUInt(), key: r.readUInt(), state: r.readUInt())
            case 4:
                return Self.modifiers(serial: r.readUInt(), modsDepressed: r.readUInt(), modsLatched: r.readUInt(), modsLocked: r.readUInt(), group: r.readUInt())
            case 5:
                return Self.repeatInfo(rate: r.readInt(), delay: r.readInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
