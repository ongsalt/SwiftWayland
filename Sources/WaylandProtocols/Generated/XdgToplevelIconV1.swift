import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if STAGING
/// Interface To Manage Toplevel Icons
/// 
/// This interface allows clients to create toplevel window icons and set
/// them on toplevel windows to be displayed to the user.
public final class XdgToplevelIconManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_toplevel_icon_manager_v1",
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
                    name: "create_icon",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "xdg_toplevel_icon_v1"
                    ),
                    ],
                ),
                Message(
                    name: "set_icon",
                    arguments: [
                    Argument(
                        name: "toplevel",
                        type: .object,
                        interface: "xdg_toplevel"
                    ),
                    Argument(
                        name: "icon",
                        type: .object,
                        interface: "xdg_toplevel_icon_v1"
                    ),
                    ],
                ),
                ],
            events: [
                Message(
                    name: "icon_size",
                    arguments: [
                    Argument(
                        name: "size",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [
                    ],
                ),
                ],
        )
    /// Destroy The Toplevel Icon Manager
    /// 
    /// Destroy the toplevel icon manager.
    /// This does not destroy objects created with the manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Create A New Icon Instance
    /// 
    /// Creates a new icon object. This icon can then be attached to a
    /// xdg_toplevel via the 'set_icon' request.
    public func createIcon(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgToplevelIconV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgToplevelIconV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
        ])
        return id
    }

    /// Set An Icon On A Toplevel Window
    /// 
    /// This request assigns the icon 'icon' to 'toplevel', or clears the
    /// toplevel icon if 'icon' was null.
    /// This state is double-buffered and is applied on the next
    /// wl_surface.commit of the toplevel.
    /// After making this call, the xdg_toplevel_icon_v1 provided as 'icon'
    /// can be destroyed by the client without 'toplevel' losing its icon.
    /// The xdg_toplevel_icon_v1 is immutable from this point, and any
    /// future attempts to change it must raise the
    /// 'xdg_toplevel_icon_v1.immutable' protocol error.
    /// The compositor must set the toplevel icon from either the pixel data
    /// the icon provides, or by loading a stock icon using the icon name.
    /// See the description of 'xdg_toplevel_icon_v1' for details.
    /// If 'icon' is set to null, the icon of the respective toplevel is reset
    /// to its default icon (usually the icon of the application, derived from
    /// its desktop-entry file, or a placeholder icon).
    /// If this request is passed an icon with no pixel buffers or icon name
    /// assigned, the icon must be reset just like if 'icon' was null.
    /// 
    /// - Parameters:
    ///   - toplevel: the toplevel to act on
    public func setIcon(toplevel: XdgToplevel, icon: XdgToplevelIconV1? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(toplevel.id),
            .object(icon?.id ?? 0),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgToplevelIconV1)
    }
    
    public enum Event: Decodable {
        /// Describes A Supported & Preferred Icon Size
        /// 
        /// This event indicates an icon size the compositor prefers to be
        /// available if the client has scalable icons and can render to any size.
        /// When the 'xdg_toplevel_icon_manager_v1' object is created, the
        /// compositor may send one or more 'icon_size' events to describe the list
        /// of preferred icon sizes. If the compositor has no size preference, it
        /// may not send any 'icon_size' event, and it is up to the client to
        /// decide a suitable icon size.
        /// A sequence of 'icon_size' events must be finished with a 'done' event.
        /// If the compositor has no size preferences, it must still send the
        /// 'done' event, without any preceding 'icon_size' events.
        case iconSize(size: Int32)

        /// All Information Has Been Sent
        /// 
        /// This event is sent after all 'icon_size' events have been sent.
        case done

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.iconSize(size: r.int())
            case 1:
                self = Self.done
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// A Toplevel Window Icon
/// 
/// This interface defines a toplevel icon.
/// An icon can have a name, and multiple buffers.
/// In order to be applied, the icon must have either a name, or at least
/// one buffer assigned. Applying an empty icon (with no buffer or name) to
/// a toplevel should reset its icon to the default icon.
/// It is up to compositor policy whether to prefer using a buffer or loading
/// an icon via its name. See 'set_name' and 'add_buffer' for details.
public final class XdgToplevelIconV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_toplevel_icon_v1",
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
                    name: "set_name",
                    arguments: [
                    Argument(
                        name: "icon_name",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "add_buffer",
                    arguments: [
                    Argument(
                        name: "buffer",
                        type: .object,
                        interface: "wl_buffer"
                    ),
                    Argument(
                        name: "scale",
                        type: .int,
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Icon Object
    /// 
    /// Destroys the 'xdg_toplevel_icon_v1' object.
    /// The icon must still remain set on every toplevel it was assigned to,
    /// until the toplevel icon is reset explicitly.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Set An Icon Name
    /// 
    /// This request assigns an icon name to this icon.
    /// Any previously set name is overridden.
    /// The compositor must resolve 'icon_name' according to the lookup rules
    /// described in the XDG icon theme specification[1] using the
    /// environment's current icon theme.
    /// If the compositor does not support icon names or cannot resolve
    /// 'icon_name' according to the XDG icon theme specification it must
    /// fall back to using pixel buffer data instead.
    /// If this request is made after the icon has been assigned to a toplevel
    /// via 'set_icon', an 'immutable' error must be raised.
    /// [1]: https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html
    /// 
    /// - Parameters:
    public func setName(iconName: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .string(iconName),
        ])
    }

    /// Add Icon Data From A Pixel Buffer
    /// 
    /// This request adds pixel data supplied as wl_buffer to the icon.
    /// The client should add pixel data for all icon sizes and scales that
    /// it can provide, or which are explicitly requested by the compositor
    /// via 'icon_size' events on xdg_toplevel_icon_manager_v1.
    /// The wl_buffer supplying pixel data as 'buffer' must be backed by wl_shm
    /// and must be a square (width and height being equal).
    /// If any of these buffer requirements are not fulfilled, a 'invalid_buffer'
    /// error must be raised.
    /// If this icon instance already has a buffer of the same size and scale
    /// from a previous 'add_buffer' request, data from the last request
    /// overrides the preexisting pixel data.
    /// The wl_buffer must be kept alive for as long as the xdg_toplevel_icon
    /// it is associated with is not destroyed, otherwise a 'no_buffer' error
    /// is raised. The buffer contents must not be modified after it was
    /// assigned to the icon. As a result, the region of the wl_shm_pool's
    /// backing storage used for the wl_buffer must not be modified after this
    /// request is sent. The wl_buffer.release event is unused.
    /// If this request is made after the icon has been assigned to a toplevel
    /// via 'set_icon', an 'immutable' error must be raised.
    /// 
    /// - Parameters:
    ///   - scale: the scaling factor of the icon, e.g. 1
    public func addBuffer(buffer: WlBuffer, scale: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(buffer.id),
            .int(scale),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgToplevelIconV1)
    }
    
    public enum Error: UInt32 {
        /// the provided buffer does not satisfy requirements
        case invalidBuffer = 1

        /// the icon has already been assigned to a toplevel and must not be changed
        case immutable = 2

        /// the provided buffer has been destroyed before the toplevel icon
        case noBuffer = 3
    }

    public typealias Event = NoEvent
}

public let XdgToplevelIconV1 = Protocol(
        name: "xdg_toplevel_icon_v1",
        interfaces: [
            XdgToplevelIconManagerV1.interface,
XdgToplevelIconV1.interface
        ]
    )

#endif