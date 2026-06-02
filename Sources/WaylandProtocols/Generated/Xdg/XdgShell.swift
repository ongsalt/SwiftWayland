import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if XDG
/// Create Desktop-Style Surfaces
/// 
/// The xdg_wm_base interface is exposed as a global object enabling clients
/// to turn their wl_surfaces into windows in a desktop environment. It
/// defines the basic functionality needed for clients and the compositor to
/// create windows that can be dragged, resized, maximized, etc, as well as
/// creating transient windows such as popup menus.
public final class XdgWmBase: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_wm_base",
            version: 7,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "create_positioner",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "xdg_positioner",
                        ),
                    ],
                ),
                Message(
                    name: "get_xdg_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "xdg_surface",
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                    ],
                ),
                Message(
                    name: "pong",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                    ],
                ),
            ],
            events: [
                Message(
                    name: "ping",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                    ],
                ),
            ]
        )
    /// Destroy Xdg_Wm_Base
    /// 
    /// Destroy this xdg_wm_base object.
    /// Destroying a bound xdg_wm_base object while there are surfaces
    /// still alive created by this xdg_wm_base object instance is illegal
    /// and will result in a defunct_surfaces error.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A Positioner Object
    /// 
    /// Create a positioner object. A positioner object is used to position
    /// surfaces relative to some parent surface. See the interface description
    /// and xdg_surface.get_popup for details.
    public func createPositioner(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgPositioner {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgPositioner.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
        ])
        return id
    }

    /// Create A Shell Surface From A Surface
    /// 
    /// This creates an xdg_surface for the given surface. An xdg_surface is
    /// used as basis to define a role to a given surface, such as xdg_toplevel
    /// or xdg_popup. It also manages functionality shared between xdg_surface
    /// based surface roles.
    /// While xdg_surface itself is not a role, the corresponding surface may
    /// only be assigned a role extending xdg_surface, such as xdg_toplevel or
    /// xdg_popup. It is illegal to create an xdg_surface for a wl_surface which
    /// already has anassigned role and this will result in a role error.
    /// See the documentation of xdg_surface for more details about what an
    /// xdg_surface is and how it is used.
    /// 
    /// - Parameters:
    public func getXdgSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgSurface {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgSurface.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    /// Respond To A Ping Event
    /// 
    /// A client must respond to a ping event with a pong request or
    /// the client may be deemed unresponsive. See xdg_wm_base.ping
    /// and xdg_wm_base.error.unresponsive.
    /// 
    /// - Parameters:
    ///   - serial: serial of the ping event
    public func pong(serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(serial),
        ])
    }

    
    public static let `protocol`: Protocol = XdgShellProtocol
    
    public enum Error: UInt32 {
        /// given wl_surface has another role
        case role = 0

        /// xdg_wm_base was destroyed before children
        case defunctSurfaces = 1

        /// the client tried to map or destroy a non-topmost popup
        case notTheTopmostPopup = 2

        /// the client specified an invalid popup parent surface
        case invalidPopupParent = 3

        /// the client provided an invalid surface state
        case invalidSurfaceState = 4

        /// the client provided an invalid positioner
        case invalidPositioner = 5

        /// the client didn’t respond to a ping event in time
        case unresponsive = 6
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
        /// Check If The Client Is Alive
        /// 
        /// The ping event asks the client if it's still alive. Pass the
        /// serial specified in the event back to the compositor by sending
        /// a "pong" request back with the specified serial. See xdg_wm_base.pong.
        /// Compositors can use this to determine if the client is still
        /// alive. It's unspecified what will happen if the client doesn't
        /// respond to the ping request, or in what timeframe. Clients should
        /// try to respond in a reasonable amount of time. The “unresponsive”
        /// error is provided for compositors that wish to disconnect unresponsive
        /// clients.
        /// A compositor is free to ping in any way it wants, but a client must
        /// always respond to any xdg_wm_base object it created.
        case ping(serial: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.ping(serial: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Child Surface Positioner
/// 
/// The xdg_positioner provides a collection of rules for the placement of a
/// child surface relative to a parent surface. Rules can be defined to ensure
/// the child surface remains within the visible area's borders, and to
/// specify how the child surface changes its position, such as sliding along
/// an axis, or flipping around a rectangle. These positioner-created rules are
/// constrained by the requirement that a child surface must intersect with or
/// be at least partially adjacent to its parent surface.
/// See the various requests for details about possible rules.
/// At the time of the request, the compositor makes a copy of the rules
/// specified by the xdg_positioner. Thus, after the request is complete the
/// xdg_positioner object can be destroyed or reused; further changes to the
/// object will have no effect on previous usages.
/// For an xdg_positioner object to be considered complete, it must have a
/// non-zero size set by set_size, and a non-zero anchor rectangle set by
/// set_anchor_rect. Passing an incomplete xdg_positioner object when
/// positioning a surface raises an invalid_positioner error.
public final class XdgPositioner: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_positioner",
            version: 7,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "set_size",
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
                    name: "set_anchor_rect",
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
                    name: "set_anchor",
                    arguments: [
                        Argument(
                            name: "anchor",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "set_gravity",
                    arguments: [
                        Argument(
                            name: "gravity",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "set_constraint_adjustment",
                    arguments: [
                        Argument(
                            name: "constraint_adjustment",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "set_offset",
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
                    name: "set_reactive",
                    arguments: [],
                    since: 3
                ),
                Message(
                    name: "set_parent_size",
                    arguments: [
                        Argument(
                            name: "parent_width",
                            type: .int,
                        ),
                        Argument(
                            name: "parent_height",
                            type: .int,
                        ),
                    ],
                    since: 3
                ),
                Message(
                    name: "set_parent_configure",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                    ],
                    since: 3
                ),
            ],
        )
    /// Destroy The Xdg_Positioner Object
    /// 
    /// Notify the compositor that the xdg_positioner will no longer be used.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set The Size Of The To-Be Positioned Rectangle
    /// 
    /// Set the size of the surface that is to be positioned with the positioner
    /// object. The size is in surface-local coordinates and corresponds to the
    /// window geometry. See xdg_surface.set_window_geometry.
    /// If a zero or negative size is set the invalid_input error is raised.
    /// 
    /// - Parameters:
    ///   - width: width of positioned rectangle
    ///   - height: height of positioned rectangle
    public func setSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .int(width),
            .int(height),
        ])
    }

    /// Set The Anchor Rectangle Within The Parent Surface
    /// 
    /// Specify the anchor rectangle within the parent surface that the child
    /// surface will be placed relative to. The rectangle is relative to the
    /// window geometry as defined by xdg_surface.set_window_geometry of the
    /// parent surface.
    /// When the xdg_positioner object is used to position a child surface, the
    /// anchor rectangle may not extend outside the window geometry of the
    /// positioned child's parent surface.
    /// If a negative size is set the invalid_input error is raised.
    /// 
    /// - Parameters:
    ///   - x: x position of anchor rectangle
    ///   - y: y position of anchor rectangle
    ///   - width: width of anchor rectangle
    ///   - height: height of anchor rectangle
    public func setAnchorRect(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(x),
            .int(y),
            .int(width),
            .int(height),
        ])
    }

    /// Set Anchor Rectangle Anchor
    /// 
    /// Defines the anchor point for the anchor rectangle. The specified anchor
    /// is used to derive an anchor point that the child surface will be
    /// positioned relative to. If a corner anchor is set (e.g. 'top_left' or
    /// 'bottom_right'), the anchor point will be at the specified corner;
    /// otherwise, the derived anchor point will be centered on the specified
    /// edge, or in the center of the anchor rectangle if no edge is specified.
    /// 
    /// - Parameters:
    ///   - _: anchor point
    public func setAnchor(_ anchor: Anchor) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(anchor.rawValue),
        ])
    }

    /// Set Child Surface Gravity
    /// 
    /// Defines in what direction a surface should be positioned, relative to
    /// the anchor point of the parent surface. If a corner gravity is
    /// specified (e.g. 'bottom_right' or 'top_left'), then the child surface
    /// will be placed towards the specified gravity; otherwise, the child
    /// surface will be centered over the anchor point on any axis that had no
    /// gravity specified. If the gravity is not in the ‘gravity’ enum, an
    /// invalid_input error is raised.
    /// 
    /// - Parameters:
    ///   - _: gravity direction
    public func setGravity(_ gravity: Gravity) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .uint(gravity.rawValue),
        ])
    }

    /// Set The Adjustment To Be Done When Constrained
    /// 
    /// Specify how the window should be positioned if the originally intended
    /// position caused the surface to be constrained, meaning at least
    /// partially outside positioning boundaries set by the compositor. The
    /// adjustment is set by constructing a bitmask describing the adjustment to
    /// be made when the surface is constrained on that axis.
    /// If no bit for one axis is set, the compositor will assume that the child
    /// surface should not change its position on that axis when constrained.
    /// If more than one bit for one axis is set, the order of how adjustments
    /// are applied is specified in the corresponding adjustment descriptions.
    /// The default adjustment is none.
    /// 
    /// - Parameters:
    ///   - _: bit mask of constraint adjustments
    public func setConstraintAdjustment(_ constraintAdjustment: ConstraintAdjustment) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .uint(constraintAdjustment.rawValue),
        ])
    }

    /// Set Surface Position Offset
    /// 
    /// Specify the surface position offset relative to the position of the
    /// anchor on the anchor rectangle and the anchor on the surface. For
    /// example if the anchor of the anchor rectangle is at (x, y), the surface
    /// has the gravity bottom|right, and the offset is (ox, oy), the calculated
    /// surface position will be (x + ox, y + oy). The offset position of the
    /// surface is the one used for constraint testing. See
    /// set_constraint_adjustment.
    /// An example use case is placing a popup menu on top of a user interface
    /// element, while aligning the user interface element of the parent surface
    /// with some user interface element placed somewhere in the popup surface.
    /// 
    /// - Parameters:
    ///   - x: surface position x offset
    ///   - y: surface position y offset
    public func setOffset(x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .int(x),
            .int(y),
        ])
    }

    /// Continuously Reconstrain The Surface
    /// 
    /// When set reactive, the surface is reconstrained if the conditions used
    /// for constraining changed, e.g. the parent window moved.
    /// If the conditions changed and the popup was reconstrained, an
    /// xdg_popup.configure event is sent with updated geometry, followed by an
    /// xdg_surface.configure event.
    public func setReactive() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 7, [
        ])
    }

    /// Set Parent Size
    /// 
    /// Set the parent window geometry the compositor should use when
    /// positioning the popup. The compositor may use this information to
    /// determine the future state the popup should be constrained using. If
    /// this doesn't match the dimension of the parent the popup is eventually
    /// positioned against, the behavior is undefined.
    /// The arguments are given in the surface-local coordinate space.
    /// 
    /// - Parameters:
    ///   - parentWidth: future window geometry width of parent
    ///   - parentHeight: future window geometry height of parent
    public func setParentSize(parentWidth: Int32, parentHeight: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 8, [
            .int(parentWidth),
            .int(parentHeight),
        ])
    }

    /// Set Parent Configure This Is A Response To
    /// 
    /// Set the serial of an xdg_surface.configure event this positioner will be
    /// used in response to. The compositor may use this information together
    /// with set_parent_size to determine what future state the popup should be
    /// constrained using.
    /// 
    /// - Parameters:
    ///   - serial: serial of parent configure event
    public func setParentConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 9, [
            .uint(serial),
        ])
    }

    
    public static let `protocol`: Protocol = XdgShellProtocol
    
    public enum Error: UInt32 {
        /// invalid input provided
        case invalidInput = 0
    }

    public enum Anchor: UInt32 {
        case `none` = 0

        case top = 1

        case bottom = 2

        case `left` = 3

        case `right` = 4

        case topLeft = 5

        case bottomLeft = 6

        case topRight = 7

        case bottomRight = 8
    }

    public enum Gravity: UInt32 {
        case `none` = 0

        case top = 1

        case bottom = 2

        case `left` = 3

        case `right` = 4

        case topLeft = 5

        case bottomLeft = 6

        case topRight = 7

        case bottomRight = 8
    }

    public struct ConstraintAdjustment: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        public static let `none`: ConstraintAdjustment = []

        public static let slideX = ConstraintAdjustment(rawValue: 1)

        public static let slideY = ConstraintAdjustment(rawValue: 2)

        public static let flipX = ConstraintAdjustment(rawValue: 4)

        public static let flipY = ConstraintAdjustment(rawValue: 8)

        public static let resizeX = ConstraintAdjustment(rawValue: 16)

        public static let resizeY = ConstraintAdjustment(rawValue: 32)
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

