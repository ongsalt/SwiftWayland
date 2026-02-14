import Foundation
import SwiftWayland

/// A Physical Tablet Tool
/// 
/// An object that represents a physical tool that has been, or is
/// currently in use with a tablet in this seat. Each wp_tablet_tool
/// object stays valid until the client destroys it; the compositor
/// reuses the wp_tablet_tool object to indicate that the object's
/// respective physical tool has come into proximity of a tablet again.
/// A wp_tablet_tool object's relation to a physical tool depends on the
/// tablet's ability to report serial numbers. If the tablet supports
/// this capability, then the object represents a specific physical tool
/// and can be identified even when used on multiple tablets.
/// A tablet tool has a number of static characteristics, e.g. tool type,
/// hardware_serial and capabilities. These capabilities are sent in an
/// event sequence after the wp_tablet_seat.tool_added event before any
/// actual events from this tool. This initial event sequence is
/// terminated by a wp_tablet_tool.done event.
/// Tablet tool events are grouped by wp_tablet_tool.frame events.
/// Any events received before a wp_tablet_tool.frame event should be
/// considered part of the same hardware state change.
public final class ZwpTabletToolV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_tool_v2"
    public var onEvent: (Event) -> Void = { _ in }

    /// Set The Tablet Tool's Surface
    /// 
    /// Sets the surface of the cursor used for this tool on the given
    /// tablet. This request only takes effect if the tool is in proximity
    /// of one of the requesting client's surfaces or the surface parameter
    /// is the current pointer surface. If there was a previous surface set
    /// with this request it is replaced. If surface is NULL, the cursor
    /// image is hidden.
    /// The parameters hotspot_x and hotspot_y define the position of the
    /// pointer surface relative to the pointer location. Its top-left corner
    /// is always at (x, y) - (hotspot_x, hotspot_y), where (x, y) are the
    /// coordinates of the pointer location, in surface-local coordinates.
    /// On surface.attach requests to the pointer surface, hotspot_x and
    /// hotspot_y are decremented by the x and y parameters passed to the
    /// request. Attach must be confirmed by wl_surface.commit as usual.
    /// The hotspot can also be updated by passing the currently set pointer
    /// surface to this request with new values for hotspot_x and hotspot_y.
    /// The current and pending input regions of the wl_surface are cleared,
    /// and wl_surface.set_input_region is ignored until the wl_surface is no
    /// longer used as the cursor. When the use as a cursor ends, the current
    /// and pending input regions become undefined, and the wl_surface is
    /// unmapped.
    /// This request gives the surface the role of a wp_tablet_tool cursor. A
    /// surface may only ever be used as the cursor surface for one
    /// wp_tablet_tool. If the surface already has another role or has
    /// previously been used as cursor surface for a different tool, a
    /// protocol error is raised.
    /// 
    /// - Parameters:
    ///   - Serial: serial of the proximity_in event
    ///   - HotspotX: surface-local x coordinate
    ///   - HotspotY: surface-local y coordinate
    public func setCursor(serial: UInt32, surface: WlSurface, hotspotX: Int32, hotspotY: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.uint(serial),
            WaylandData.object(surface),
            WaylandData.int(hotspotX),
            WaylandData.int(hotspotY)
        ])
        connection.send(message: message)
    }
    
    /// Destroy The Tool Object
    /// 
    /// This destroys the client's resource for this tool object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// A Physical Tool Type
    /// 
    /// Describes the physical type of a tool. The physical type of a tool
    /// generally defines its base usage.
    /// The mouse tool represents a mouse-shaped tool that is not a relative
    /// device but bound to the tablet's surface, providing absolute
    /// coordinates.
    /// The lens tool is a mouse-shaped tool with an attached lens to
    /// provide precision focus.
    public enum `Type`: UInt32, WlEnum {
        /// Pen
        case pen = 0x140
        
        /// Eraser
        case eraser = 0x141
        
        /// Brush
        case brush = 0x142
        
        /// Pencil
        case pencil = 0x143
        
        /// Airbrush
        case airbrush = 0x144
        
        /// Finger
        case finger = 0x145
        
        /// Mouse
        case mouse = 0x146
        
        /// Lens
        case lens = 0x147
    }
    
    /// Capability Flags For A Tool
    /// 
    /// Describes extra capabilities on a tablet.
    /// Any tool must provide x and y values, extra axes are
    /// device-specific.
    public enum Capability: UInt32, WlEnum {
        /// Tilt Axes
        case tilt = 1
        
        /// Pressure Axis
        case pressure = 2
        
        /// Distance Axis
        case distance = 3
        
        /// Z-Rotation Axis
        case rotation = 4
        
        /// Slider Axis
        case slider = 5
        
        /// Wheel Axis
        case wheel = 6
    }
    
    /// Physical Button State
    /// 
    /// Describes the physical state of a button that produced the button event.
    public enum ButtonState: UInt32, WlEnum {
        /// Button Is Not Pressed
        case released = 0
        
        /// Button Is Pressed
        case pressed = 1
    }
    
    public enum Error: UInt32, WlEnum {
        /// Given Wl_Surface Has Another Role
        case role = 0
    }
    
    public enum Event: WlEventEnum {
        /// Tool Type
        /// 
        /// The tool type is the high-level type of the tool and usually decides
        /// the interaction expected from this tool.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_tool.done event.
        /// 
        /// - Parameters:
        ///   - ToolType: the physical tool type
        case type(toolType: UInt32)
        
        /// Unique Hardware Serial Number Of The Tool
        /// 
        /// If the physical tool can be identified by a unique 64-bit serial
        /// number, this event notifies the client of this serial number.
        /// If multiple tablets are available in the same seat and the tool is
        /// uniquely identifiable by the serial number, that tool may move
        /// between tablets.
        /// Otherwise, if the tool has no serial number and this event is
        /// missing, the tool is tied to the tablet it first comes into
        /// proximity with. Even if the physical tool is used on multiple
        /// tablets, separate wp_tablet_tool objects will be created, one per
        /// tablet.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_tool.done event.
        /// 
        /// - Parameters:
        ///   - HardwareSerialHi: the unique serial number of the tool, most significant bits
        ///   - HardwareSerialLo: the unique serial number of the tool, least significant bits
        case hardwareSerial(hardwareSerialHi: UInt32, hardwareSerialLo: UInt32)
        
        /// Hardware Id Notification In Wacom's Format
        /// 
        /// This event notifies the client of a hardware id available on this tool.
        /// The hardware id is a device-specific 64-bit id that provides extra
        /// information about the tool in use, beyond the wl_tool.type
        /// enumeration. The format of the id is specific to tablets made by
        /// Wacom Inc. For example, the hardware id of a Wacom Grip
        /// Pen (a stylus) is 0x802.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_tool.done event.
        /// 
        /// - Parameters:
        ///   - HardwareIdHi: the hardware id, most significant bits
        ///   - HardwareIdLo: the hardware id, least significant bits
        case hardwareIdWacom(hardwareIdHi: UInt32, hardwareIdLo: UInt32)
        
        /// Tool Capability Notification
        /// 
        /// This event notifies the client of any capabilities of this tool,
        /// beyond the main set of x/y axes and tip up/down detection.
        /// One event is sent for each extra capability available on this tool.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_tool.done event.
        /// 
        /// - Parameters:
        ///   - Capability: the capability
        case capability(capability: UInt32)
        
        /// Tool Description Events Sequence Complete
        /// 
        /// This event signals the end of the initial burst of descriptive
        /// events. A client may consider the static description of the tool to
        /// be complete and finalize initialization of the tool.
        case done
        
        /// Tool Removed
        /// 
        /// This event is sent when the tool is removed from the system and will
        /// send no further events. Should the physical tool come back into
        /// proximity later, a new wp_tablet_tool object will be created.
        /// It is compositor-dependent when a tool is removed. A compositor may
        /// remove a tool on proximity out, tablet removal or any other reason.
        /// A compositor may also keep a tool alive until shutdown.
        /// If the tool is currently in proximity, a proximity_out event will be
        /// sent before the removed event. See wp_tablet_tool.proximity_out for
        /// the handling of any buttons logically down.
        /// When this event is received, the client must wp_tablet_tool.destroy
        /// the object.
        case removed
        
        /// Proximity In Event
        /// 
        /// Notification that this tool is focused on a certain surface.
        /// This event can be received when the tool has moved from one surface to
        /// another, or when the tool has come back into proximity above the
        /// surface.
        /// If any button is logically down when the tool comes into proximity,
        /// the respective button event is sent after the proximity_in event but
        /// within the same frame as the proximity_in event.
        /// 
        /// - Parameters:
        ///   - Tablet: The tablet the tool is in proximity of
        ///   - Surface: The current surface the tablet tool is over
        case proximityIn(serial: UInt32, tablet: ZwpTabletV2, surface: WlSurface)
        
        /// Proximity Out Event
        /// 
        /// Notification that this tool has either left proximity, or is no
        /// longer focused on a certain surface.
        /// When the tablet tool leaves proximity of the tablet, button release
        /// events are sent for each button that was held down at the time of
        /// leaving proximity. These events are sent before the proximity_out
        /// event but within the same wp_tablet.frame.
        /// If the tool stays within proximity of the tablet, but the focus
        /// changes from one surface to another, a button release event may not
        /// be sent until the button is actually released or the tool leaves the
        /// proximity of the tablet.
        case proximityOut
        
        /// Tablet Tool Is Making Contact
        /// 
        /// Sent whenever the tablet tool comes in contact with the surface of the
        /// tablet.
        /// If the tool is already in contact with the tablet when entering the
        /// input region, the client owning said region will receive a
        /// wp_tablet.proximity_in event, followed by a wp_tablet.down
        /// event and a wp_tablet.frame event.
        /// Note that this event describes logical contact, not physical
        /// contact. On some devices, a compositor may not consider a tool in
        /// logical contact until a minimum physical pressure threshold is
        /// exceeded.
        case down(serial: UInt32)
        
        /// Tablet Tool Is No Longer Making Contact
        /// 
        /// Sent whenever the tablet tool stops making contact with the surface of
        /// the tablet, or when the tablet tool moves out of the input region
        /// and the compositor grab (if any) is dismissed.
        /// If the tablet tool moves out of the input region while in contact
        /// with the surface of the tablet and the compositor does not have an
        /// ongoing grab on the surface, the client owning said region will
        /// receive a wp_tablet.up event, followed by a wp_tablet.proximity_out
        /// event and a wp_tablet.frame event. If the compositor has an ongoing
        /// grab on this device, this event sequence is sent whenever the grab
        /// is dismissed in the future.
        /// Note that this event describes logical contact, not physical
        /// contact. On some devices, a compositor may not consider a tool out
        /// of logical contact until physical pressure falls below a specific
        /// threshold.
        case up
        
        /// Motion Event
        /// 
        /// Sent whenever a tablet tool moves.
        /// 
        /// - Parameters:
        ///   - X: surface-local x coordinate
        ///   - Y: surface-local y coordinate
        case motion(x: Double, y: Double)
        
        /// Pressure Change Event
        /// 
        /// Sent whenever the pressure axis on a tool changes. The value of this
        /// event is normalized to a value between 0 and 65535.
        /// Note that pressure may be nonzero even when a tool is not in logical
        /// contact. See the down and up events for more details.
        /// 
        /// - Parameters:
        ///   - Pressure: The current pressure value
        case pressure(pressure: UInt32)
        
        /// Distance Change Event
        /// 
        /// Sent whenever the distance axis on a tool changes. The value of this
        /// event is normalized to a value between 0 and 65535.
        /// Note that distance may be nonzero even when a tool is not in logical
        /// contact. See the down and up events for more details.
        /// 
        /// - Parameters:
        ///   - Distance: The current distance value
        case distance(distance: UInt32)
        
        /// Tilt Change Event
        /// 
        /// Sent whenever one or both of the tilt axes on a tool change. Each tilt
        /// value is in degrees, relative to the z-axis of the tablet.
        /// The angle is positive when the top of a tool tilts along the
        /// positive x or y axis.
        /// 
        /// - Parameters:
        ///   - TiltX: The current value of the X tilt axis
        ///   - TiltY: The current value of the Y tilt axis
        case tilt(tiltX: Double, tiltY: Double)
        
        /// Z-Rotation Change Event
        /// 
        /// Sent whenever the z-rotation axis on the tool changes. The
        /// rotation value is in degrees clockwise from the tool's
        /// logical neutral position.
        /// 
        /// - Parameters:
        ///   - Degrees: The current rotation of the Z axis
        case rotation(degrees: Double)
        
        /// Slider Position Change Event
        /// 
        /// Sent whenever the slider position on the tool changes. The
        /// value is normalized between -65535 and 65535, with 0 as the logical
        /// neutral position of the slider.
        /// The slider is available on e.g. the Wacom Airbrush tool.
        /// 
        /// - Parameters:
        ///   - Position: The current position of slider
        case slider(position: Int32)
        
        /// Wheel Delta Event
        /// 
        /// Sent whenever the wheel on the tool emits an event. This event
        /// contains two values for the same axis change. The degrees value is
        /// in the same orientation as the wl_pointer.vertical_scroll axis. The
        /// clicks value is in discrete logical clicks of the mouse wheel. This
        /// value may be zero if the movement of the wheel was less
        /// than one logical click.
        /// Clients should choose either value and avoid mixing degrees and
        /// clicks. The compositor may accumulate values smaller than a logical
        /// click and emulate click events when a certain threshold is met.
        /// Thus, wl_tablet_tool.wheel events with non-zero clicks values may
        /// have different degrees values.
        /// 
        /// - Parameters:
        ///   - Degrees: The wheel delta in degrees
        ///   - Clicks: The wheel delta in discrete clicks
        case wheel(degrees: Double, clicks: Int32)
        
        /// Button Event
        /// 
        /// Sent whenever a button on the tool is pressed or released.
        /// If a button is held down when the tool moves in or out of proximity,
        /// button events are generated by the compositor. See
        /// wp_tablet_tool.proximity_in and wp_tablet_tool.proximity_out for
        /// details.
        /// 
        /// - Parameters:
        ///   - Button: The button whose state has changed
        ///   - State: Whether the button was pressed or released
        case button(serial: UInt32, button: UInt32, state: UInt32)
        
        /// Frame Event
        /// 
        /// Marks the end of a series of axis and/or button updates from the
        /// tablet. The Wayland protocol requires axis updates to be sent
        /// sequentially, however all events within a frame should be considered
        /// one hardware event.
        /// 
        /// - Parameters:
        ///   - Time: The time of the event with millisecond granularity
        case frame(time: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.type(toolType: r.readUInt())
            case 1:
                return Self.hardwareSerial(hardwareSerialHi: r.readUInt(), hardwareSerialLo: r.readUInt())
            case 2:
                return Self.hardwareIdWacom(hardwareIdHi: r.readUInt(), hardwareIdLo: r.readUInt())
            case 3:
                return Self.capability(capability: r.readUInt())
            case 4:
                return Self.done
            case 5:
                return Self.removed
            case 6:
                return Self.proximityIn(serial: r.readUInt(), tablet: connection.get(as: ZwpTabletV2.self, id: r.readObjectId())!, surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 7:
                return Self.proximityOut
            case 8:
                return Self.down(serial: r.readUInt())
            case 9:
                return Self.up
            case 10:
                return Self.motion(x: r.readFixed(), y: r.readFixed())
            case 11:
                return Self.pressure(pressure: r.readUInt())
            case 12:
                return Self.distance(distance: r.readUInt())
            case 13:
                return Self.tilt(tiltX: r.readFixed(), tiltY: r.readFixed())
            case 14:
                return Self.rotation(degrees: r.readFixed())
            case 15:
                return Self.slider(position: r.readInt())
            case 16:
                return Self.wheel(degrees: r.readFixed(), clicks: r.readInt())
            case 17:
                return Self.button(serial: r.readUInt(), button: r.readUInt(), state: r.readUInt())
            case 18:
                return Self.frame(time: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
