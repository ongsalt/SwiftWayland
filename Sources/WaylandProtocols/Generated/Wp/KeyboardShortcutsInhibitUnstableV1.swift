import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// Context Object For Keyboard Grab_Manager
/// 
/// A global interface used for inhibiting the compositor keyboard shortcuts.
public final class ZwpKeyboardShortcutsInhibitManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_keyboard_shortcuts_inhibit_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "inhibit_shortcuts",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_keyboard_shortcuts_inhibitor_v1",
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        ),
                    ],
                ),
            ],
        )
    /// Destroy The Keyboard Shortcuts Inhibitor Object
    /// 
    /// Destroy the keyboard shortcuts inhibitor manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A New Keyboard Shortcuts Inhibitor Object
    /// 
    /// Create a new keyboard shortcuts inhibitor object associated with
    /// the given surface for the given seat.
    /// If shortcuts are already inhibited for the specified seat and surface,
    /// a protocol error "already_inhibited" is raised by the compositor.
    /// 
    /// - Parameters:
    ///   - surface: the surface that inhibits the keyboard shortcuts behavior
    ///   - seat: the wl_seat for which keyboard shortcuts should be disabled
    public func inhibitShortcuts(surface: WlSurface, seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpKeyboardShortcutsInhibitorV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpKeyboardShortcutsInhibitorV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
            .object(seat.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KeyboardShortcutsInhibitUnstableV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// the shortcuts are already inhibited for this surface
        case alreadyInhibited = 0
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
public final class ZwpKeyboardShortcutsInhibitorV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_keyboard_shortcuts_inhibitor_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "active",
                    arguments: [],
                ),
                Message(
                    name: "inactive",
                    arguments: [],
                ),
            ]
        )
    /// Destroy The Keyboard Shortcuts Inhibitor Object
    /// 
    /// Remove the keyboard shortcuts inhibitor from the associated wl_surface.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KeyboardShortcutsInhibitUnstableV1Protocol)
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

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.active
            case 1:
                self = Self.inactive
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let KeyboardShortcutsInhibitUnstableV1Protocol = Protocol(
        name: "keyboard_shortcuts_inhibit_unstable_v1",
        interfaces: [
            ZwpKeyboardShortcutsInhibitManagerV1.interface,
ZwpKeyboardShortcutsInhibitorV1.interface
        ]
    )

#endif