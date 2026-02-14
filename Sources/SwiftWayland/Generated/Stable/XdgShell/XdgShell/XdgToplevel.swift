import Foundation

/// Toplevel Surface
/// 
/// This interface defines an xdg_surface role which allows a surface to,
/// among other things, set window-like properties such as maximize,
/// fullscreen, and minimize, set application-specific metadata like title and
/// id, and well as trigger user interactive operations such as interactive
/// resize and move.
/// A xdg_toplevel by default is responsible for providing the full intended
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
public final class XdgToplevel: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_toplevel"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Xdg_Toplevel
    /// 
    /// This request destroys the role surface and unmaps the surface;
    /// see "Unmapping" behavior in interface section for details.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
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
    public func setParent(parent: XdgToplevel) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(parent)
        ])
        connection.send(message: message)
    }
    
    /// Set Surface Title
    /// 
    /// Set a short title for the surface.
    /// This string may be used to identify the surface in a task bar,
    /// window list, or other user interface elements provided by the
    /// compositor.
    /// The string must be encoded in UTF-8.
    public func setTitle(title: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.string(title)
        ])
        connection.send(message: message)
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
    public func setAppId(appId: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.string(appId)
        ])
        connection.send(message: message)
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
    ///   - Seat: the wl_seat of the user event
    ///   - Serial: the serial of the user event
    ///   - X: the x position to pop up the window menu at
    ///   - Y: the y position to pop up the window menu at
    public func showWindowMenu(seat: WlSeat, serial: UInt32, x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.object(seat),
            WaylandData.uint(serial),
            WaylandData.int(x),
            WaylandData.int(y)
        ])
        connection.send(message: message)
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
    ///   - Seat: the wl_seat of the user event
    ///   - Serial: the serial of the user event
    public func move(seat: WlSeat, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.object(seat),
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
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
    ///   - Seat: the wl_seat of the user event
    ///   - Serial: the serial of the user event
    ///   - Edges: which edge or corner is being dragged
    public func resize(seat: WlSeat, serial: UInt32, edges: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            WaylandData.object(seat),
            WaylandData.uint(serial),
            WaylandData.uint(edges)
        ])
        connection.send(message: message)
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
    /// strictly negative values for width or height will result in a
    /// invalid_size error.
    public func setMaxSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 7, contents: [
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
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
    /// strictly negative values for width and height will result in a
    /// invalid_size error.
    public func setMinSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
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
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 9, contents: [])
        connection.send(message: message)
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
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 10, contents: [])
        connection.send(message: message)
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
    /// with border fill covering the rest of the output. The content of the
    /// border fill is undefined, but should be assumed to be in some way that
    /// attempts to blend into the surrounding area (e.g. solid black).
    /// If the fullscreened surface is not opaque, the compositor must make
    /// sure that other screen content not part of the same surface tree (made
    /// up of subsurfaces, popups or similarly coupled surfaces) are not
    /// visible below the fullscreened surface.
    public func setFullscreen(output: WlOutput) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 11, contents: [
            WaylandData.object(output)
        ])
        connection.send(message: message)
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
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 12, contents: [])
        connection.send(message: message)
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
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 13, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Provided Value Is         Not A Valid Variant Of The Resize_Edge Enum
        case invalidResizeEdge = 0
        
        /// Invalid Parent Toplevel
        case invalidParent = 1
        
        /// Client Provided An Invalid Min Or Max Size
        case invalidSize = 2
    }
    
    /// Edge Values For Resizing
    /// 
    /// These values are used to indicate which edge of a surface
    /// is being dragged in a resize operation.
    public enum ResizeEdge: UInt32, WlEnum {
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
    
    /// Types Of State On The Surface
    /// 
    /// The different state values used on the surface. This is designed for
    /// state values like maximized, fullscreen. It is paired with the
    /// configure event to ensure that both the client and the compositor
    /// setting the state can be synchronized.
    /// States set in this way are double-buffered, see wl_surface.commit.
    public enum State: UInt32, WlEnum {
        /// The Surface Is Maximized
        case maximized = 1
        
        /// The Surface Is Fullscreen
        case fullscreen = 2
        
        /// The Surface Is Being Resized
        case resizing = 3
        
        /// The Surface Is Now Activated
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
    
    /// Available since version 5
    public enum WmCapabilities: UInt32, WlEnum {
        /// Show_Window_Menu Is Available
        case windowMenu = 1
        
        /// Set_Maximized And Unset_Maximized Are Available
        case maximize = 2
        
        /// Set_Fullscreen And Unset_Fullscreen Are Available
        case fullscreen = 3
        
        /// Set_Minimized Is Available
        case minimize = 4
    }
    
    public enum Event: WlEventEnum {
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
        /// 
        /// Available since version 4
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
        /// native endianness.
        /// 
        /// - Parameters:
        ///   - Capabilities: array of 32-bit capabilities
        /// 
        /// Available since version 5
        case wmCapabilities(capabilities: Data)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(width: r.readInt(), height: r.readInt(), states: r.readArray())
            case 1:
                return Self.close
            case 2:
                return Self.configureBounds(width: r.readInt(), height: r.readInt())
            case 3:
                return Self.wmCapabilities(capabilities: r.readArray())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
