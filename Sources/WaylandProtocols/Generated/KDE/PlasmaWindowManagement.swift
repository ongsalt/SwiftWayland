import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Application Windows Management
/// 
/// This interface manages application windows.
/// It provides requests to show and hide the desktop and emits
/// an event every time a window is created so that the client can
/// use it to manage the window.
/// Only one client can bind this interface at a time.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class OrgKdePlasmaWindowManagement: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_window_management",
            version: 20,
            requests: [
                Message(
                    name: "show_desktop",
                    arguments: [
                        Argument(
                            name: "state",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "get_window",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_plasma_window",
                        ),
                        Argument(
                            name: "internal_window_id",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "get_window_by_uuid",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_plasma_window",
                        ),
                        Argument(
                            name: "internal_window_uuid",
                            type: .string,
                        ),
                    ],
                    since: 12
                ),
                Message(
                    name: "get_stacking_order",
                    arguments: [
                        Argument(
                            name: "stacking_order",
                            type: .newId,
                            interface: "org_kde_plasma_stacking_order",
                        ),
                    ],
                    since: 17
                ),
            ],
            events: [
                Message(
                    name: "show_desktop_changed",
                    arguments: [
                        Argument(
                            name: "state",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "window",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "stacking_order_changed",
                    arguments: [
                        Argument(
                            name: "ids",
                            type: .array,
                        ),
                    ],
                    since: 11
                ),
                Message(
                    name: "stacking_order_uuid_changed",
                    arguments: [
                        Argument(
                            name: "uuids",
                            type: .string,
                        ),
                    ],
                    since: 12
                ),
                Message(
                    name: "window_with_uuid",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .uint,
                        ),
                        Argument(
                            name: "uuid",
                            type: .string,
                        ),
                    ],
                    since: 13
                ),
                Message(
                    name: "stacking_order_changed_2",
                    arguments: [],
                    since: 17
                ),
            ]
        )
    /// Show/Hide The Desktop
    /// 
    /// Tell the compositor to show/hide the desktop.
    /// 
    /// - Parameters:
    ///   - state: requested state
    public func showDesktop(state: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(state),
        ])
    }

    /// Deprecated
    /// 
    /// Deprecated: use get_window_by_uuid
    /// 
    /// - Parameters:
    ///   - internalWindowId: The internal window id of the window to create
    public func getWindow(internalWindowId: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdePlasmaWindow {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdePlasmaWindow.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .uint(internalWindowId),
        ])
        return id
    }

    /// 
    /// - Parameters:
    ///   - internalWindowUuid: The internal window uuiid of the window to create
    public func getWindowByUuid(internalWindowUuid: String, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdePlasmaWindow {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 12 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 12) }
        let id = connection.createProxy(type: OrgKdePlasmaWindow.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(id.id),
            .string(internalWindowUuid),
        ])
        return id
    }

    /// Get The Stacking Order
    /// 
    /// 
    public func getStackingOrder(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdePlasmaStackingOrder {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 17 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 17) }
        let stackingOrder = connection.createProxy(type: OrgKdePlasmaStackingOrder.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 3, [
            .object(stackingOrder.id),
        ])
        return stackingOrder
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: PlasmaWindowManagementProtocol)
    }
    
    public enum State: UInt32 {
        case active = 1

        case minimized = 2

        case maximized = 4

        case fullscreen = 8

        case keepAbove = 16

        case keepBelow = 32

        case onAllDesktops = 64

        case demandsAttention = 128

        case closeable = 256

        case minimizable = 512

        case maximizable = 1024

        case fullscreenable = 2048

        case skiptaskbar = 4096

        case shadeable = 8192

        case shaded = 16384

        case movable = 32768

        case resizable = 65536

        case virtualDesktopChangeable = 131072

        case skipswitcher = 262144

        case noBorder = 524288

        case canSetNoBorder = 1048576

        case excludeFromCapture = 2097152
    }

    public enum ShowDesktop: UInt32 {
        case disabled = 0

        case enabled = 1
    }

    public enum Event: Decodable {
        /// Notify The Client When The Show Desktop Mode Is Entered/Left
        /// 
        /// This event will be sent whenever the show desktop mode changes. E.g. when it is entered
        /// or left.
        /// On binding the interface the current state is sent.
        case showDesktopChanged(state: UInt32)

        /// Notify The Client That A Window Was Mapped
        /// 
        /// This event will be sent immediately after a window is mapped.
        case window(id: UInt32)

        /// Notify The Client When Stacking Order Changed
        /// 
        /// This event will be sent when stacking order changed and on bind.
        /// With version 17 this event is deprecated and will no longer be sent.
        case stackingOrderChanged(ids: Data)

        /// Notify The Client When Stacking Order Changed
        /// 
        /// This event will be sent when stacking order changed and on bind.
        /// With version 17 this event is deprecated and will no longer be sent.
        case stackingOrderUuidChanged(uuids: String)

        /// Notify The Client That A Window Was Mapped
        /// 
        /// This event will be sent immediately after a window is mapped.
        case windowWithUuid(id: UInt32, uuid: String)

        /// Notify The Client When Stacking Order Changed
        /// 
        /// This event will be sent when stacking order changed.
        case stackingOrderChanged2

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.showDesktopChanged(state: r.uint())
            case 1:
                self = Self.window(id: r.uint())
            case 2:
                self = Self.stackingOrderChanged(ids: r.array())
            case 3:
                self = Self.stackingOrderUuidChanged(uuids: r.string())
            case 4:
                self = Self.windowWithUuid(id: r.uint(), uuid: r.string())
            case 5:
                self = Self.stackingOrderChanged2
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Interface To Control Application Windows
/// 
/// Manages and control an application window.
/// Only one client can bind this interface at a time.
public final class OrgKdePlasmaWindow: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_window",
            version: 20,
            requests: [
                Message(
                    name: "set_state",
                    arguments: [
                        Argument(
                            name: "flags",
                            type: .uint,
                        ),
                        Argument(
                            name: "state",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "set_virtual_desktop",
                    arguments: [
                        Argument(
                            name: "number",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "set_minimized_geometry",
                    arguments: [
                        Argument(
                            name: "panel",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "x",
                            type: .uint,
                        ),
                        Argument(
                            name: "y",
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
                    name: "unset_minimized_geometry",
                    arguments: [
                        Argument(
                            name: "panel",
                            type: .object,
                            interface: "wl_surface",
                        ),
                    ],
                ),
                Message(
                    name: "close",
                    arguments: [],
                ),
                Message(
                    name: "request_move",
                    arguments: [],
                    since: 3
                ),
                Message(
                    name: "request_resize",
                    arguments: [],
                    since: 3
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                    since: 4
                ),
                Message(
                    name: "get_icon",
                    arguments: [
                        Argument(
                            name: "fd",
                            type: .fd,
                        ),
                    ],
                    since: 7
                ),
                Message(
                    name: "request_enter_virtual_desktop",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        ),
                    ],
                    since: 8
                ),
                Message(
                    name: "request_enter_new_virtual_desktop",
                    arguments: [],
                    since: 8
                ),
                Message(
                    name: "request_leave_virtual_desktop",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        ),
                    ],
                    since: 8
                ),
                Message(
                    name: "request_enter_activity",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        ),
                    ],
                    since: 14
                ),
                Message(
                    name: "request_leave_activity",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        ),
                    ],
                    since: 14
                ),
                Message(
                    name: "send_to_output",
                    arguments: [
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        ),
                    ],
                    since: 15
                ),
            ],
            events: [
                Message(
                    name: "title_changed",
                    arguments: [
                        Argument(
                            name: "title",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "app_id_changed",
                    arguments: [
                        Argument(
                            name: "app_id",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "state_changed",
                    arguments: [
                        Argument(
                            name: "flags",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "virtual_desktop_changed",
                    arguments: [
                        Argument(
                            name: "number",
                            type: .int,
                        ),
                    ],
                ),
                Message(
                    name: "themed_icon_name_changed",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "unmapped",
                    arguments: [],
                ),
                Message(
                    name: "initial_state",
                    arguments: [],
                    since: 4
                ),
                Message(
                    name: "parent_window",
                    arguments: [
                        Argument(
                            name: "parent",
                            type: .object,
                            interface: "org_kde_plasma_window",
                            nullable: true,
                        ),
                    ],
                    since: 5
                ),
                Message(
                    name: "geometry",
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
                            type: .uint,
                        ),
                        Argument(
                            name: "height",
                            type: .uint,
                        ),
                    ],
                    since: 6
                ),
                Message(
                    name: "icon_changed",
                    arguments: [],
                    since: 7
                ),
                Message(
                    name: "pid_changed",
                    arguments: [
                        Argument(
                            name: "pid",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "virtual_desktop_entered",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        ),
                    ],
                    since: 8
                ),
                Message(
                    name: "virtual_desktop_left",
                    arguments: [
                        Argument(
                            name: "is",
                            type: .string,
                        ),
                    ],
                    since: 8
                ),
                Message(
                    name: "application_menu",
                    arguments: [
                        Argument(
                            name: "service_name",
                            type: .string,
                        ),
                        Argument(
                            name: "object_path",
                            type: .string,
                        ),
                    ],
                    since: 10
                ),
                Message(
                    name: "activity_entered",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        ),
                    ],
                    since: 14
                ),
                Message(
                    name: "activity_left",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        ),
                    ],
                    since: 14
                ),
                Message(
                    name: "resource_name_changed",
                    arguments: [
                        Argument(
                            name: "resource_name",
                            type: .string,
                        ),
                    ],
                    since: 16
                ),
                Message(
                    name: "client_geometry",
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
                            type: .uint,
                        ),
                        Argument(
                            name: "height",
                            type: .uint,
                        ),
                    ],
                    since: 18
                ),
            ]
        )
    /// Set Window State
    /// 
    /// Set window state.
    /// Values for state argument are described by org_kde_plasma_window_management.state
    /// and can be used together in a bitfield. The flags bitfield describes which flags are
    /// supposed to be set, the state bitfield the value for the set flags
    /// 
    /// - Parameters:
    ///   - flags: bitfield of set state flags
    ///   - state: bitfield of state flags
    public func setState(flags: UInt32, state: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(flags),
            .uint(state),
        ])
    }

    /// Map Window On A Virtual Desktop
    /// 
    /// Deprecated: use enter_virtual_desktop
    /// Maps the window to a different virtual desktop.
    /// To show the window on all virtual desktops, call the
    /// org_kde_plasma_window.set_state request and specify a on_all_desktops
    /// state in the bitfield.
    /// 
    /// - Parameters:
    ///   - number: zero based virtual desktop number
    public func setVirtualDesktop(number: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(number),
        ])
    }

    /// Set The Geometry For A Taskbar Entry
    /// 
    /// Sets the geometry of the taskbar entry for this window.
    /// The geometry is relative to a panel in particular.
    /// 
    /// - Parameters:
    public func setMinimizedGeometry(panel: WlSurface, x: UInt32, y: UInt32, width: UInt32, height: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(panel.id),
            .uint(x),
            .uint(y),
            .uint(width),
            .uint(height),
        ])
    }

    /// Set The Geometry For A Taskbar Entry
    /// 
    /// Remove the task geometry information for a particular panel.
    /// 
    /// - Parameters:
    public func unsetMinimizedGeometry(panel: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .object(panel.id),
        ])
    }

    /// Close Window
    /// 
    /// Close this window.
    public func close() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
        ])
    }

    /// Request Move
    /// 
    /// Request an interactive move for this window.
    public func requestMove() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 5, [
        ])
    }

    /// Request Resize
    /// 
    /// Request an interactive resize for this window.
    public func requestResize() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 6, [
        ])
    }

    /// Remove Resource For The Org_Kde_Plasma_Window
    /// 
    /// Removes the resource bound for this org_kde_plasma_window.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        self.markDead()
        connection.send(self, 7, [
        ])
    }

    /// Requests To Get The Window Icon
    /// 
    /// The compositor will write the window icon into the provided file descriptor.
    /// The data is a serialized QIcon with QDataStream.
    /// 
    /// - Parameters:
    ///   - fd: file descriptor for the icon
    public func getIcon(fd: FileHandle) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 7 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 7) }
        connection.send(self, 8, [
            .fd(fd),
        ])
    }

    /// Map Window On A Virtual Desktop
    /// 
    /// Make the window enter a virtual desktop. A window can enter more
    /// than one virtual desktop. if the id is empty or invalid, no action will be performed.
    /// 
    /// - Parameters:
    ///   - id: desktop id
    public func requestEnterVirtualDesktop(id: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 8 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 8) }
        connection.send(self, 9, [
            .string(id),
        ])
    }

    /// Map Window On A Virtual Desktop
    /// 
    /// RFC: do this with an empty id to request_enter_virtual_desktop?
    /// Make the window enter a new virtual desktop. If the server consents the request,
    /// it will create a new virtual desktop and assign the window to it.
    public func requestEnterNewVirtualDesktop() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 8 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 8) }
        connection.send(self, 10, [
        ])
    }

    /// Remove A Window From A Virtual Desktop
    /// 
    /// Make the window exit a virtual desktop. If it exits all desktops it will be considered on all of them.
    /// 
    /// - Parameters:
    ///   - id: desktop id
    public func requestLeaveVirtualDesktop(id: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 8 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 8) }
        connection.send(self, 11, [
            .string(id),
        ])
    }

    /// Map Window On An Activity
    /// 
    /// Make the window enter an activity. A window can enter more activity. If the id is empty or invalid, no action will be performed.
    /// 
    /// - Parameters:
    ///   - id: activity id
    public func requestEnterActivity(id: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 14 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 14) }
        connection.send(self, 12, [
            .string(id),
        ])
    }

    /// Remove A Window From An Activity
    /// 
    /// Make the window exit a an activity. If it exits all activities it will be considered on all of them.
    /// 
    /// - Parameters:
    ///   - id: activity id
    public func requestLeaveActivity(id: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 14 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 14) }
        connection.send(self, 13, [
            .string(id),
        ])
    }

    /// Send Window To Specified Output
    /// 
    /// Requests this window to be displayed in a specific output.
    /// 
    /// - Parameters:
    public func sendToOutput(output: WlOutput) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 15 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 15) }
        connection.send(self, 14, [
            .object(output.id),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: PlasmaWindowManagementProtocol)
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
        /// Window Title Has Been Changed
        /// 
        /// This event will be sent as soon as the window title is changed.
        case titleChanged(title: String)

        /// Application Identifier Has Been Changed
        /// 
        /// This event will be sent as soon as the application
        /// identifier is changed.
        case appIdChanged(appId: String)

        /// Window State Has Been Changed
        /// 
        /// This event will be sent as soon as the window state changes.
        /// Values for state argument are described by org_kde_plasma_window_management.state.
        case stateChanged(flags: UInt32)

        /// Window Was Moved To Another Workspace
        /// 
        /// DEPRECATED: use virtual_desktop_entered and virtual_desktop_left instead
        /// This event will be sent when a window is moved to another
        /// virtual desktop.
        /// It is not sent if it becomes visible on all virtual desktops though.
        case virtualDesktopChanged(number: Int32)

        /// Window's Icon Name Changed
        /// 
        /// This event will be sent whenever the themed icon name changes. May be null.
        case themedIconNameChanged(name: String)

        /// Window's Surface Was Unmapped
        /// 
        /// This event will be sent immediately after the window is closed
        /// and its surface is unmapped.
        case unmapped

        /// All Initial Known State Is Submitted
        /// 
        /// This event will be sent immediately after all initial state been sent to the client.
        /// If the Plasma window is already unmapped, the unmapped event will be sent before the
        /// initial_state event.
        case initialState

        /// The Parent Window Changed
        /// 
        /// This event will be sent whenever the parent window of this org_kde_plasma_window changes.
        /// The passed parent is another org_kde_plasma_window and this org_kde_plasma_window is a
        /// transient window to the parent window. If the parent argument is null, this
        /// org_kde_plasma_window does not have a parent window.
        case parentWindow(parent: OrgKdePlasmaWindow)

        /// The Geometry Of This Window In Absolute Coordinates
        /// 
        /// This event will be sent whenever the window geometry of this org_kde_plasma_window changes.
        /// The coordinates are in absolute coordinates of the windowing system.
        case geometry(x: Int32, y: Int32, width: UInt32, height: UInt32)

        /// The Icon Of The Window Changed
        /// 
        /// This event will be sent whenever the icon of the window changes, but there is no themed
        /// icon name. Common examples are Xwayland windows which have a pixmap based icon.
        /// The client can request the icon using get_icon.
        case iconChanged

        /// Process Id Of Application Owning The Window Has Changed
        /// 
        /// This event will be sent when the compositor has set the process id this window belongs to.
        /// This should be set once before the initial_state is sent.
        case pidChanged(pid: UInt32)

        /// The Window Entered A New Virtual Desktop
        /// 
        /// This event will be sent when the window has entered a new virtual desktop. The window can be on more than one desktop, or none: then is considered on all of them.
        case virtualDesktopEntered(id: String)

        /// The Window Left A Virtual Desktop
        /// 
        /// This event will be sent when the window left a virtual desktop. If the window leaves all desktops, it can be considered on all.
        /// If the window gets manually added on all desktops, the server has to send virtual_desktop_left for every previous desktop it was in for the window to be really considered on all desktops.
        case virtualDesktopLeft(`is`: String)

        /// Notify The Client That The Current Appmenu Changed
        /// 
        /// This event will be sent after the application menu
        /// for the window has changed.
        case applicationMenu(serviceName: String, objectPath: String)

        /// The Window Entered An Activity
        /// 
        /// This event will be sent when the window has entered an activity. The window can be on more than one activity, or none: then is considered on all of them.
        case activityEntered(id: String)

        /// The Window Left An Activity
        /// 
        /// This event will be sent when the window left an activity. If the window leaves all activities, it will be considered on all.
        /// If the window gets manually added on all activities, the server has to send activity_left for every previous activity it was in for the window to be really considered on all activities.
        case activityLeft(id: String)

        /// X11 Resource Name Has Changed
        /// 
        /// This event will be sent when the X11 resource name of the window has changed.
        /// This is only set for XWayland windows.
        case resourceNameChanged(resourceName: String)

        /// The Client Geometry (I.E. Without Decorations Etc) Of This Window In Absolute Coordinates
        /// 
        /// This event will be sent whenever the window geometry of this org_kde_plasma_window changes.
        /// The coordinates are in absolute coordinates of the windowing system.
        case clientGeometry(x: Int32, y: Int32, width: UInt32, height: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.titleChanged(title: r.string())
            case 1:
                self = Self.appIdChanged(appId: r.string())
            case 2:
                self = Self.stateChanged(flags: r.uint())
            case 3:
                self = Self.virtualDesktopChanged(number: r.int())
            case 4:
                self = Self.themedIconNameChanged(name: r.string())
            case 5:
                self = Self.unmapped
            case 6:
                self = Self.initialState
            case 7:
                self = Self.parentWindow(parent: r.object(type: OrgKdePlasmaWindow.self))
            case 8:
                self = Self.geometry(x: r.int(), y: r.int(), width: r.uint(), height: r.uint())
            case 9:
                self = Self.iconChanged
            case 10:
                self = Self.pidChanged(pid: r.uint())
            case 11:
                self = Self.virtualDesktopEntered(id: r.string())
            case 12:
                self = Self.virtualDesktopLeft(is: r.string())
            case 13:
                self = Self.applicationMenu(serviceName: r.string(), objectPath: r.string())
            case 14:
                self = Self.activityEntered(id: r.string())
            case 15:
                self = Self.activityLeft(id: r.string())
            case 16:
                self = Self.resourceNameChanged(resourceName: r.string())
            case 17:
                self = Self.clientGeometry(x: r.int(), y: r.int(), width: r.uint(), height: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Activation Feedback
/// 
/// The activation manager interface provides a way to get notified
/// when an application is about to be activated.
public final class OrgKdePlasmaActivationFeedback: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_activation_feedback",
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
                    name: "activation",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_plasma_activation",
                        ),
                    ],
                ),
            ]
        )
    /// Destroy The Activation Manager Object
    /// 
    /// Destroy the activation manager object. The activation objects introduced
    /// by this manager object will be unaffected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: PlasmaWindowManagementProtocol)
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
        /// Notify That An App Is Starting
        /// 
        /// Will be issued when an app is set to be activated. It offers
        /// an instance of org_kde_plasma_activation that will tell us the app_id
        /// and the extent of the activation.
        case activation(id: OrgKdePlasmaActivation)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.activation(id: r.newId(type: OrgKdePlasmaActivation.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public final class OrgKdePlasmaActivation: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_activation",
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
                    name: "app_id",
                    arguments: [
                        Argument(
                            name: "app_id",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "finished",
                    arguments: [],
                ),
            ]
        )
    /// Destroy The Org_Kde_Plasma_Activation Object
    /// 
    /// Notify the compositor that the org_kde_plasma_activation object will no
    /// longer be used.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: PlasmaWindowManagementProtocol)
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
        /// Offers The App_Id
        /// 
        /// 
        case appId(appId: String)

        /// Notifies About Activation Finished, Either By Activation Or Because It Got Invalidated
        /// 
        /// 
        case finished

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.appId(appId: r.string())
            case 1:
                self = Self.finished
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Helper Object For Sending The Stacking Order
/// 
/// When this object is created, the compositor sends a window event for
/// each window in the stacking order, and afterwards sends the done event
/// and destroys this object.
public final class OrgKdePlasmaStackingOrder: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_stacking_order",
            version: 17,
            events: [
                Message(
                    name: "window",
                    arguments: [
                        Argument(
                            name: "uuid",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "done",
                    type: .destructor,
                    arguments: [],
                ),
            ]
        )
    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: PlasmaWindowManagementProtocol)
    }
    
    public enum Event: Decodable {
        /// A Window In The Stacking Order List
        /// 
        /// 
        case window(uuid: String)

        /// Marks The End Of The List
        /// 
        /// 
        case done

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.window(uuid: r.string())
            case 1:
                self = Self.done
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let PlasmaWindowManagementProtocol = Protocol(
        name: "plasma_window_management",
        interfaces: [
            OrgKdePlasmaWindowManagement.interface,
OrgKdePlasmaWindow.interface,
OrgKdePlasmaActivationFeedback.interface,
OrgKdePlasmaActivation.interface,
OrgKdePlasmaStackingOrder.interface
        ]
    )

#endif