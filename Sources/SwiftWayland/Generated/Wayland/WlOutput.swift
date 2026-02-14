import Foundation

/// Compositor Output Region
/// 
/// An output describes part of the compositor geometry.  The
/// compositor works in the 'compositor coordinate system' and an
/// output corresponds to a rectangular area in that space that is
/// actually visible.  This typically corresponds to a monitor that
/// displays part of the compositor space.  This object is published
/// as global during start up, or when a monitor is hotplugged.
public final class WlOutput: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_output"
    public var onEvent: (Event) -> Void = { _ in }

    /// Release The Output Object
    /// 
    /// Using this request a client can tell the server that it is not going to
    /// use the output object anymore.
    /// 
    /// Available since version 3
    public consuming func release() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.release()
    }
    
    /// Subpixel Geometry Information
    /// 
    /// This enumeration describes how the physical
    /// pixels on an output are laid out.
    public enum Subpixel: UInt32, WlEnum {
        /// Unknown Geometry
        case unknown = 0
        
        /// No Geometry
        case `none` = 1
        
        /// Horizontal Rgb
        case horizontalRgb = 2
        
        /// Horizontal Bgr
        case horizontalBgr = 3
        
        /// Vertical Rgb
        case verticalRgb = 4
        
        /// Vertical Bgr
        case verticalBgr = 5
    }
    
    /// Transformation Applied To Buffer Contents
    /// 
    /// This describes transformations that clients and compositors apply to
    /// buffer contents.
    /// The flipped values correspond to an initial flip around a
    /// vertical axis followed by rotation.
    /// The purpose is mainly to allow clients to render accordingly and
    /// tell the compositor, so that for fullscreen surfaces, the
    /// compositor will still be able to scan out directly from client
    /// surfaces.
    public enum Transform: UInt32, WlEnum {
        /// No Transform
        case normal = 0
        
        /// 90 Degrees Counter-Clockwise
        case `90` = 1
        
        /// 180 Degrees Counter-Clockwise
        case `180` = 2
        
        /// 270 Degrees Counter-Clockwise
        case `270` = 3
        
        /// 180 Degree Flip Around A Vertical Axis
        case flipped = 4
        
        /// Flip And Rotate 90 Degrees Counter-Clockwise
        case flipped90 = 5
        
        /// Flip And Rotate 180 Degrees Counter-Clockwise
        case flipped180 = 6
        
        /// Flip And Rotate 270 Degrees Counter-Clockwise
        case flipped270 = 7
    }
    
    /// Mode Information
    /// 
    /// These flags describe properties of an output mode.
    /// They are used in the flags bitfield of the mode event.
    public enum Mode: UInt32, WlEnum {
        /// Indicates This Is The Current Mode
        case current = 0x1
        
        /// Indicates This Is The Preferred Mode
        case preferred = 0x2
    }
    
    public enum Event: WlEventEnum {
        /// Properties Of The Output
        /// 
        /// The geometry event describes geometric properties of the output.
        /// The event is sent when binding to the output object and whenever
        /// any of the properties change.
        /// The physical size can be set to zero if it doesn't make sense for this
        /// output (e.g. for projectors or virtual outputs).
        /// The geometry event will be followed by a done event (starting from
        /// version 2).
        /// Clients should use wl_surface.preferred_buffer_transform instead of the
        /// transform advertised by this event to find the preferred buffer
        /// transform to use for a surface.
        /// Note: wl_output only advertises partial information about the output
        /// position and identification. Some compositors, for instance those not
        /// implementing a desktop-style output layout or those exposing virtual
        /// outputs, might fake this information. Instead of using x and y, clients
        /// should use xdg_output.logical_position. Instead of using make and model,
        /// clients should use name and description.
        /// 
        /// - Parameters:
        ///   - X: x position within the global compositor space
        ///   - Y: y position within the global compositor space
        ///   - PhysicalWidth: width in millimeters of the output
        ///   - PhysicalHeight: height in millimeters of the output
        ///   - Subpixel: subpixel orientation of the output
        ///   - Make: textual description of the manufacturer
        ///   - Model: textual description of the model
        ///   - Transform: additional transformation applied to buffer contents during presentation
        case geometry(x: Int32, y: Int32, physicalWidth: Int32, physicalHeight: Int32, subpixel: Int32, make: String, model: String, transform: Int32)
        
        /// Advertise Available Modes For The Output
        /// 
        /// The mode event describes an available mode for the output.
        /// The event is sent when binding to the output object and there
        /// will always be one mode, the current mode.  The event is sent
        /// again if an output changes mode, for the mode that is now
        /// current.  In other words, the current mode is always the last
        /// mode that was received with the current flag set.
        /// Non-current modes are deprecated. A compositor can decide to only
        /// advertise the current mode and never send other modes. Clients
        /// should not rely on non-current modes.
        /// The size of a mode is given in physical hardware units of
        /// the output device. This is not necessarily the same as
        /// the output size in the global compositor space. For instance,
        /// the output may be scaled, as described in wl_output.scale,
        /// or transformed, as described in wl_output.transform. Clients
        /// willing to retrieve the output size in the global compositor
        /// space should use xdg_output.logical_size instead.
        /// The vertical refresh rate can be set to zero if it doesn't make
        /// sense for this output (e.g. for virtual outputs).
        /// The mode event will be followed by a done event (starting from
        /// version 2).
        /// Clients should not use the refresh rate to schedule frames. Instead,
        /// they should use the wl_surface.frame event or the presentation-time
        /// protocol.
        /// Note: this information is not always meaningful for all outputs. Some
        /// compositors, such as those exposing virtual outputs, might fake the
        /// refresh rate or the size.
        /// 
        /// - Parameters:
        ///   - Flags: bitfield of mode flags
        ///   - Width: width of the mode in hardware units
        ///   - Height: height of the mode in hardware units
        ///   - Refresh: vertical refresh rate in mHz
        case mode(flags: UInt32, width: Int32, height: Int32, refresh: Int32)
        
        /// Sent All Information About Output
        /// 
        /// This event is sent after all other properties have been
        /// sent after binding to the output object and after any
        /// other property changes done after that. This allows
        /// changes to the output properties to be seen as
        /// atomic, even if they happen via multiple events.
        /// 
        /// Available since version 2
        case done
        
        /// Output Scaling Properties
        /// 
        /// This event contains scaling geometry information
        /// that is not in the geometry event. It may be sent after
        /// binding the output object or if the output scale changes
        /// later. The compositor will emit a non-zero, positive
        /// value for scale. If it is not sent, the client should
        /// assume a scale of 1.
        /// A scale larger than 1 means that the compositor will
        /// automatically scale surface buffers by this amount
        /// when rendering. This is used for very high resolution
        /// displays where applications rendering at the native
        /// resolution would be too small to be legible.
        /// Clients should use wl_surface.preferred_buffer_scale
        /// instead of this event to find the preferred buffer
        /// scale to use for a surface.
        /// The scale event will be followed by a done event.
        /// 
        /// - Parameters:
        ///   - Factor: scaling factor of output
        /// 
        /// Available since version 2
        case scale(factor: Int32)
        
        /// Name Of This Output
        /// 
        /// Many compositors will assign user-friendly names to their outputs, show
        /// them to the user, allow the user to refer to an output, etc. The client
        /// may wish to know this name as well to offer the user similar behaviors.
        /// The name is a UTF-8 string with no convention defined for its contents.
        /// Each name is unique among all wl_output globals. The name is only
        /// guaranteed to be unique for the compositor instance.
        /// The same output name is used for all clients for a given wl_output
        /// global. Thus, the name can be shared across processes to refer to a
        /// specific wl_output global.
        /// The name is not guaranteed to be persistent across sessions, thus cannot
        /// be used to reliably identify an output in e.g. configuration files.
        /// Examples of names include 'HDMI-A-1', 'WL-1', 'X11-1', etc. However, do
        /// not assume that the name is a reflection of an underlying DRM connector,
        /// X11 connection, etc.
        /// The name event is sent after binding the output object. This event is
        /// only sent once per output object, and the name does not change over the
        /// lifetime of the wl_output global.
        /// Compositors may re-use the same output name if the wl_output global is
        /// destroyed and re-created later. Compositors should avoid re-using the
        /// same name if possible.
        /// The name event will be followed by a done event.
        /// 
        /// - Parameters:
        ///   - Name: output name
        /// 
        /// Available since version 4
        case name(name: String)
        
        /// Human-Readable Description Of This Output
        /// 
        /// Many compositors can produce human-readable descriptions of their
        /// outputs. The client may wish to know this description as well, e.g. for
        /// output selection purposes.
        /// The description is a UTF-8 string with no convention defined for its
        /// contents. The description is not guaranteed to be unique among all
        /// wl_output globals. Examples might include 'Foocorp 11" Display' or
        /// 'Virtual X11 output via :1'.
        /// The description event is sent after binding the output object and
        /// whenever the description changes. The description is optional, and may
        /// not be sent at all.
        /// The description event will be followed by a done event.
        /// 
        /// - Parameters:
        ///   - Description: output description
        /// 
        /// Available since version 4
        case description(description: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.geometry(x: r.readInt(), y: r.readInt(), physicalWidth: r.readInt(), physicalHeight: r.readInt(), subpixel: r.readInt(), make: r.readString(), model: r.readString(), transform: r.readInt())
            case 1:
                return Self.mode(flags: r.readUInt(), width: r.readInt(), height: r.readInt(), refresh: r.readInt())
            case 2:
                return Self.done
            case 3:
                return Self.scale(factor: r.readInt())
            case 4:
                return Self.name(name: r.readString())
            case 5:
                return Self.description(description: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
