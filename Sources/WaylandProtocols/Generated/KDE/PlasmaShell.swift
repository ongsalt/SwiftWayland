import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Create Shell Windows And Helpers
/// 
/// This interface is used by KF5 powered Wayland shells to communicate with
/// the compositor and can only be bound one time.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class OrgKdePlasmaShell: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_shell",
            version: 8,
            enums: [],
            requests: [
                Message(
                    name: "get_surface",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "org_kde_plasma_surface"
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
    /// Create A Shell Surface From A Surface
    /// 
    /// Create a shell surface for an existing surface.
    /// Only one shell surface can be associated with a given
    /// surface.
    /// 
    /// - Parameters:
    public func getSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdePlasmaSurface {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdePlasmaSurface.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: PlasmaShell)
    }
    
    public typealias Event = NoEvent
}
/// Metadata Interface
/// 
/// An interface that may be implemented by a wl_surface, for
/// implementations that provide the shell user interface.
/// It provides requests to set surface roles, assign an output
/// or set the position in output coordinates.
/// On the server side the object is automatically destroyed when
/// the related wl_surface is destroyed.  On client side,
/// org_kde_plasma_surface.destroy() must be called before
/// destroying the wl_surface object.
public final class OrgKdePlasmaSurface: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_surface",
            version: 8,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_output",
                    arguments: [
                    Argument(
                        name: "output",
                        type: .object,
                        interface: "wl_output"
                    ),
                    ],
                ),
                Message(
                    name: "set_position",
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
                    name: "set_role",
                    arguments: [
                    Argument(
                        name: "role",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_panel_behavior",
                    arguments: [
                    Argument(
                        name: "flag",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_skip_taskbar",
                    arguments: [
                    Argument(
                        name: "skip",
                        type: .uint,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "panel_auto_hide_hide",
                    arguments: [
                    ],
                    since: 4
                ),
                Message(
                    name: "panel_auto_hide_show",
                    arguments: [
                    ],
                    since: 4
                ),
                Message(
                    name: "set_panel_takes_focus",
                    arguments: [
                    Argument(
                        name: "takes_focus",
                        type: .uint,
                    ),
                    ],
                    since: 4
                ),
                Message(
                    name: "set_skip_switcher",
                    arguments: [
                    Argument(
                        name: "skip",
                        type: .uint,
                    ),
                    ],
                    since: 5
                ),
                Message(
                    name: "open_under_cursor",
                    arguments: [
                    ],
                    since: 7
                ),
                ],
            events: [
                Message(
                    name: "auto_hidden_panel_hidden",
                    arguments: [
                    ],
                    since: 4
                ),
                Message(
                    name: "auto_hidden_panel_shown",
                    arguments: [
                    ],
                    since: 4
                ),
                ],
        )
    /// Remove Org_Kde_Plasma_Surface Interface
    /// 
    /// The org_kde_plasma_surface interface is removed from the
    /// wl_surface object that was turned into a shell surface with the
    /// org_kde_plasma_shell.get_surface request.
    /// The shell surface role is lost and wl_surface is unmapped.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Assign An Output To This Shell Surface
    /// 
    /// Assign an output to this shell surface.
    /// The compositor will use this information to set the position
    /// when org_kde_plasma_surface.set_position request is
    /// called.
    /// 
    /// - Parameters:
    public func setOutput(_ output: WlOutput) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(output.id),
        ])
    }

    /// Change The Shell Surface Position
    /// 
    /// Move the surface to new coordinates.
    /// Coordinates are global, for example 50,50 for a 1920,0+1920x1080 output
    /// is 1970,50 in global coordinates space.
    /// Use org_kde_plasma_surface.set_output to assign an output
    /// to this surface.
    /// 
    /// - Parameters:
    ///   - x: x coordinate in global space
    ///   - y: y coordinate in global space
    public func setPosition(x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(x),
            .int(y),
        ])
    }

    /// Assign A Role To This Surface
    /// 
    /// Assign a role to a shell surface.
    /// The compositor handles surfaces depending on their role.
    /// See the explanation below.
    /// This request fails if the surface already has a role, this means
    /// the surface role may be assigned only once.
    /// == Surfaces with splash role ==
    /// Splash surfaces are placed above every other surface during the
    /// shell startup phase.
    /// The surfaces are placed according to the output coordinates.
    /// No size is imposed to those surfaces, the shell has to resize
    /// them according to output size.
    /// These surfaces are meant to hide the desktop during the startup
    /// phase so that the user will always see a ready to work desktop.
    /// A shell might not create splash surfaces if the compositor reveals
    /// the desktop in an alternative fashion, for example with a fade
    /// in effect.
    /// That depends on how much time the desktop usually need to prepare
    /// the workspace or specific design decisions.
    /// This specification doesn't impose any particular design.
    /// When the startup phase is finished, the shell will send the
    /// org_kde_plasma.desktop_ready request to the compositor.
    /// == Surfaces with desktop role ==
    /// Desktop surfaces are placed below all other surfaces and are used
    /// to show the actual desktop view with icons, search results or
    /// controls the user will interact with. What to show depends on the
    /// shell implementation.
    /// The surfaces are placed according to the output coordinates.
    /// No size is imposed to those surfaces, the shell has to resize
    /// them according to output size.
    /// Only one surface per output can have the desktop role.
    /// == Surfaces with dashboard role ==
    /// Dashboard surfaces are placed above desktop surfaces and are used to
    /// show additional widgets and controls.
    /// The surfaces are placed according to the output coordinates.
    /// No size is imposed to those surfaces, the shell has to resize
    /// them according to output size.
    /// Only one surface per output can have the dashboard role.
    /// == Surfaces with config role ==
    /// A configuration surface is shown when the user wants to configure
    /// panel or desktop views.
    /// Only one surface per output can have the config role.
    /// TODO: This should grab the input like popup menus, right?
    /// == Surfaces with overlay role ==
    /// Overlays are special surfaces that shows for a limited amount
    /// of time.  Such surfaces are useful to display things like volume,
    /// brightness and status changes.
    /// Compositors may decide to show those surfaces in a layer above
    /// all surfaces, even full screen ones if so is desired.
    /// == Surfaces with notification role ==
    /// Notification surfaces display informative content for a limited
    /// amount of time.  The compositor may decide to show them in a corner
    /// depending on the configuration.
    /// These surfaces are shown in a layer above all other surfaces except
    /// for full screen ones.
    /// == Surfaces with lock role ==
    /// The lock surface is shown by the compositor when the session is
    /// locked, users interact with it to unlock the session.
    /// Compositors should move lock surfaces to 0,0 in output
    /// coordinates space and hide all other surfaces for security sake.
    /// For the same reason it is recommended that clients make the
    /// lock surface as big as the screen.
    /// Only one surface per output can have the lock role.
    /// 
    /// - Parameters:
    public func setRole(_ role: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(role),
        ])
    }

    /// Set Or Unset The Panel 
    /// 
    /// Set flags bitmask as described by the flag enum.
    /// Pass 0 to unset any flag, the surface will adjust its behavior to
    /// the default.
    /// Deprecated in Plasma 6. Setting this flag will have no effect. Applications should use layer shell where appropriate.
    /// 
    /// - Parameters:
    ///   - flag: panel_behavior enum value
    public func setPanelBehavior(flag: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .uint(flag),
        ])
    }

    /// Make The Window Skip The Taskbar
    /// 
    /// Setting this bit to the window, will make it say it prefers to not be listed in the taskbar. Taskbar implementations may or may not follow this hint.
    /// 
    /// - Parameters:
    ///   - skip: Boolean value that sets whether to skip the taskbar
    public func setSkipTaskbar(skip: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 5, [
            .uint(skip),
        ])
    }

    /// Hide The Auto-Hiding Panel
    /// 
    /// A panel surface with panel_behavior auto_hide can perform this request to hide the panel
    /// on a screen edge without unmapping it. The compositor informs the client about the panel
    /// being hidden with the event auto_hidden_panel_hidden.
    /// The compositor will restore the visibility state of the
    /// surface when the pointer touches the screen edge the panel borders. Once the compositor restores
    /// the visibility the event auto_hidden_panel_shown will be sent. This event will also be sent
    /// if the compositor is unable to hide the panel.
    /// The client can also request to show the panel again with the request panel_auto_hide_show.
    public func panelAutoHideHide() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 6, [
        ])
    }

    /// Show The Auto-Hiding Panel
    /// 
    /// A panel surface with panel_behavior auto_hide can perform this request to show the panel
    /// again which got hidden with panel_auto_hide_hide.
    public func panelAutoHideShow() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 7, [
        ])
    }

    /// Whether A Panel Takes Focus
    /// 
    /// By default various org_kde_plasma_surface roles do not take focus and cannot be
    /// activated. With this request the compositor can be instructed to pass focus also to this
    /// org_kde_plasma_surface.
    /// 
    /// - Parameters:
    ///   - takesFocus: Boolean value that sets whether the panel takes focus
    public func setPanelTakesFocus(takesFocus: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 8, [
            .uint(takesFocus),
        ])
    }

    /// Make The Window Not Appear In A Switcher
    /// 
    /// Setting this bit will indicate that the window prefers not to be listed in a switcher.
    /// 
    /// - Parameters:
    ///   - skip: Boolean value that sets whether to skip the window switcher.
    public func setSkipSwitcher(skip: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 5 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 5) }
        connection.send(self, 9, [
            .uint(skip),
        ])
    }

    /// Open Under Cursor
    /// 
    /// Request the initial position of this surface to be under the current
    /// cursor position. Has to be called before attaching any buffer to this surface.
    public func openUnderCursor() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 7 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 7) }
        connection.send(self, 10, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: PlasmaShell)
    }
    
    public enum Role: UInt32 {
        case normal = 0

        case desktop = 1

        case panel = 2

        case onscreendisplay = 3

        case notification = 4

        case tooltip = 5

        case criticalnotification = 6

        case appletpopup = 7
    }

    public enum PanelBehavior: UInt32 {
        case alwaysVisible = 1

        case autoHide = 2

        case windowsCanCover = 3

        case windowsGoBelow = 4
    }

    public enum Error: UInt32 {
        /// Request panel_auto_hide performed on a surface which does not correspond to an auto-hide panel.
        case panelNotAutoHide = 0
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
        /// Auto-Hiding Panel Is Hidden
        /// 
        /// An auto-hiding panel got hidden by the compositor.
        case autoHiddenPanelHidden

        /// Auto-Hiding Panel Is Shown
        /// 
        /// An auto-hiding panel got shown by the compositor.
        case autoHiddenPanelShown

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.autoHiddenPanelHidden
            case 1:
                self = Self.autoHiddenPanelShown
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let PlasmaShell = Protocol(
        name: "plasma_shell",
        interfaces: [
            OrgKdePlasmaShell.interface,
OrgKdePlasmaSurface.interface
        ]
    )

#endif