/// Desktop User Interface Surface Base Interface
/// 
/// An interface that may be implemented by a wl_surface, for
/// implementations that provide a desktop-style user interface.
/// It provides a base set of functionality required to construct user
/// interface elements requiring management by the compositor, such as
/// toplevel windows, menus, etc. The types of functionality are split into
/// xdg_surface roles.
/// Creating an xdg_surface does not set the role for a wl_surface. In order
/// to map an xdg_surface, the client must create a role-specific object
/// using, e.g., get_toplevel, get_popup. The wl_surface for any given
/// xdg_surface can have at most one role, and may not be assigned any role
/// not based on xdg_surface.
/// A role must be assigned before any other requests are made to the
/// xdg_surface object.
/// The client must call wl_surface.commit on the corresponding wl_surface
/// for the xdg_surface state to take effect.
/// Creating an xdg_surface from a wl_surface which has a buffer attached or
/// committed is a client error, and any attempts by a client to attach or
/// manipulate a buffer prior to the first xdg_surface.configure call must
/// also be treated as errors.
/// After creating a role-specific object and setting it up (e.g. by sending
/// the title, app ID, size constraints, parent, etc), the client must
/// perform an initial commit without any buffer attached. The compositor
/// will reply with initial wl_surface state such as
/// wl_surface.preferred_buffer_scale followed by an xdg_surface.configure
/// event. The client must acknowledge it and is then allowed to attach a
/// buffer to map the surface.
/// Mapping an xdg_surface-based role surface is defined as making it
/// possible for the surface to be shown by the compositor. Note that
/// a mapped surface is not guaranteed to be visible once it is mapped.
/// For an xdg_surface to be mapped by the compositor, the following
/// conditions must be met:
/// (1) the client has assigned an xdg_surface-based role to the surface
/// (2) the client has set and committed the xdg_surface state and the
/// role-dependent state to the surface
/// (3) the client has committed a buffer to the surface
/// A newly-unmapped surface is considered to have met condition (1) out
/// of the 3 required conditions for mapping a surface if its role surface
/// has not been destroyed, i.e. the client must perform the initial commit
/// again before attaching a buffer.
public final class XdgSurface: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_surface",
            version: 7,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "get_toplevel",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "xdg_toplevel",
                        ),
                    ],
                ),
                Message(
                    name: "get_popup",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "xdg_popup",
                        ),
                        Argument(
                            name: "parent",
                            type: .object,
                            interface: "xdg_surface",
                            nullable: true,
                        ),
                        Argument(
                            name: "positioner",
                            type: .object,
                            interface: "xdg_positioner",
                        ),
                    ],
                ),
                Message(
                    name: "set_window_geometry",
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
                    name: "ack_configure",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                    ],
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
                    ],
                ),
            ]
        )
    /// Destroy The Xdg_Surface
    /// 
    /// Destroy the xdg_surface object. An xdg_surface must only be destroyed
    /// after its role object has been destroyed, otherwise
    /// a defunct_role_object error is raised.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Assign The Xdg_Toplevel Surface Role
    /// 
    /// This creates an xdg_toplevel object for the given xdg_surface and gives
    /// the associated wl_surface the xdg_toplevel role.
    /// See the documentation of xdg_toplevel for more details about what an
    /// xdg_toplevel is and how it is used.
    public func getToplevel(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgToplevel {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgToplevel.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
        ])
        return id
    }

    /// Assign The Xdg_Popup Surface Role
    /// 
    /// This creates an xdg_popup object for the given xdg_surface and gives
    /// the associated wl_surface the xdg_popup role.
    /// If null is passed as a parent, a parent surface must be specified using
    /// some other protocol, before committing the initial state.
    /// See the documentation of xdg_popup for more details about what an
    /// xdg_popup is and how it is used.
    /// 
    /// - Parameters:
    ///   - parent: parent surface for this popup
    ///   - positioner: positioner for this popup
    public func getPopup(parent: XdgSurface? = nil, positioner: XdgPositioner, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgPopup {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgPopup.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(id.id),
            .object(parent?.id ?? 0),
            .object(positioner.id),
        ])
        return id
    }

    /// Set The New Window Geometry
    /// 
    /// The window geometry of a surface is its "visible bounds" from the
    /// user's perspective. Client-side decorations often have invisible
    /// portions like drop-shadows which should be ignored for the
    /// purposes of aligning, placing and constraining windows. Note that
    /// in some situations, compositors may clip rendering to the window
    /// geometry, so the client should avoid putting functional elements
    /// outside of it.
    /// The window geometry is double-buffered state, see wl_surface.commit.
    /// When maintaining a position, the compositor should treat the (x, y)
    /// coordinate of the window geometry as the top left corner of the window.
    /// A client changing the (x, y) window geometry coordinate should in
    /// general not alter the position of the window.
    /// Once the window geometry of the surface is set, it is not possible to
    /// unset it, and it will remain the same until set_window_geometry is
    /// called again, even if a new subsurface or buffer is attached.
    /// If never set, the value is the full bounds of the surface,
    /// including any subsurfaces. This updates dynamically on every
    /// commit. This unset is meant for extremely simple clients.
    /// The arguments are given in the surface-local coordinate space of
    /// the wl_surface associated with this xdg_surface, and may extend outside
    /// of the wl_surface itself to mark parts of the subsurface tree as part of
    /// the window geometry.
    /// When applied, the effective window geometry will be the set window
    /// geometry clamped to the bounding rectangle of the combined
    /// geometry of the surface of the xdg_surface and the associated
    /// subsurfaces.
    /// The effective geometry will not be recalculated unless a new call to
    /// set_window_geometry is done and the new pending surface state is
    /// subsequently applied.
    /// The width and height of the effective window geometry must be
    /// greater than zero. Setting an invalid size will raise an
    /// invalid_size error.
    /// 
    /// - Parameters:
    ///   - x: x coordinate of the top-left corner of the window inside this surface
    ///   - y: y coordinate of the top-left corner of the window inside this surface
    ///   - width: width of the window
    ///   - height: height of the window
    public func setWindowGeometry(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .int(x),
            .int(y),
            .int(width),
            .int(height),
        ])
    }

    /// Ack A Configure Event
    /// 
    /// When a configure event is received, if a client commits the
    /// surface in response to the configure event, then the client
    /// must make an ack_configure request sometime before the commit
    /// request, passing along the serial of the configure event.
    /// For instance, for toplevel surfaces the compositor might use this
    /// information to move a surface to the top left only when the client has
    /// drawn itself for the maximized or fullscreen state.
    /// If the client receives multiple configure events before it
    /// can respond to one, it only has to ack the last configure event.
    /// Acking a configure event that was never sent raises an invalid_serial
    /// error.
    /// A client is not required to commit immediately after sending
    /// an ack_configure request - it may even ack_configure several times
    /// before its next surface commit.
    /// A client may send multiple ack_configure requests before committing, but
    /// only the last request sent before a commit indicates which configure
    /// event the client really is responding to.
    /// Sending an ack_configure request consumes the serial number sent with
    /// the request, as well as serial numbers sent by all configure events
    /// sent on this xdg_surface prior to the configure event referenced by
    /// the committed serial.
    /// It is an error to issue multiple ack_configure requests referencing a
    /// serial from the same configure event, or to issue an ack_configure
    /// request referencing a serial from a configure event issued before the
    /// event identified by the last ack_configure request for the same
    /// xdg_surface. Doing so will raise an invalid_serial error.
    /// 
    /// - Parameters:
    ///   - serial: the serial from the configure event
    public func ackConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .uint(serial),
        ])
    }

    
    public static let `protocol`: Protocol = XdgShellProtocol
    
    public enum Error: UInt32 {
        /// Surface was not fully constructed
        case notConstructed = 1

        /// Surface was already constructed
        case alreadyConstructed = 2

        /// Attaching a buffer to an unconfigured surface
        case unconfiguredBuffer = 3

        /// Invalid serial number when acking a configure event
        case invalidSerial = 4

        /// Width or height was zero or negative
        case invalidSize = 5

        /// Surface was destroyed before its role object
        case defunctRoleObject = 6
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
        /// The configure event marks the end of a configure sequence. A configure
        /// sequence is a set of one or more events configuring the state of the
        /// xdg_surface, including the final xdg_surface.configure event.
        /// Where applicable, xdg_surface surface roles will during a configure
        /// sequence extend this event as a latched state sent as events before the
        /// xdg_surface.configure event. Such events should be considered to make up
        /// a set of atomically applied configuration states, where the
        /// xdg_surface.configure commits the accumulated state.
        /// Clients should arrange their surface for the new states, and then send
        /// an ack_configure request with the serial sent in this configure event at
        /// some point before committing the new surface.
        /// If the client receives multiple configure events before it can respond
        /// to one, it is free to discard all but the last event it received.
        case configure(serial: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.configure(serial: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Toplevel Surface
/// 
/// This interface defines an xdg_surface role which allows a surface to,
/// among other things, set window-like properties such as maximize,
/// fullscreen, and minimize, set application-specific metadata like title and
/// id, and well as trigger user interactive operations such as interactive
/// resize and move.
/// An xdg_toplevel by default is responsible for providing the full intended
/// visual representation of the toplevel, which depending on the window
/// state, may mean things like a title bar, window controls and drop shadow.
/// Unmapping an xdg_toplevel means that the surface cannot be shown
/// by the compositor until it is explicitly mapped again.
/// All active operations (e.g., move, resize) are canceled and all
/// attributes (e.g. title, state, stacking, ...) are discarded for
/// an xdg_toplevel surface when it is unmapped. The xdg_toplevel returns to
/// the state it had right after xdg_surface.get_toplevel. The client
/// can re-map the toplevel by performing a commit without any buffer
/// attached, waiting for a configure event and handling it as usual (see
/// xdg_surface description).
/// Attaching a null buffer to a toplevel unmaps the surface.
public final class XdgToplevel: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_toplevel",
            version: 7,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "set_parent",
                    arguments: [
                        Argument(
                            name: "parent",
                            type: .object,
                            interface: "xdg_toplevel",
                            nullable: true,
                        ),
                    ],
                ),
                Message(
                    name: "set_title",
                    arguments: [
                        Argument(
                            name: "title",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "set_app_id",
                    arguments: [
                        Argument(
                            name: "app_id",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "show_window_menu",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        ),
                        Argument(
                            name: "serial",
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
                    ],
                ),
                Message(
                    name: "move",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        ),
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "resize",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        ),
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                        Argument(
                            name: "edges",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "set_max_size",
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
                    name: "set_min_size",
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
                    name: "set_maximized",
                    arguments: [],
                ),
                Message(
                    name: "unset_maximized",
                    arguments: [],
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
                ),
                Message(
                    name: "unset_fullscreen",
                    arguments: [],
                ),
                Message(
                    name: "set_minimized",
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "configure",
                    arguments: [
                        Argument(
                            name: "width",
                            type: .int,
                        ),
                        Argument(
                            name: "height",
                            type: .int,
                        ),
                        Argument(
                            name: "states",
                            type: .array,
                        ),
                    ],
                ),
                Message(
                    name: "close",
                    arguments: [],
                ),
                Message(
                    name: "configure_bounds",
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
                    since: 4
                ),
                Message(
                    name: "wm_capabilities",
                    arguments: [
                        Argument(
                            name: "capabilities",
                            type: .array,
                        ),
                    ],
                    since: 5
                ),
            ]
        )
    /// Destroy The Xdg_Toplevel
    /// 
    /// This request destroys the role surface and unmaps the surface;
    /// see "Unmapping" behavior in interface section for details.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set The Parent Of This Surface
    /// 
    /// Set the "parent" of this surface. This surface should be stacked
    /// above the parent surface and all other ancestor surfaces.
    /// Parent surfaces should be set on dialogs, toolboxes, or other
    /// "auxiliary" surfaces, so that the parent is raised when the dialog
    /// is raised.
    /// Setting a null parent for a child surface unsets its parent. Setting
    /// a null parent for a surface which currently has no parent is a no-op.
    /// Only mapped surfaces can have child surfaces. Setting a parent which
    /// is not mapped is equivalent to setting a null parent. If a surface
    /// becomes unmapped, its children's parent is set to the parent of
    /// the now-unmapped surface. If the now-unmapped surface has no parent,
    /// its children's parent is unset. If the now-unmapped surface becomes
    /// mapped again, its parent-child relationship is not restored.
    /// The parent toplevel must not be one of the child toplevel's
    /// descendants, and the parent must be different from the child toplevel,
    /// otherwise the invalid_parent protocol error is raised.
    /// 
    /// - Parameters:
    ///   - _: parent surface for this surface
    public func setParent(_ parent: XdgToplevel? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(parent?.id ?? 0),
        ])
    }

    /// Set Surface Title
    /// 
    /// Set a short title for the surface.
    /// This string may be used to identify the surface in a task bar,
    /// window list, or other user interface elements provided by the
    /// compositor.
    /// The string must be encoded in UTF-8.
    /// 
    /// - Parameters:
    ///   - _: title of the surface
    public func setTitle(_ title: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .string(title),
        ])
    }

    /// Set Application Id
    /// 
    /// Set an application identifier for the surface.
    /// The app ID identifies the general class of applications to which
    /// the surface belongs. The compositor can use this to group multiple
    /// surfaces together, or to determine how to launch a new application.
    /// For D-Bus activatable applications, the app ID is used as the D-Bus
    /// service name.
    /// The compositor shell will try to group application surfaces together
    /// by their app ID. As a best practice, it is suggested to select app
    /// ID's that match the basename of the application's .desktop file.
    /// For example, "org.freedesktop.FooViewer" where the .desktop file is
    /// "org.freedesktop.FooViewer.desktop".
    /// Like other properties, a set_app_id request can be sent after the
    /// xdg_toplevel has been mapped to update the property.
    /// See the desktop-entry specification [0] for more details on
    /// application identifiers and how they relate to well-known D-Bus
    /// names and .desktop files.
    /// [0] https://standards.freedesktop.org/desktop-entry-spec/
    /// 
    /// - Parameters:
    ///   - _: application identifier surface belongs to
    public func setAppId(_ appId: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .string(appId),
        ])
    }

    /// Show The Window Menu
    /// 
    /// Clients implementing client-side decorations might want to show
    /// a context menu when right-clicking on the decorations, giving the
    /// user a menu that they can use to maximize or minimize the window.
    /// This request asks the compositor to pop up such a window menu at
    /// the given position, relative to the local surface coordinates of
    /// the parent surface. There are no guarantees as to what menu items
    /// the window menu contains, or even if a window menu will be drawn
    /// at all.
    /// This request must be used in response to some sort of user action
    /// like a button press, key press, or touch down event.
    /// 
    /// - Parameters:
    ///   - seat: the wl_seat of the user event
    ///   - serial: the serial of the user event
    ///   - x: the x position to pop up the window menu at
    ///   - y: the y position to pop up the window menu at
    public func showWindowMenu(seat: WlSeat, serial: UInt32, x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .object(seat.id),
            .uint(serial),
            .int(x),
            .int(y),
        ])
    }

    /// Start An Interactive Move
    /// 
    /// Start an interactive, user-driven move of the surface.
    /// This request must be used in response to some sort of user action
    /// like a button press, key press, or touch down event. The passed
    /// serial is used to determine the type of interactive move (touch,
    /// pointer, etc).
    /// The server may ignore move requests depending on the state of
    /// the surface (e.g. fullscreen or maximized), or if the passed serial
    /// is no longer valid.
    /// If triggered, the surface will lose the focus of the device
    /// (wl_pointer, wl_touch, etc) used for the move. It is up to the
    /// compositor to visually indicate that the move is taking place, such as
    /// updating a pointer cursor, during the move. There is no guarantee
    /// that the device focus will return when the move is completed.
    /// 
    /// - Parameters:
    ///   - seat: the wl_seat of the user event
    ///   - serial: the serial of the user event
    public func move(seat: WlSeat, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .object(seat.id),
            .uint(serial),
        ])
    }

    /// Start An Interactive Resize
    /// 
    /// Start a user-driven, interactive resize of the surface.
    /// This request must be used in response to some sort of user action
    /// like a button press, key press, or touch down event. The passed
    /// serial is used to determine the type of interactive resize (touch,
    /// pointer, etc).
    /// The server may ignore resize requests depending on the state of
    /// the surface (e.g. fullscreen or maximized).
    /// If triggered, the client will receive configure events with the
    /// "resize" state enum value and the expected sizes. See the "resize"
    /// enum value for more details about what is required. The client
    /// must also acknowledge configure events using "ack_configure". After
    /// the resize is completed, the client will receive another "configure"
    /// event without the resize state.
    /// If triggered, the surface also will lose the focus of the device
    /// (wl_pointer, wl_touch, etc) used for the resize. It is up to the
    /// compositor to visually indicate that the resize is taking place,
    /// such as updating a pointer cursor, during the resize. There is no
    /// guarantee that the device focus will return when the resize is
    /// completed.
    /// The edges parameter specifies how the surface should be resized, and
    /// is one of the values of the resize_edge enum. Values not matching
    /// a variant of the enum will cause the invalid_resize_edge protocol error.
    /// The compositor may use this information to update the surface position
    /// for example when dragging the top left corner. The compositor may also
    /// use this information to adapt its behavior, e.g. choose an appropriate
    /// cursor image.
    /// 
    /// - Parameters:
    ///   - seat: the wl_seat of the user event
    ///   - serial: the serial of the user event
    ///   - edges: which edge or corner is being dragged
    public func resize(seat: WlSeat, serial: UInt32, edges: ResizeEdge) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .object(seat.id),
            .uint(serial),
            .uint(edges.rawValue),
        ])
    }

    /// Set The Maximum Size
    /// 
    /// Set a maximum size for the window.
    /// The client can specify a maximum size so that the compositor does
    /// not try to configure the window beyond this size.
    /// The width and height arguments are in window geometry coordinates.
    /// See xdg_surface.set_window_geometry.
    /// Values set in this way are double-buffered, see wl_surface.commit.
    /// The compositor can use this information to allow or disallow
    /// different states like maximize or fullscreen and draw accurate
    /// animations.
    /// Similarly, a tiling window manager may use this information to
    /// place and resize client windows in a more effective way.
    /// The client should not rely on the compositor to obey the maximum
    /// size. The compositor may decide to ignore the values set by the
    /// client and request a larger size.
    /// If never set, or a value of zero in the request, means that the
    /// client has no expected maximum size in the given dimension.
    /// As a result, a client wishing to reset the maximum size
    /// to an unspecified state can use zero for width and height in the
    /// request.
    /// Requesting a maximum size to be smaller than the minimum size of
    /// a surface is illegal and will result in an invalid_size error.
    /// The width and height must be greater than or equal to zero. Using
    /// strictly negative values for width or height will result in an
    /// invalid_size error.
    /// 
    /// - Parameters:
    ///   - width: maximum width of the window
    ///   - height: maximum height of the window
    public func setMaxSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
            .int(width),
            .int(height),
        ])
    }

    /// Set The Minimum Size
    /// 
    /// Set a minimum size for the window.
    /// The client can specify a minimum size so that the compositor does
    /// not try to configure the window below this size.
    /// The width and height arguments are in window geometry coordinates.
    /// See xdg_surface.set_window_geometry.
    /// Values set in this way are double-buffered, see wl_surface.commit.
    /// The compositor can use this information to allow or disallow
    /// different states like maximize or fullscreen and draw accurate
    /// animations.
    /// Similarly, a tiling window manager may use this information to
    /// place and resize client windows in a more effective way.
    /// The client should not rely on the compositor to obey the minimum
    /// size. The compositor may decide to ignore the values set by the
    /// client and request a smaller size.
    /// If never set, or a value of zero in the request, means that the
    /// client has no expected minimum size in the given dimension.
    /// As a result, a client wishing to reset the minimum size
    /// to an unspecified state can use zero for width and height in the
    /// request.
    /// Requesting a minimum size to be larger than the maximum size of
    /// a surface is illegal and will result in an invalid_size error.
    /// The width and height must be greater than or equal to zero. Using
    /// strictly negative values for width and height will result in an
    /// invalid_size error.
    /// 
    /// - Parameters:
    ///   - width: minimum width of the window
    ///   - height: minimum height of the window
    public func setMinSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .int(width),
            .int(height),
        ])
    }

    /// Maximize The Window
    /// 
    /// Maximize the surface.
    /// After requesting that the surface should be maximized, the compositor
    /// will respond by emitting a configure event. Whether this configure
    /// actually sets the window maximized is subject to compositor policies.
    /// The client must then update its content, drawing in the configured
    /// state. The client must also acknowledge the configure when committing
    /// the new content (see ack_configure).
    /// It is up to the compositor to decide how and where to maximize the
    /// surface, for example which output and what region of the screen should
    /// be used.
    /// If the surface was already maximized, the compositor will still emit
    /// a configure event with the "maximized" state.
    /// If the surface is in a fullscreen state, this request has no direct
    /// effect. It may alter the state the surface is returned to when
    /// unmaximized unless overridden by the compositor.
    public func setMaximized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 9, [
        ])
    }

    /// Unmaximize The Window
    /// 
    /// Unmaximize the surface.
    /// After requesting that the surface should be unmaximized, the compositor
    /// will respond by emitting a configure event. Whether this actually
    /// un-maximizes the window is subject to compositor policies.
    /// If available and applicable, the compositor will include the window
    /// geometry dimensions the window had prior to being maximized in the
    /// configure event. The client must then update its content, drawing it in
    /// the configured state. The client must also acknowledge the configure
    /// when committing the new content (see ack_configure).
    /// It is up to the compositor to position the surface after it was
    /// unmaximized; usually the position the surface had before maximizing, if
    /// applicable.
    /// If the surface was already not maximized, the compositor will still
    /// emit a configure event without the "maximized" state.
    /// If the surface is in a fullscreen state, this request has no direct
    /// effect. It may alter the state the surface is returned to when
    /// unmaximized unless overridden by the compositor.
    public func unsetMaximized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 10, [
        ])
    }

    /// Set The Window As Fullscreen On An Output
    /// 
    /// Make the surface fullscreen.
    /// After requesting that the surface should be fullscreened, the
    /// compositor will respond by emitting a configure event. Whether the
    /// client is actually put into a fullscreen state is subject to compositor
    /// policies. The client must also acknowledge the configure when
    /// committing the new content (see ack_configure).
    /// The output passed by the request indicates the client's preference as
    /// to which display it should be set fullscreen on. If this value is NULL,
    /// it's up to the compositor to choose which display will be used to map
    /// this surface.
    /// If the surface doesn't cover the whole output, the compositor will
    /// position the surface in the center of the output and compensate with
    /// border fill covering the rest of the output. The content of the
    /// border fill is undefined, but should be assumed to be in some way that
    /// attempts to blend into the surrounding area (e.g. solid black).
    /// If the fullscreened surface is not opaque, the compositor must make
    /// sure that other screen content not part of the same surface tree (made
    /// up of subsurfaces, popups or similarly coupled surfaces) are not
    /// visible below the fullscreened surface.
    /// 
    /// - Parameters:
    ///   - output: preferred output to place surface on
    public func setFullscreen(output: WlOutput? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 11, [
            .object(output?.id ?? 0),
        ])
    }

    /// Unset The Window As Fullscreen
    /// 
    /// Make the surface no longer fullscreen.
    /// After requesting that the surface should be unfullscreened, the
    /// compositor will respond by emitting a configure event.
    /// Whether this actually removes the fullscreen state of the client is
    /// subject to compositor policies.
    /// Making a surface unfullscreen sets states for the surface based on the following:
    /// * the state(s) it may have had before becoming fullscreen
    /// * any state(s) decided by the compositor
    /// * any state(s) requested by the client while the surface was fullscreen
    /// The compositor may include the previous window geometry dimensions in
    /// the configure event, if applicable.
    /// The client must also acknowledge the configure when committing the new
    /// content (see ack_configure).
    public func unsetFullscreen() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 12, [
        ])
    }

    /// Set The Window As Minimized
    /// 
    /// Request that the compositor minimize your surface. There is no
    /// way to know if the surface is currently minimized, nor is there
    /// any way to unset minimization on this surface.
    /// If you are looking to throttle redrawing when minimized, please
    /// instead use the wl_surface.frame event for this, as this will
    /// also work with live previews on windows in Alt-Tab, Expose or
    /// similar compositor features.
    public func setMinimized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 13, [
        ])
    }

    
    public static let `protocol`: Protocol = XdgShellProtocol
    
    public enum Error: UInt32 {
        /// provided value is         not a valid variant of the resize_edge enum
        case invalidResizeEdge = 0

        /// invalid parent toplevel
        case invalidParent = 1

        /// client provided an invalid min or max size
        case invalidSize = 2
    }

    public enum ResizeEdge: UInt32 {
        case `none` = 0

        case top = 1

        case bottom = 2

        case `left` = 4

        case topLeft = 5

        case bottomLeft = 6

        case `right` = 8

        case topRight = 9

        case bottomRight = 10
    }

    public enum State: UInt32 {
        /// the surface is maximized
        case maximized = 1

        /// the surface is fullscreen
        case fullscreen = 2

        /// the surface is being resized
        case resizing = 3

        /// the surface is now activated
        case activated = 4

        case tiledLeft = 5

        case tiledRight = 6

        case tiledTop = 7

        case tiledBottom = 8

        case suspended = 9

        case constrainedLeft = 10

        case constrainedRight = 11

        case constrainedTop = 12

        case constrainedBottom = 13
    }

    public enum WmCapabilities: UInt32 {
        /// show_window_menu is available
        case windowMenu = 1

        /// set_maximized and unset_maximized are available
        case maximize = 2

        /// set_fullscreen and unset_fullscreen are available
        case fullscreen = 3

        /// set_minimized is available
        case minimize = 4
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
        /// This configure event asks the client to resize its toplevel surface or
        /// to change its state. The configured state should not be applied
        /// immediately. See xdg_surface.configure for details.
        /// The width and height arguments specify a hint to the window
        /// about how its surface should be resized in window geometry
        /// coordinates. See set_window_geometry.
        /// If the width or height arguments are zero, it means the client
        /// should decide its own window dimension. This may happen when the
        /// compositor needs to configure the state of the surface but doesn't
        /// have any information about any previous or expected dimension.
        /// The states listed in the event specify how the width/height
        /// arguments should be interpreted, and possibly how it should be
        /// drawn.
        /// The states are sent as an array of 32-bit unsigned integers in
        /// native endianness. State values are defined in the state enum.
        /// Clients must send an ack_configure in response to this event. See
        /// xdg_surface.configure and xdg_surface.ack_configure for details.
        case configure(width: Int32, height: Int32, states: Data)

        /// Surface Wants To Be Closed
        /// 
        /// The close event is sent by the compositor when the user
        /// wants the surface to be closed. This should be equivalent to
        /// the user clicking the close button in client-side decorations,
        /// if your application has any.
        /// This is only a request that the user intends to close the
        /// window. The client may choose to ignore this request, or show
        /// a dialog to ask the user to save their data, etc.
        case close

        /// Recommended Window Geometry Bounds
        /// 
        /// The configure_bounds event may be sent prior to a xdg_toplevel.configure
        /// event to communicate the bounds a window geometry size is recommended
        /// to constrain to.
        /// The passed width and height are in surface coordinate space. If width
        /// and height are 0, it means bounds is unknown and equivalent to as if no
        /// configure_bounds event was ever sent for this surface.
        /// The bounds can for example correspond to the size of a monitor excluding
        /// any panels or other shell components, so that a surface isn't created in
        /// a way that it cannot fit.
        /// The bounds may change at any point, and in such a case, a new
        /// xdg_toplevel.configure_bounds will be sent, followed by
        /// xdg_toplevel.configure and xdg_surface.configure.
        case configureBounds(width: Int32, height: Int32)

        /// Compositor Capabilities
        /// 
        /// This event advertises the capabilities supported by the compositor. If
        /// a capability isn't supported, clients should hide or disable the UI
        /// elements that expose this functionality. For instance, if the
        /// compositor doesn't advertise support for minimized toplevels, a button
        /// triggering the set_minimized request should not be displayed.
        /// The compositor will ignore requests it doesn't support. For instance,
        /// a compositor which doesn't advertise support for minimized will ignore
        /// set_minimized requests.
        /// Compositors must send this event once before the first
        /// xdg_surface.configure event. When the capabilities change, compositors
        /// must send this event again and then send an xdg_surface.configure
        /// event.
        /// The configured state should not be applied immediately. See
        /// xdg_surface.configure for details.
        /// The capabilities are sent as an array of 32-bit unsigned integers in
        /// native endianness. Capability values are defined in the wm_capabilities enum.
        case wmCapabilities(capabilities: Data)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.configure(width: r.int(), height: r.int(), states: r.array())
            case 1:
                self = Self.close
            case 2:
                self = Self.configureBounds(width: r.int(), height: r.int())
            case 3:
                self = Self.wmCapabilities(capabilities: r.array())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Short-Lived, Popup Surfaces For Menus
/// 
/// A popup surface is a short-lived, temporary surface. It can be used to
/// implement for example menus, popovers, tooltips and other similar user
/// interface concepts.
/// A popup can be made to take an explicit grab. See xdg_popup.grab for
/// details.
/// When the popup is dismissed, a popup_done event will be sent out, and at
/// the same time the surface will be unmapped. See the xdg_popup.popup_done
/// event for details.
/// Explicitly destroying the xdg_popup object will also dismiss the popup and
/// unmap the surface. Clients that want to dismiss the popup when another
/// surface of their own is clicked should dismiss the popup using the destroy
/// request.
/// A newly created xdg_popup will be stacked on top of all previously created
/// xdg_popup surfaces associated with the same xdg_toplevel.
/// The parent of an xdg_popup must be mapped (see the xdg_surface
/// description) before the xdg_popup itself.
/// The client must call wl_surface.commit on the corresponding wl_surface
/// for the xdg_popup state to take effect.
public final class XdgPopup: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_popup",
            version: 7,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "grab",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        ),
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "reposition",
                    arguments: [
                        Argument(
                            name: "positioner",
                            type: .object,
                            interface: "xdg_positioner",
                        ),
                        Argument(
                            name: "token",
                            type: .uint,
                        ),
                    ],
                    since: 3
                ),
            ],
            events: [
                Message(
                    name: "configure",
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
                    name: "popup_done",
                    arguments: [],
                ),
                Message(
                    name: "repositioned",
                    arguments: [
                        Argument(
                            name: "token",
                            type: .uint,
                        ),
                    ],
                    since: 3
                ),
            ]
        )
    /// Remove Xdg_Popup Interface
    /// 
    /// This destroys the popup. Explicitly destroying the xdg_popup
    /// object will also dismiss the popup, and unmap the surface.
    /// If this xdg_popup is not the "topmost" popup, the
    /// xdg_wm_base.not_the_topmost_popup protocol error will be sent.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Make The Popup Take An Explicit Grab
    /// 
    /// This request makes the created popup take an explicit grab. An explicit
    /// grab will be dismissed when the user dismisses the popup, or when the
    /// client destroys the xdg_popup. This can be done by the user clicking
    /// outside the surface, using the keyboard, or even locking the screen
    /// through closing the lid or a timeout.
    /// If the compositor denies the grab, the popup will be immediately
    /// dismissed.
    /// This request must be used in response to some sort of user action like a
    /// button press, key press, or touch down event. The serial number of the
    /// event should be passed as 'serial'.
    /// The parent of a grabbing popup must either be an xdg_toplevel surface or
    /// another xdg_popup with an explicit grab. If the parent is another
    /// xdg_popup it means that the popups are nested, with this popup now being
    /// the topmost popup.
    /// Nested popups must be destroyed in the reverse order they were created
    /// in, e.g. the only popup you are allowed to destroy at all times is the
    /// topmost one.
    /// When compositors choose to dismiss a popup, they may dismiss every
    /// nested grabbing popup as well. When a compositor dismisses popups, it
    /// will follow the same dismissing order as required from the client.
    /// If the topmost grabbing popup is destroyed, the grab will be returned to
    /// the parent of the popup, if that parent previously had an explicit grab.
    /// If the parent is a grabbing popup which has already been dismissed, this
    /// popup will be immediately dismissed. If the parent is a popup that did
    /// not take an explicit grab, an error will be raised.
    /// During a popup grab, the client owning the grab will receive pointer
    /// and touch events for all their surfaces as normal (similar to an
    /// "owner-events" grab in X11 parlance), while the top most grabbing popup
    /// will always have keyboard focus.
    /// 
    /// - Parameters:
    ///   - seat: the wl_seat of the user event
    ///   - serial: the serial of the user event
    public func grab(seat: WlSeat, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(seat.id),
            .uint(serial),
        ])
    }

    /// Recalculate The Popup's Location
    /// 
    /// Reposition an already-mapped popup. The popup will be placed given the
    /// details in the passed xdg_positioner object, and a
    /// xdg_popup.repositioned followed by xdg_popup.configure and
    /// xdg_surface.configure will be emitted in response. Any parameters set
    /// by the previous positioner will be discarded.
    /// The passed token will be sent in the corresponding
    /// xdg_popup.repositioned event. The new popup position will not take
    /// effect until the corresponding configure event is acknowledged by the
    /// client. See xdg_popup.repositioned for details. The token itself is
    /// opaque, and has no other special meaning.
    /// If multiple reposition requests are sent, the compositor may skip all
    /// but the last one.
    /// If the popup is repositioned in response to a configure event for its
    /// parent, the client should send an xdg_positioner.set_parent_configure
    /// and possibly an xdg_positioner.set_parent_size request to allow the
    /// compositor to properly constrain the popup.
    /// If the popup is repositioned together with a parent that is being
    /// resized, but not in response to a configure event, the client should
    /// send an xdg_positioner.set_parent_size request.
    /// 
    /// - Parameters:
    ///   - token: reposition request token
    public func reposition(positioner: XdgPositioner, token: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 2, [
            .object(positioner.id),
            .uint(token),
        ])
    }

    
    public static let `protocol`: Protocol = XdgShellProtocol
    
    public enum Error: UInt32 {
        /// tried to grab after being mapped
        case invalidGrab = 0
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
        /// Configure The Popup Surface
        /// 
        /// This event asks the popup surface to configure itself given the
        /// configuration. The configured state should not be applied immediately.
        /// See xdg_surface.configure for details.
        /// The x and y arguments represent the position the popup was placed at
        /// given the xdg_positioner rule, relative to the upper left corner of the
        /// window geometry of the parent surface.
        /// For version 2 or older, the configure event for an xdg_popup is only
        /// ever sent once for the initial configuration. Starting with version 3,
        /// it may be sent again if the popup is setup with an xdg_positioner with
        /// set_reactive requested, or in response to xdg_popup.reposition requests.
        case configure(x: Int32, y: Int32, width: Int32, height: Int32)

        /// Popup Interaction Is Done
        /// 
        /// The popup_done event is sent out when a popup is dismissed by the
        /// compositor. The client should destroy the xdg_popup object at this
        /// point.
        case popupDone

        /// Signal The Completion Of A Repositioned Request
        /// 
        /// The repositioned event is sent as part of a popup configuration
        /// sequence, together with xdg_popup.configure and lastly
        /// xdg_surface.configure to notify the completion of a reposition request.
        /// The repositioned event is to notify about the completion of a
        /// xdg_popup.reposition request. The token argument is the token passed
        /// in the xdg_popup.reposition request.
        /// Immediately after this event is emitted, xdg_popup.configure and
        /// xdg_surface.configure will be sent with the updated size and position,
        /// as well as a new configure serial.
        /// The client should optionally update the content of the popup, but must
        /// acknowledge the new popup configuration for the new position to take
        /// effect. See xdg_surface.ack_configure for details.
        case repositioned(token: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.configure(x: r.int(), y: r.int(), width: r.int(), height: r.int())
            case 1:
                self = Self.popupDone
            case 2:
                self = Self.repositioned(token: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let XdgShellProtocol = Protocol(
        name: "xdg_shell",
        interfaces: [
            XdgWmBase.interface,
XdgPositioner.interface,
XdgSurface.interface,
XdgToplevel.interface,
XdgPopup.interface
        ]
    )

#endif