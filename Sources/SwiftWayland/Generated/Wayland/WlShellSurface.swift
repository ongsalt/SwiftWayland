import Foundation

/// Desktop-Style Metadata Interface
/// 
/// An interface that may be implemented by a wl_surface, for
/// implementations that provide a desktop-style user interface.
/// It provides requests to treat surfaces like toplevel, fullscreen
/// or popup windows, move, resize or maximize them, associate
/// metadata like title and class, etc.
/// On the server side the object is automatically destroyed when
/// the related wl_surface is destroyed. On the client side,
/// wl_shell_surface_destroy() must be called before destroying
/// the wl_surface object.
public final class WlShellSurface: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_shell_surface"
    public var onEvent: (Event) -> Void = { _ in }

    /// Respond To A Ping Event
    /// 
    /// A client must respond to a ping event with a pong request or
    /// the client may be deemed unresponsive.
    /// 
    /// - Parameters:
    ///   - Serial: serial number of the ping event
    public func pong(serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    /// Start An Interactive Move
    /// 
    /// Start a pointer-driven move of the surface.
    /// This request must be used in response to a button press event.
    /// The server may ignore move requests depending on the state of
    /// the surface (e.g. fullscreen or maximized).
    /// 
    /// - Parameters:
    ///   - Seat: seat whose pointer is used
    ///   - Serial: serial number of the implicit grab on the pointer
    public func move(seat: WlSeat, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(seat),
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    /// Start An Interactive Resize
    /// 
    /// Start a pointer-driven resizing of the surface.
    /// This request must be used in response to a button press event.
    /// The server may ignore resize requests depending on the state of
    /// the surface (e.g. fullscreen or maximized).
    /// 
    /// - Parameters:
    ///   - Seat: seat whose pointer is used
    ///   - Serial: serial number of the implicit grab on the pointer
    ///   - Edges: which edge or corner is being dragged
    public func resize(seat: WlSeat, serial: UInt32, edges: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.object(seat),
            WaylandData.uint(serial),
            WaylandData.uint(edges)
        ])
        connection.send(message: message)
    }
    
    /// Make The Surface A Toplevel Surface
    /// 
    /// Map the surface as a toplevel surface.
    /// A toplevel surface is not fullscreen, maximized or transient.
    public func setToplevel() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [])
        connection.send(message: message)
    }
    
    /// Make The Surface A Transient Surface
    /// 
    /// Map the surface relative to an existing surface.
    /// The x and y arguments specify the location of the upper left
    /// corner of the surface relative to the upper left corner of the
    /// parent surface, in surface-local coordinates.
    /// The flags argument controls details of the transient behaviour.
    /// 
    /// - Parameters:
    ///   - Parent: parent surface
    ///   - X: surface-local x coordinate
    ///   - Y: surface-local y coordinate
    ///   - Flags: transient surface behavior
    public func setTransient(parent: WlSurface, x: Int32, y: Int32, flags: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.object(parent),
            WaylandData.int(x),
            WaylandData.int(y),
            WaylandData.uint(flags)
        ])
        connection.send(message: message)
    }
    
    /// Make The Surface A Fullscreen Surface
    /// 
    /// Map the surface as a fullscreen surface.
    /// If an output parameter is given then the surface will be made
    /// fullscreen on that output. If the client does not specify the
    /// output then the compositor will apply its policy - usually
    /// choosing the output on which the surface has the biggest surface
    /// area.
    /// The client may specify a method to resolve a size conflict
    /// between the output size and the surface size - this is provided
    /// through the method parameter.
    /// The framerate parameter is used only when the method is set
    /// to "driver", to indicate the preferred framerate. A value of 0
    /// indicates that the client does not care about framerate.  The
    /// framerate is specified in mHz, that is framerate of 60000 is 60Hz.
    /// A method of "scale" or "driver" implies a scaling operation of
    /// the surface, either via a direct scaling operation or a change of
    /// the output mode. This will override any kind of output scaling, so
    /// that mapping a surface with a buffer size equal to the mode can
    /// fill the screen independent of buffer_scale.
    /// A method of "fill" means we don't scale up the buffer, however
    /// any output scale is applied. This means that you may run into
    /// an edge case where the application maps a buffer with the same
    /// size of the output mode but buffer_scale 1 (thus making a
    /// surface larger than the output). In this case it is allowed to
    /// downscale the results to fit the screen.
    /// The compositor must reply to this request with a configure event
    /// with the dimensions for the output on which the surface will
    /// be made fullscreen.
    /// 
    /// - Parameters:
    ///   - Method: method for resolving size conflict
    ///   - Framerate: framerate in mHz
    ///   - Output: output on which the surface is to be fullscreen
    public func setFullscreen(method: UInt32, framerate: UInt32, output: WlOutput) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.uint(method),
            WaylandData.uint(framerate),
            WaylandData.object(output)
        ])
        connection.send(message: message)
    }
    
    /// Make The Surface A Popup Surface
    /// 
    /// Map the surface as a popup.
    /// A popup surface is a transient surface with an added pointer
    /// grab.
    /// An existing implicit grab will be changed to owner-events mode,
    /// and the popup grab will continue after the implicit grab ends
    /// (i.e. releasing the mouse button does not cause the popup to
    /// be unmapped).
    /// The popup grab continues until the window is destroyed or a
    /// mouse button is pressed in any other client's window. A click
    /// in any of the client's surfaces is reported as normal, however,
    /// clicks in other clients' surfaces will be discarded and trigger
    /// the callback.
    /// The x and y arguments specify the location of the upper left
    /// corner of the surface relative to the upper left corner of the
    /// parent surface, in surface-local coordinates.
    /// 
    /// - Parameters:
    ///   - Seat: seat whose pointer is used
    ///   - Serial: serial number of the implicit grab on the pointer
    ///   - Parent: parent surface
    ///   - X: surface-local x coordinate
    ///   - Y: surface-local y coordinate
    ///   - Flags: transient surface behavior
    public func setPopup(seat: WlSeat, serial: UInt32, parent: WlSurface, x: Int32, y: Int32, flags: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            WaylandData.object(seat),
            WaylandData.uint(serial),
            WaylandData.object(parent),
            WaylandData.int(x),
            WaylandData.int(y),
            WaylandData.uint(flags)
        ])
        connection.send(message: message)
    }
    
    /// Make The Surface A Maximized Surface
    /// 
    /// Map the surface as a maximized surface.
    /// If an output parameter is given then the surface will be
    /// maximized on that output. If the client does not specify the
    /// output then the compositor will apply its policy - usually
    /// choosing the output on which the surface has the biggest surface
    /// area.
    /// The compositor will reply with a configure event telling
    /// the expected new surface size. The operation is completed
    /// on the next buffer attach to this surface.
    /// A maximized surface typically fills the entire output it is
    /// bound to, except for desktop elements such as panels. This is
    /// the main difference between a maximized shell surface and a
    /// fullscreen shell surface.
    /// The details depend on the compositor implementation.
    /// 
    /// - Parameters:
    ///   - Output: output on which the surface is to be maximized
    public func setMaximized(output: WlOutput) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 7, contents: [
            WaylandData.object(output)
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
    /// 
    /// - Parameters:
    ///   - Title: surface title
    public func setTitle(title: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            WaylandData.string(title)
        ])
        connection.send(message: message)
    }
    
    /// Set Surface Class
    /// 
    /// Set a class for the surface.
    /// The surface class identifies the general class of applications
    /// to which the surface belongs. A common convention is to use the
    /// file name (or the full path if it is a non-standard location) of
    /// the application's .desktop file as the class.
    /// 
    /// - Parameters:
    ///   - Class: surface class
    public func setClass(`class`: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 9, contents: [
            WaylandData.string(`class`)
        ])
        connection.send(message: message)
    }
    
    /// Edge Values For Resizing
    /// 
    /// These values are used to indicate which edge of a surface
    /// is being dragged in a resize operation. The server may
    /// use this information to adapt its behavior, e.g. choose
    /// an appropriate cursor image.
    public enum Resize: UInt32, WlEnum {
        /// No Edge
        case `none` = 0
        
        /// Top Edge
        case top = 1
        
        /// Bottom Edge
        case bottom = 2
        
        /// Left Edge
        case `left` = 4
        
        /// Top And Left Edges
        case topLeft = 5
        
        /// Bottom And Left Edges
        case bottomLeft = 6
        
        /// Right Edge
        case `right` = 8
        
        /// Top And Right Edges
        case topRight = 9
        
        /// Bottom And Right Edges
        case bottomRight = 10
    }
    
    /// Details Of Transient Behaviour
    /// 
    /// These flags specify details of the expected behaviour
    /// of transient surfaces. Used in the set_transient request.
    public enum Transient: UInt32, WlEnum {
        /// Do Not Set Keyboard Focus
        case inactive = 0x1
    }
    
    /// Different Method To Set The Surface Fullscreen
    /// 
    /// Hints to indicate to the compositor how to deal with a conflict
    /// between the dimensions of the surface and the dimensions of the
    /// output. The compositor is free to ignore this parameter.
    public enum FullscreenMethod: UInt32, WlEnum {
        /// No Preference, Apply Default Policy
        case `default` = 0
        
        /// Scale, Preserve The Surface's Aspect Ratio And Center On Output
        case scale = 1
        
        /// Switch Output Mode To The Smallest Mode That Can Fit The Surface, Add Black Borders To Compensate Size Mismatch
        case driver = 2
        
        /// No Upscaling, Center On Output And Add Black Borders To Compensate Size Mismatch
        case fill = 3
    }
    
    public enum Event: WlEventEnum {
        /// Ping Client
        /// 
        /// Ping a client to check if it is receiving events and sending
        /// requests. A client is expected to reply with a pong request.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the ping
        case ping(serial: UInt32)
        
        /// Suggest Resize
        /// 
        /// The configure event asks the client to resize its surface.
        /// The size is a hint, in the sense that the client is free to
        /// ignore it if it doesn't resize, pick a smaller size (to
        /// satisfy aspect ratio or resize in steps of NxM pixels).
        /// The edges parameter provides a hint about how the surface
        /// was resized. The client may use this information to decide
        /// how to adjust its content to the new size (e.g. a scrolling
        /// area might adjust its content position to leave the viewable
        /// content unmoved).
        /// The client is free to dismiss all but the last configure
        /// event it received.
        /// The width and height arguments specify the size of the window
        /// in surface-local coordinates.
        /// 
        /// - Parameters:
        ///   - Edges: how the surface was resized
        ///   - Width: new width of the surface
        ///   - Height: new height of the surface
        case configure(edges: UInt32, width: Int32, height: Int32)
        
        /// Popup Interaction Is Done
        /// 
        /// The popup_done event is sent out when a popup grab is broken,
        /// that is, when the user clicks a surface that doesn't belong
        /// to the client owning the popup surface.
        case popupDone
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.ping(serial: r.readUInt())
            case 1:
                return Self.configure(edges: r.readUInt(), width: r.readInt(), height: r.readInt())
            case 2:
                return Self.popupDone
            default:
                fatalError("Unknown message")
            }
        }
    }
}
