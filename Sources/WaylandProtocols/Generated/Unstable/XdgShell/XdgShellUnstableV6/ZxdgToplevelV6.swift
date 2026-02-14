import Foundation
import SwiftWayland

/// Toplevel Surface
/// 
/// This interface defines an xdg_surface role which allows a surface to,
/// among other things, set window-like properties such as maximize,
/// fullscreen, and minimize, set application-specific metadata like title and
/// id, and well as trigger user interactive operations such as interactive
/// resize and move.
public final class ZxdgToplevelV6: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_toplevel_v6"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Xdg_Toplevel
    /// 
    /// Unmap and destroy the window. The window will be effectively
    /// hidden from the user's point of view, and all state like
    /// maximization, fullscreen, and so on, will be lost.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set The Parent Of This Surface
    /// 
    /// Set the "parent" of this surface. This window should be stacked
    /// above a parent. The parent surface must be mapped as long as this
    /// surface is mapped.
    /// Parent windows should be set on dialogs, toolboxes, or other
    /// "auxiliary" surfaces, so that the parent is raised when the dialog
    /// is raised.
    public func setParent(parent: ZxdgToplevelV6) throws(WaylandProxyError) {
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
    /// See the desktop-entry specification [0] for more details on
    /// application identifiers and how they relate to well-known D-Bus
    /// names and .desktop files.
    /// [0] http://standards.freedesktop.org/desktop-entry-spec/
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
    /// the window menu contains.
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
    /// The edges parameter specifies how the surface should be resized,
    /// and is one of the values of the resize_edge enum. The compositor
    /// may use this information to update the surface position for
    /// example when dragging the top left corner. The compositor may also
    /// use this information to adapt its behavior, e.g. choose an
    /// appropriate cursor image.
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
    /// a surface is illegal and will result in a protocol error.
    /// The width and height must be greater than or equal to zero. Using
    /// strictly negative values for width and height will result in the
    /// zxdg_shell_v6.invalid_surface_state error being raised.
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
    /// a surface is illegal and will result in a protocol error.
    /// The width and height must be greater than or equal to zero. Using
    /// strictly negative values for width and height will result in the
    /// zxdg_shell_v6.invalid_surface_state error being raised.
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
    /// will respond by emitting a configure event with the "maximized" state
    /// and the required window geometry. The client should then update its
    /// content, drawing it in a maximized state, i.e. without shadow or other
    /// decoration outside of the window geometry. The client must also
    /// acknowledge the configure when committing the new content (see
    /// ack_configure).
    /// It is up to the compositor to decide how and where to maximize the
    /// surface, for example which output and what region of the screen should
    /// be used.
    /// If the surface was already maximized, the compositor will still emit
    /// a configure event with the "maximized" state.
    /// Note that unrelated compositor side state changes may cause
    /// configure events to be emitted at any time, meaning trying to
    /// match this request to a specific future configure event is
    /// futile.
    public func setMaximized() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 9, contents: [])
        connection.send(message: message)
    }
    
    /// Unmaximize The Window
    /// 
    /// Unmaximize the surface.
    /// After requesting that the surface should be unmaximized, the compositor
    /// will respond by emitting a configure event without the "maximized"
    /// state. If available, the compositor will include the window geometry
    /// dimensions the window had prior to being maximized in the configure
    /// request. The client must then update its content, drawing it in a
    /// regular state, i.e. potentially with shadow, etc. The client must also
    /// acknowledge the configure when committing the new content (see
    /// ack_configure).
    /// It is up to the compositor to position the surface after it was
    /// unmaximized; usually the position the surface had before maximizing, if
    /// applicable.
    /// If the surface was already not maximized, the compositor will still
    /// emit a configure event without the "maximized" state.
    /// Note that unrelated changes in the state of compositor may cause
    /// configure events to be emitted by the compositor between processing
    /// this request and emitting corresponding configure event, so trying
    /// to match the request with the event is futile.
    public func unsetMaximized() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 10, contents: [])
        connection.send(message: message)
    }
    
    /// Set The Window As Fullscreen On A Monitor
    /// 
    /// Make the surface fullscreen.
    /// You can specify an output that you would prefer to be fullscreen.
    /// If this value is NULL, it's up to the compositor to choose which
    /// display will be used to map this surface.
    /// If the surface doesn't cover the whole output, the compositor will
    /// position the surface in the center of the output and compensate with
    /// black borders filling the rest of the output.
    public func setFullscreen(output: WlOutput) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 11, contents: [
            WaylandData.object(output)
        ])
        connection.send(message: message)
    }
    
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
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(width: r.readInt(), height: r.readInt(), states: r.readArray())
            case 1:
                return Self.close
            default:
                fatalError("Unknown message")
            }
        }
    }
}
