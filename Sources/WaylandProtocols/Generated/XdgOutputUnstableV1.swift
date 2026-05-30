import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if UNSTABLE
/// Manage Xdg_Output Objects
/// 
/// A global factory interface for xdg_output objects.
public final class ZxdgOutputManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_output_manager_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "get_xdg_output",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zxdg_output_v1"
                    ),
                    Argument(
                        name: "output",
                        type: .object,
                        interface: "wl_output"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Xdg_Output_Manager Object
    /// 
    /// Using this request a client can tell the server that it is not
    /// going to use the xdg_output_manager object anymore.
    /// Any objects already created through this instance are not affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create An Xdg Output From A Wl_Output
    /// 
    /// This creates a new xdg_output object for the given wl_output.
    /// 
    /// - Parameters:
    public func getXdgOutput(output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZxdgOutputV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZxdgOutputV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(output.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgOutputUnstableV1)
    }
    
    public typealias Event = NoEvent
}
/// Compositor Logical Output Region
/// 
/// An xdg_output describes part of the compositor geometry.
/// This typically corresponds to a monitor that displays part of the
/// compositor space.
/// For objects version 3 onwards, after all xdg_output properties have been
/// sent (when the object is created and when properties are updated), a
/// wl_output.done event is sent. This allows changes to the output
/// properties to be seen as atomic, even if they happen via multiple events.
public final class ZxdgOutputV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_output_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "logical_position",
                    arguments: [
                    Argument(
                        name: "x",
                        type: .int,
                    ),
                    Argument(
                        name: "y",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "logical_size",
                    arguments: [
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
                    name: "done",
                    arguments: [
                    ],
                ),
                Message(
                    name: "name",
                    arguments: [
                    Argument(
                        name: "name",
                        type: .string,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "description",
                    arguments: [
                    Argument(
                        name: "description",
                        type: .string,
                    ),
                    ],
                    since: 2
                ),
                ],
        )
    /// Destroy The Xdg_Output Object
    /// 
    /// Using this request a client can tell the server that it is not
    /// going to use the xdg_output object anymore.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgOutputUnstableV1)
    }
    
    public enum Event: Decodable {
        /// Position Of The Output Within The Global Compositor Space
        /// 
        /// The position event describes the location of the wl_output within
        /// the global compositor space.
        /// The logical_position event is sent after creating an xdg_output
        /// (see xdg_output_manager.get_xdg_output) and whenever the location
        /// of the output changes within the global compositor space.
        case logicalPosition(x: Int32, y: Int32)

        /// Size Of The Output In The Global Compositor Space
        /// 
        /// The logical_size event describes the size of the output in the
        /// global compositor space.
        /// Most regular Wayland clients should not pay attention to the
        /// logical size and would rather rely on xdg_shell interfaces.
        /// Some clients such as Xwayland, however, need this to configure
        /// their surfaces in the global compositor space as the compositor
        /// may apply a different scale from what is advertised by the output
        /// scaling property (to achieve fractional scaling, for example).
        /// For example, for a wl_output mode 3840×2160 and a scale factor 2:
        /// - A compositor not scaling the monitor viewport in its compositing space
        /// will advertise a logical size of 3840×2160,
        /// - A compositor scaling the monitor viewport with scale factor 2 will
        /// advertise a logical size of 1920×1080,
        /// - A compositor scaling the monitor viewport using a fractional scale of
        /// 1.5 will advertise a logical size of 2560×1440.
        /// For example, for a wl_output mode 1920×1080 and a 90 degree rotation,
        /// the compositor will advertise a logical size of 1080x1920.
        /// The logical_size event is sent after creating an xdg_output
        /// (see xdg_output_manager.get_xdg_output) and whenever the logical
        /// size of the output changes, either as a result of a change in the
        /// applied scale or because of a change in the corresponding output
        /// mode(see wl_output.mode) or transform (see wl_output.transform).
        case logicalSize(width: Int32, height: Int32)

        /// All Information About The Output Have Been Sent
        /// 
        /// This event is sent after all other properties of an xdg_output
        /// have been sent.
        /// This allows changes to the xdg_output properties to be seen as
        /// atomic, even if they happen via multiple events.
        /// For objects version 3 onwards, this event is deprecated. Compositors
        /// are not required to send it anymore and must send wl_output.done
        /// instead.
        case done

        /// Name Of This Output
        /// 
        /// Many compositors will assign names to their outputs, show them to the
        /// user, allow them to be configured by name, etc. The client may wish to
        /// know this name as well to offer the user similar behaviors.
        /// The naming convention is compositor defined, but limited to
        /// alphanumeric characters and dashes (-). Each name is unique among all
        /// wl_output globals, but if a wl_output global is destroyed the same name
        /// may be reused later. The names will also remain consistent across
        /// sessions with the same hardware and software configuration.
        /// Examples of names include 'HDMI-A-1', 'WL-1', 'X11-1', etc. However, do
        /// not assume that the name is a reflection of an underlying DRM
        /// connector, X11 connection, etc.
        /// The name event is sent after creating an xdg_output (see
        /// xdg_output_manager.get_xdg_output). This event is only sent once per
        /// xdg_output, and the name does not change over the lifetime of the
        /// wl_output global.
        /// This event is deprecated, instead clients should use wl_output.name.
        /// Compositors must still support this event.
        case name(name: String)

        /// Human-Readable Description Of This Output
        /// 
        /// Many compositors can produce human-readable descriptions of their
        /// outputs.  The client may wish to know this description as well, to
        /// communicate the user for various purposes.
        /// The description is a UTF-8 string with no convention defined for its
        /// contents. Examples might include 'Foocorp 11" Display' or 'Virtual X11
        /// output via :1'.
        /// The description event is sent after creating an xdg_output (see
        /// xdg_output_manager.get_xdg_output) and whenever the description
        /// changes. The description is optional, and may not be sent at all.
        /// For objects of version 2 and lower, this event is only sent once per
        /// xdg_output, and the description does not change over the lifetime of
        /// the wl_output global.
        /// This event is deprecated, instead clients should use
        /// wl_output.description. Compositors must still support this event.
        case description(description: String)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.logicalPosition(x: r.int(), y: r.int())
            case 1:
                self = Self.logicalSize(width: r.int(), height: r.int())
            case 2:
                self = Self.done
            case 3:
                self = Self.name(name: r.string())
            case 4:
                self = Self.description(description: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let XdgOutputUnstableV1 = Protocol(
        name: "xdg_output_unstable_v1",
        interfaces: [
            ZxdgOutputManagerV1.interface,
ZxdgOutputV1.interface
        ]
    )

#endif