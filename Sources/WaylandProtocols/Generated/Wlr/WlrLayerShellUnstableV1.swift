import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WLR
/// Create Surfaces That Are Layers Of The Desktop
/// 
/// Clients can use this interface to assign the surface_layer role to
/// wl_surfaces. Such surfaces are assigned to a "layer" of the output and
/// rendered with a defined z-depth respective to each other. They may also be
/// anchored to the edges and corners of a screen and specify input handling
/// semantics. This interface should be suitable for the implementation of
/// many desktop shell components, and a broad number of other applications
/// that interact with the desktop.
public final class ZwlrLayerShellV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_layer_shell_v1",
            version: 5,
            requests: [
                Message(
                    name: "get_layer_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_layer_surface_v1",
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                            nullable: true,
                        ),
                        Argument(
                            name: "layer",
                            type: .uint,
                        ),
                        Argument(
                            name: "namespace",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                    since: 3
                ),
            ],
        )
    /// Create A Layer_Surface From A Surface
    /// 
    /// Create a layer surface for an existing surface. This assigns the role of
    /// layer_surface, or raises a protocol error if another role is already
    /// assigned.
    /// Creating a layer surface from a wl_surface which has a buffer attached
    /// or committed is a client error, and any attempts by a client to attach
    /// or manipulate a buffer prior to the first layer_surface.configure call
    /// must also be treated as errors.
    /// After creating a layer_surface object and setting it up, the client
    /// must perform an initial commit without any buffer attached.
    /// The compositor will reply with a layer_surface.configure event.
    /// The client must acknowledge it and is then allowed to attach a buffer
    /// to map the surface.
    /// You may pass NULL for output to allow the compositor to decide which
    /// output to use. Generally this will be the one that the user most
    /// recently interacted with.
    /// Clients can specify a namespace that defines the purpose of the layer
    /// surface.
    /// 
    /// - Parameters:
    ///   - layer: layer to add this surface to
    ///   - namespace: namespace for the layer surface
    public func getLayerSurface(surface: WlSurface, output: WlOutput? = nil, layer: Layer, namespace: String, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrLayerSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwlrLayerSurfaceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
            .object(output?.id ?? 0),
            .uint(layer.rawValue),
            .string(namespace),
        ])
        return id
    }

    /// Destroy The Layer_Shell Object
    /// 
    /// This request indicates that the client will not use the layer_shell
    /// object any more. Objects that have been created through this instance
    /// are not affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrLayerShellUnstableV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// wl_surface has another role
        case role = 0

        /// layer value is invalid
        case invalidLayer = 1

        /// wl_surface has a buffer attached or committed
        case alreadyConstructed = 2
    }

    public enum Layer: UInt32 {
        case background = 0

        case bottom = 1

        case top = 2

        case overlay = 3
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

/// Layer Metadata Interface
/// 
/// An interface that may be implemented by a wl_surface, for surfaces that
/// are designed to be rendered as a layer of a stacked desktop-like
/// environment.
/// Layer surface state (layer, size, anchor, exclusive zone,
/// margin, interactivity) is double-buffered, and will be applied at the
/// time wl_surface.commit of the corresponding wl_surface is called.
/// Attaching a null buffer to a layer surface unmaps it.
/// Unmapping a layer_surface means that the surface cannot be shown by the
/// compositor until it is explicitly mapped again. The layer_surface
/// returns to the state it had right after layer_shell.get_layer_surface.
/// The client can re-map the surface by performing a commit without any
/// buffer attached, waiting for a configure event and handling it as usual.
public final class ZwlrLayerSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_layer_surface_v1",
            version: 5,
            requests: [
                Message(
                    name: "set_size",
                    arguments: [
                        Argument(
                            name: "width",
                            type: .uint,
                        ),
                        Argument(
                            name: "height",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "set_anchor",
                    arguments: [
                        Argument(
                            name: "anchor",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "set_exclusive_zone",
                    arguments: [
                        Argument(
                            name: "zone",
                            type: .int,
                        ),
                    ],
                ),
                Message(
                    name: "set_margin",
                    arguments: [
                        Argument(
                            name: "top",
                            type: .int,
                        ),
                        Argument(
                            name: "right",
                            type: .int,
                        ),
                        Argument(
                            name: "bottom",
                            type: .int,
                        ),
                        Argument(
                            name: "left",
                            type: .int,
                        ),
                    ],
                ),
                Message(
                    name: "set_keyboard_interactivity",
                    arguments: [
                        Argument(
                            name: "keyboard_interactivity",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "get_popup",
                    arguments: [
                        Argument(
                            name: "popup",
                            type: .object,
                            interface: "xdg_popup",
                        ),
                    ],
                ),
                Message(
                    name: "ack_configure",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "set_layer",
                    arguments: [
                        Argument(
                            name: "layer",
                            type: .uint,
                        ),
                    ],
                    since: 2
                ),
                Message(
                    name: "set_exclusive_edge",
                    arguments: [
                        Argument(
                            name: "edge",
                            type: .uint,
                        ),
                    ],
                    since: 5
                ),
            ],
            events: [
                Message(
                    name: "configure",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                        Argument(
                            name: "width",
                            type: .uint,
                        ),
                        Argument(
                            name: "height",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "closed",
                    arguments: [],
                ),
            ]
        )
    /// Sets The Size Of The Surface
    /// 
    /// Sets the size of the surface in surface-local coordinates. The
    /// compositor will display the surface centered with respect to its
    /// anchors.
    /// If you pass 0 for either value, the compositor will assign it and
    /// inform you of the assignment in the configure event. You must set your
    /// anchor to opposite edges in the dimensions you omit; not doing so is a
    /// protocol error. Both values are 0 by default.
    /// Size is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    public func setSize(width: UInt32, height: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(width),
            .uint(height),
        ])
    }

    /// Configures The Anchor Point Of The Surface
    /// 
    /// Requests that the compositor anchor the surface to the specified edges
    /// and corners. If two orthogonal edges are specified (e.g. 'top' and
    /// 'left'), then the anchor point will be the intersection of the edges
    /// (e.g. the top left corner of the output); otherwise the anchor point
    /// will be centered on that edge, or in the center if none is specified.
    /// Anchor is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    public func setAnchor(_ anchor: Anchor) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(anchor.rawValue),
        ])
    }

    /// Configures The Exclusive Geometry Of This Surface
    /// 
    /// Requests that the compositor avoids occluding an area with other
    /// surfaces. The compositor's use of this information is
    /// implementation-dependent - do not assume that this region will not
    /// actually be occluded.
    /// A positive value is only meaningful if the surface is anchored to one
    /// edge or an edge and both perpendicular edges. If the surface is not
    /// anchored, anchored to only two perpendicular edges (a corner), anchored
    /// to only two parallel edges or anchored to all edges, a positive value
    /// will be treated the same as zero.
    /// A positive zone is the distance from the edge in surface-local
    /// coordinates to consider exclusive.
    /// Surfaces that do not wish to have an exclusive zone may instead specify
    /// how they should interact with surfaces that do. If set to zero, the
    /// surface indicates that it would like to be moved to avoid occluding
    /// surfaces with a positive exclusive zone. If set to -1, the surface
    /// indicates that it would not like to be moved to accommodate for other
    /// surfaces, and the compositor should extend it all the way to the edges
    /// it is anchored to.
    /// For example, a panel might set its exclusive zone to 10, so that
    /// maximized shell surfaces are not shown on top of it. A notification
    /// might set its exclusive zone to 0, so that it is moved to avoid
    /// occluding the panel, but shell surfaces are shown underneath it. A
    /// wallpaper or lock screen might set their exclusive zone to -1, so that
    /// they stretch below or over the panel.
    /// The default value is 0.
    /// Exclusive zone is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    public func setExclusiveZone(zone: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(zone),
        ])
    }

    /// Sets A Margin From The Anchor Point
    /// 
    /// Requests that the surface be placed some distance away from the anchor
    /// point on the output, in surface-local coordinates. Setting this value
    /// for edges you are not anchored to has no effect.
    /// The exclusive zone includes the margin.
    /// Margin is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    public func setMargin(top: Int32, `right`: Int32, bottom: Int32, `left`: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .int(top),
            .int(`right`),
            .int(bottom),
            .int(`left`),
        ])
    }

    /// Requests Keyboard Events
    /// 
    /// Set how keyboard events are delivered to this surface. By default,
    /// layer shell surfaces do not receive keyboard events; this request can
    /// be used to change this.
    /// This setting is inherited by child surfaces set by the get_popup
    /// request.
    /// Layer surfaces receive pointer, touch, and tablet events normally. If
    /// you do not want to receive them, set the input region on your surface
    /// to an empty region.
    /// Keyboard interactivity is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    public func setKeyboardInteractivity(_ keyboardInteractivity: KeyboardInteractivity) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .uint(keyboardInteractivity.rawValue),
        ])
    }

    /// Assign This Layer_Surface As An Xdg_Popup Parent
    /// 
    /// This assigns an xdg_popup's parent to this layer_surface.  This popup
    /// should have been created via xdg_surface::get_popup with the parent set
    /// to NULL, and this request must be invoked before committing the popup's
    /// initial state.
    /// See the documentation of xdg_popup for more details about what an
    /// xdg_popup is and how it is used.
    /// 
    /// - Parameters:
    public func getPopup(popup: XdgPopup) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .object(popup.id),
        ])
    }

    /// Ack A Configure Event
    /// 
    /// When a configure event is received, if a client commits the
    /// surface in response to the configure event, then the client
    /// must make an ack_configure request sometime before the commit
    /// request, passing along the serial of the configure event.
    /// If the client receives multiple configure events before it
    /// can respond to one, it only has to ack the last configure event.
    /// A client is not required to commit immediately after sending
    /// an ack_configure request - it may even ack_configure several times
    /// before its next surface commit.
    /// A client may send multiple ack_configure requests before committing, but
    /// only the last request sent before a commit indicates which configure
    /// event the client really is responding to.
    /// 
    /// - Parameters:
    ///   - serial: the serial from the configure event
    public func ackConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .uint(serial),
        ])
    }

    /// Destroy The Layer_Surface
    /// 
    /// This request destroys the layer surface.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 7, [
        ])
    }

    /// Change The Layer Of The Surface
    /// 
    /// Change the layer that the surface is rendered on.
    /// Layer is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - _: layer to move this surface to
    public func setLayer(_ layer: ZwlrLayerShellV1.Layer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 8, [
            .uint(layer.rawValue),
        ])
    }

    /// Set The Edge The Exclusive Zone Will Be Applied To
    /// 
    /// Requests an edge for the exclusive zone to apply. The exclusive
    /// edge will be automatically deduced from anchor points when possible,
    /// but when the surface is anchored to a corner, it will be necessary
    /// to set it explicitly to disambiguate, as it is not possible to deduce
    /// which one of the two corner edges should be used.
    /// The edge must be one the surface is anchored to, otherwise the
    /// invalid_exclusive_edge protocol error will be raised.
    /// 
    /// - Parameters:
    public func setExclusiveEdge(edge: Anchor) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 5 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 5) }
        connection.send(self, 9, [
            .uint(edge.rawValue),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrLayerShellUnstableV1Protocol)
    }
    
    public enum KeyboardInteractivity: UInt32 {
        case `none` = 0

        case exclusive = 1

        case onDemand = 2
    }

    public enum Error: UInt32 {
        /// provided surface state is invalid
        case invalidSurfaceState = 0

        /// size is invalid
        case invalidSize = 1

        /// anchor bitfield is invalid
        case invalidAnchor = 2

        /// keyboard interactivity is invalid
        case invalidKeyboardInteractivity = 3

        /// exclusive edge is invalid given the surface anchors
        case invalidExclusiveEdge = 4
    }

    public struct Anchor: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// the top edge of the anchor rectangle
        public static let top = Anchor(rawValue: 1)

        /// the bottom edge of the anchor rectangle
        public static let bottom = Anchor(rawValue: 2)

        /// the left edge of the anchor rectangle
        public static let `left` = Anchor(rawValue: 4)

        /// the right edge of the anchor rectangle
        public static let `right` = Anchor(rawValue: 8)
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
        /// Suggest A Surface Change
        /// 
        /// The configure event asks the client to resize its surface.
        /// Clients should arrange their surface for the new states, and then send
        /// an ack_configure request with the serial sent in this configure event at
        /// some point before committing the new surface.
        /// The client is free to dismiss all but the last configure event it
        /// received.
        /// The width and height arguments specify the size of the window in
        /// surface-local coordinates.
        /// The size is a hint, in the sense that the client is free to ignore it if
        /// it doesn't resize, pick a smaller size (to satisfy aspect ratio or
        /// resize in steps of NxM pixels). If the client picks a smaller size and
        /// is anchored to two opposite anchors (e.g. 'top' and 'bottom'), the
        /// surface will be centered on this axis.
        /// If the width or height arguments are zero, it means the client should
        /// decide its own window dimension.
        case configure(serial: UInt32, width: UInt32, height: UInt32)

        /// Surface Should Be Closed
        /// 
        /// The closed event is sent by the compositor when the surface will no
        /// longer be shown. The output may have been destroyed or the user may
        /// have asked for it to be removed. Further changes to the surface will be
        /// ignored. The client should destroy the resource after receiving this
        /// event, and create a new surface if they so choose.
        case closed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.configure(serial: r.uint(), width: r.uint(), height: r.uint())
            case 1:
                self = Self.closed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let WlrLayerShellUnstableV1Protocol = Protocol(
        name: "wlr_layer_shell_unstable_v1",
        interfaces: [
            ZwlrLayerShellV1.interface,
ZwlrLayerSurfaceV1.interface
        ]
    )

#endif