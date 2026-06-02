import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WLR
/// List And Control Opened Apps
/// 
/// The purpose of this protocol is to enable the creation of taskbars
/// and docks by providing them with a list of opened applications and
/// letting them request certain actions on them, like maximizing, etc.
/// After a client binds the zwlr_foreign_toplevel_manager_v1, each opened
/// toplevel window will be sent via the toplevel event
public final class ZwlrForeignToplevelManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_foreign_toplevel_manager_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "stop",
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "toplevel",
                    arguments: [
                    Argument(
                        name: "toplevel",
                        type: .newId,
                        interface: "zwlr_foreign_toplevel_handle_v1",
                    ),
                    ],
                ),
                Message(
                    name: "finished",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
        )
    /// Stop Sending Events
    /// 
    /// Indicates the client no longer wishes to receive events for new toplevels.
    /// However the compositor may emit further toplevel_created events, until
    /// the finished event is emitted.
    /// The client must not send any more requests after this one.
    public func stop() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrForeignToplevelManagementUnstableV1Protocol)
    }
    
    public enum Event: Decodable {
        /// A Toplevel Has Been Created
        /// 
        /// This event is emitted whenever a new toplevel window is created. It
        /// is emitted for all toplevels, regardless of the app that has created
        /// them.
        /// All initial details of the toplevel(title, app_id, states, etc.) will
        /// be sent immediately after this event via the corresponding events in
        /// zwlr_foreign_toplevel_handle_v1.
        case toplevel(toplevel: ZwlrForeignToplevelHandleV1)

        /// The Compositor Has Finished With The Toplevel Manager
        /// 
        /// This event indicates that the compositor is done sending events to the
        /// zwlr_foreign_toplevel_manager_v1. The server will destroy the object
        /// immediately after sending this request, so it will become invalid and
        /// the client should free any resources associated with it.
        case finished

        public init(from r: some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.toplevel(toplevel: r.newId(type: ZwlrForeignToplevelHandleV1.self))
            case 1:
                self = Self.finished
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// An Opened Toplevel
/// 
/// A zwlr_foreign_toplevel_handle_v1 object represents an opened toplevel
/// window. Each app may have multiple opened toplevels.
/// Each toplevel has a list of outputs it is visible on, conveyed to the
/// client with the output_enter and output_leave events.
public final class ZwlrForeignToplevelHandleV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_foreign_toplevel_handle_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "set_maximized",
                    arguments: [
                    ],
                ),
                Message(
                    name: "unset_maximized",
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_minimized",
                    arguments: [
                    ],
                ),
                Message(
                    name: "unset_minimized",
                    arguments: [
                    ],
                ),
                Message(
                    name: "activate",
                    arguments: [
                    Argument(
                        name: "seat",
                        type: .object,
                        interface: "wl_seat",
                    ),
                    ],
                ),
                Message(
                    name: "close",
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_rectangle",
                    arguments: [
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface",
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
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_fullscreen",
                    arguments: [
                    Argument(
                        name: "output",
                        type: .object,
                        interface: "wl_output",
                        nullable: true,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "unset_fullscreen",
                    arguments: [
                    ],
                    since: 2
                ),
                ],
            events: [
                Message(
                    name: "title",
                    arguments: [
                    Argument(
                        name: "title",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "app_id",
                    arguments: [
                    Argument(
                        name: "app_id",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "output_enter",
                    arguments: [
                    Argument(
                        name: "output",
                        type: .object,
                        interface: "wl_output",
                    ),
                    ],
                ),
                Message(
                    name: "output_leave",
                    arguments: [
                    Argument(
                        name: "output",
                        type: .object,
                        interface: "wl_output",
                    ),
                    ],
                ),
                Message(
                    name: "state",
                    arguments: [
                    Argument(
                        name: "state",
                        type: .array,
                    ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [
                    ],
                ),
                Message(
                    name: "closed",
                    arguments: [
                    ],
                ),
                Message(
                    name: "parent",
                    arguments: [
                    Argument(
                        name: "parent",
                        type: .object,
                        interface: "zwlr_foreign_toplevel_handle_v1",
                        nullable: true,
                    ),
                    ],
                    since: 3
                ),
                ],
        )
    /// Requests That The Toplevel Be Maximized
    /// 
    /// Requests that the toplevel be maximized. If the maximized state actually
    /// changes, this will be indicated by the state event.
    public func setMaximized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Requests That The Toplevel Be Unmaximized
    /// 
    /// Requests that the toplevel be unmaximized. If the maximized state actually
    /// changes, this will be indicated by the state event.
    public func unsetMaximized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    /// Requests That The Toplevel Be Minimized
    /// 
    /// Requests that the toplevel be minimized. If the minimized state actually
    /// changes, this will be indicated by the state event.
    public func setMinimized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    /// Requests That The Toplevel Be Unminimized
    /// 
    /// Requests that the toplevel be unminimized. If the minimized state actually
    /// changes, this will be indicated by the state event.
    public func unsetMinimized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
        ])
    }

    /// Activate The Toplevel
    /// 
    /// Request that this toplevel be activated on the given seat.
    /// There is no guarantee the toplevel will be actually activated.
    /// 
    /// - Parameters:
    public func activate(seat: WlSeat) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .object(seat.id),
        ])
    }

    /// Request That The Toplevel Be Closed
    /// 
    /// Send a request to the toplevel to close itself. The compositor would
    /// typically use a shell-specific method to carry out this request, for
    /// example by sending the xdg_toplevel.close event. However, this gives
    /// no guarantees the toplevel will actually be destroyed. If and when
    /// this happens, the zwlr_foreign_toplevel_handle_v1.closed event will
    /// be emitted.
    public func close() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
        ])
    }

    /// The Rectangle Which Represents The Toplevel
    /// 
    /// The rectangle of the surface specified in this request corresponds to
    /// the place where the app using this protocol represents the given toplevel.
    /// It can be used by the compositor as a hint for some operations, e.g
    /// minimizing. The client is however not required to set this, in which
    /// case the compositor is free to decide some default value.
    /// If the client specifies more than one rectangle, only the last one is
    /// considered.
    /// The dimensions are given in surface-local coordinates.
    /// Setting width=height=0 removes the already-set rectangle.
    /// 
    /// - Parameters:
    public func setRectangle(surface: WlSurface, x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .object(surface.id),
            .int(x),
            .int(y),
            .int(width),
            .int(height),
        ])
    }

    /// Destroy The Zwlr_Foreign_Toplevel_Handle_V1 Object
    /// 
    /// Destroys the zwlr_foreign_toplevel_handle_v1 object.
    /// This request should be called either when the client does not want to
    /// use the toplevel anymore or after the closed event to finalize the
    /// destruction of the object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 7, [
        ])
    }

    /// Request That The Toplevel Be Fullscreened
    /// 
    /// Requests that the toplevel be fullscreened on the given output. If the
    /// fullscreen state and/or the outputs the toplevel is visible on actually
    /// change, this will be indicated by the state and output_enter/leave
    /// events.
    /// The output parameter is only a hint to the compositor. Also, if output
    /// is NULL, the compositor should decide which output the toplevel will be
    /// fullscreened on, if at all.
    /// 
    /// - Parameters:
    public func setFullscreen(output: WlOutput? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 8, [
            .object(output?.id ?? 0),
        ])
    }

    /// Request That The Toplevel Be Unfullscreened
    /// 
    /// Requests that the toplevel be unfullscreened. If the fullscreen state
    /// actually changes, this will be indicated by the state event.
    public func unsetFullscreen() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 9, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrForeignToplevelManagementUnstableV1Protocol)
    }
    
    public enum State: UInt32 {
        /// the toplevel is maximized
        case maximized = 0

        /// the toplevel is minimized
        case minimized = 1

        /// the toplevel is active
        case activated = 2

        /// the toplevel is fullscreen
        case fullscreen = 3
    }

    public enum Error: UInt32 {
        /// the provided rectangle is invalid
        case invalidRectangle = 0
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
        /// Title Change
        /// 
        /// This event is emitted whenever the title of the toplevel changes.
        case title(title: String)

        /// App-Id Change
        /// 
        /// This event is emitted whenever the app-id of the toplevel changes.
        case appId(appId: String)

        /// Toplevel Entered An Output
        /// 
        /// This event is emitted whenever the toplevel becomes visible on
        /// the given output. A toplevel may be visible on multiple outputs.
        case outputEnter(output: WlOutput)

        /// Toplevel Left An Output
        /// 
        /// This event is emitted whenever the toplevel stops being visible on
        /// the given output. It is guaranteed that an entered-output event
        /// with the same output has been emitted before this event.
        case outputLeave(output: WlOutput)

        /// The Toplevel State Changed
        /// 
        /// This event is emitted immediately after the zlw_foreign_toplevel_handle_v1
        /// is created and each time the toplevel state changes, either because of a
        /// compositor action or because of a request in this protocol.
        case state(state: Data)

        /// All Information About The Toplevel Has Been Sent
        /// 
        /// This event is sent after all changes in the toplevel state have been
        /// sent.
        /// This allows changes to the zwlr_foreign_toplevel_handle_v1 properties
        /// to be seen as atomic, even if they happen via multiple events.
        case done

        /// This Toplevel Has Been Destroyed
        /// 
        /// This event means the toplevel has been destroyed. It is guaranteed there
        /// won't be any more events for this zwlr_foreign_toplevel_handle_v1. The
        /// toplevel itself becomes inert so any requests will be ignored except the
        /// destroy request.
        case closed

        /// Parent Change
        /// 
        /// This event is emitted whenever the parent of the toplevel changes.
        /// No event is emitted when the parent handle is destroyed by the client.
        case parent(parent: ZwlrForeignToplevelHandleV1)

        public init(from r: some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.title(title: r.string())
            case 1:
                self = Self.appId(appId: r.string())
            case 2:
                self = Self.outputEnter(output: r.object(type: WlOutput.self))
            case 3:
                self = Self.outputLeave(output: r.object(type: WlOutput.self))
            case 4:
                self = Self.state(state: r.array())
            case 5:
                self = Self.done
            case 6:
                self = Self.closed
            case 7:
                self = Self.parent(parent: r.object(type: ZwlrForeignToplevelHandleV1.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let WlrForeignToplevelManagementUnstableV1Protocol = Protocol(
        name: "wlr_foreign_toplevel_management_unstable_v1",
        interfaces: [
            ZwlrForeignToplevelManagerV1.interface,
ZwlrForeignToplevelHandleV1.interface
        ]
    )

#endif