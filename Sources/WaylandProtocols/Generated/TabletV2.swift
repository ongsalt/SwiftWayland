import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

/// Controller Object For Graphic Tablet Devices
/// 
/// An object that provides access to the graphics tablets available on this
/// system. All tablets are associated with a seat, to get access to the
/// actual tablets, use zwp_tablet_manager_v2.get_tablet_seat.
public final class ZwpTabletManagerV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_manager_v2",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "get_tablet_seat",
                    arguments: [
                    Argument(
                        name: "tablet_seat",
                        type: .newId,
                        interface: "zwp_tablet_seat_v2"
                    ),
                    Argument(
                        name: "seat",
                        type: .object,
                        interface: "wl_seat"
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Get The Tablet Seat
    /// 
    /// Get the zwp_tablet_seat_v2 object for the given seat. This object
    /// provides access to all graphics tablets in this seat.
    /// 
    /// - Parameters:
    ///   - seat: The wl_seat object to retrieve the tablets for
    ///   - queue: queue to associated with created objects
    public func getTabletSeat(seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpTabletSeatV2 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let tabletSeat = connection.createProxy(type: ZwpTabletSeatV2.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(tabletSeat.id),
            .object(seat.id),
        ])
        return tabletSeat
    }

    /// Release The Memory For The Tablet Manager Object
    /// 
    /// Destroy the zwp_tablet_manager_v2 object. Objects created from this
    /// object are unaffected and should be destroyed separately.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletV2)
    }
    public typealias Event = NoEvent
}
/// Controller Object For Graphic Tablet Devices Of A Seat
/// 
/// An object that provides access to the graphics tablets available on this
/// seat. After binding to this interface, the compositor sends a set of
/// zwp_tablet_seat_v2.tablet_added and zwp_tablet_seat_v2.tool_added events.
public final class ZwpTabletSeatV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_seat_v2",
            version: 2,
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
                    name: "tablet_added",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_tablet_v2"
                    ),
                    ],
                ),
                Message(
                    name: "tool_added",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_tablet_tool_v2"
                    ),
                    ],
                ),
                Message(
                    name: "pad_added",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_tablet_pad_v2"
                    ),
                    ],
                ),
                ],
        )
    /// Release The Memory For The Tablet Seat Object
    /// 
    /// Destroy the zwp_tablet_seat_v2 object. Objects created from this
    /// object are unaffected and should be destroyed separately.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletV2)
    }
    public enum Event: Decodable {
        /// New Device Notification
        /// 
        /// This event is sent whenever a new tablet becomes available on this
        /// seat. This event only provides the object id of the tablet, any
        /// static information about the tablet (device name, vid/pid, etc.) is
        /// sent through the zwp_tablet_v2 interface.
        case tabletAdded(id: ZwpTabletV2)

        /// A New Tool Has Been Used With A Tablet
        /// 
        /// This event is sent whenever a tool that has not previously been used
        /// with a tablet comes into use. This event only provides the object id
        /// of the tool; any static information about the tool (capabilities,
        /// type, etc.) is sent through the zwp_tablet_tool_v2 interface.
        case toolAdded(id: ZwpTabletToolV2)

        /// New Pad Notification
        /// 
        /// This event is sent whenever a new pad is known to the system. Typically,
        /// pads are physically attached to tablets and a pad_added event is
        /// sent immediately after the zwp_tablet_seat_v2.tablet_added.
        /// However, some standalone pad devices logically attach to tablets at
        /// runtime, and the client must wait for zwp_tablet_pad_v2.enter to know
        /// the tablet a pad is attached to.
        /// This event only provides the object id of the pad. All further
        /// features (buttons, strips, rings) are sent through the zwp_tablet_pad_v2
        /// interface.
        case padAdded(id: ZwpTabletPadV2)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.tabletAdded(id: r.newId(type: ZwpTabletV2.self))
            case 1:
                self = Self.toolAdded(id: r.newId(type: ZwpTabletToolV2.self))
            case 2:
                self = Self.padAdded(id: r.newId(type: ZwpTabletPadV2.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// A Physical Tablet Tool
/// 
/// An object that represents a physical tool that has been, or is
/// currently in use with a tablet in this seat. Each zwp_tablet_tool_v2
/// object stays valid until the client destroys it; the compositor
/// reuses the zwp_tablet_tool_v2 object to indicate that the object's
/// respective physical tool has come into proximity of a tablet again.
/// A zwp_tablet_tool_v2 object's relation to a physical tool depends on the
/// tablet's ability to report serial numbers. If the tablet supports
/// this capability, then the object represents a specific physical tool
/// and can be identified even when used on multiple tablets.
/// A tablet tool has a number of static characteristics, e.g. tool type,
/// hardware_serial and capabilities. These capabilities are sent in an
/// event sequence after the zwp_tablet_seat_v2.tool_added event before any
/// actual events from this tool. This initial event sequence is
/// terminated by a zwp_tablet_tool_v2.done event.
/// Tablet tool events are grouped by zwp_tablet_tool_v2.frame events.
/// Any events received before a zwp_tablet_tool_v2.frame event should be
/// considered part of the same hardware state change.
public final class ZwpTabletToolV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_tool_v2",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "set_cursor",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    Argument(
                        name: "hotspot_x",
                        type: .int,
                    ),
                    Argument(
                        name: "hotspot_y",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "type",
                    arguments: [
                    Argument(
                        name: "tool_type",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "hardware_serial",
                    arguments: [
                    Argument(
                        name: "hardware_serial_hi",
                        type: .uint,
                    ),
                    Argument(
                        name: "hardware_serial_lo",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "hardware_id_wacom",
                    arguments: [
                    Argument(
                        name: "hardware_id_hi",
                        type: .uint,
                    ),
                    Argument(
                        name: "hardware_id_lo",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "capability",
                    arguments: [
                    Argument(
                        name: "capability",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [
                    ],
                ),
                Message(
                    name: "removed",
                    arguments: [
                    ],
                ),
                Message(
                    name: "proximity_in",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "tablet",
                        type: .object,
                        interface: "zwp_tablet_v2"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "proximity_out",
                    arguments: [
                    ],
                ),
                Message(
                    name: "down",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "up",
                    arguments: [
                    ],
                ),
                Message(
                    name: "motion",
                    arguments: [
                    Argument(
                        name: "x",
                        type: .fixed,
                    ),
                    Argument(
                        name: "y",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "pressure",
                    arguments: [
                    Argument(
                        name: "pressure",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "distance",
                    arguments: [
                    Argument(
                        name: "distance",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "tilt",
                    arguments: [
                    Argument(
                        name: "tilt_x",
                        type: .fixed,
                    ),
                    Argument(
                        name: "tilt_y",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "rotation",
                    arguments: [
                    Argument(
                        name: "degrees",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "slider",
                    arguments: [
                    Argument(
                        name: "position",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "wheel",
                    arguments: [
                    Argument(
                        name: "degrees",
                        type: .fixed,
                    ),
                    Argument(
                        name: "clicks",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "button",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "button",
                        type: .uint,
                    ),
                    Argument(
                        name: "state",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "frame",
                    arguments: [
                    Argument(
                        name: "time",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
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
    /// This request gives the surface the role of a zwp_tablet_tool_v2 cursor. A
    /// surface may only ever be used as the cursor surface for one
    /// zwp_tablet_tool_v2. If the surface already has another role or has
    /// previously been used as cursor surface for a different tool, a
    /// protocol error is raised.
    /// 
    /// - Parameters:
    ///   - serial: serial of the proximity_in event
    ///   - hotspotX: surface-local x coordinate
    ///   - hotspotY: surface-local y coordinate
    public func setCursor(serial: UInt32, surface: WlSurface, hotspotX: Int32, hotspotY: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(serial),
            .object(surface.id),
            .int(hotspotX),
            .int(hotspotY),
        ])
    }

    /// Destroy The Tool Object
    /// 
    /// This destroys the client's resource for this tool object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletV2)
    }
    public enum `Type`: UInt32 {
        /// Pen
        case pen = 320

        /// Eraser
        case eraser = 321

        /// Brush
        case brush = 322

        /// Pencil
        case pencil = 323

        /// Airbrush
        case airbrush = 324

        /// Finger
        case finger = 325

        /// Mouse
        case mouse = 326

        /// Lens
        case lens = 327
    }

    public enum Capability: UInt32 {
        /// Tilt axes
        case tilt = 1

        /// Pressure axis
        case pressure = 2

        /// Distance axis
        case distance = 3

        /// Z-rotation axis
        case rotation = 4

        /// Slider axis
        case slider = 5

        /// Wheel axis
        case wheel = 6
    }

    public enum ButtonState: UInt32 {
        /// button is not pressed
        case released = 0

        /// button is pressed
        case pressed = 1
    }

    public enum Error: UInt32 {
        /// given wl_surface has another role
        case role = 0
    }

    public enum Event: Decodable {
        /// Tool Type
        /// 
        /// The tool type is the high-level type of the tool and usually decides
        /// the interaction expected from this tool.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_tool_v2.done event.
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
        /// tablets, separate zwp_tablet_tool_v2 objects will be created, one per
        /// tablet.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_tool_v2.done event.
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
        /// zwp_tablet_tool_v2.done event.
        case hardwareIdWacom(hardwareIdHi: UInt32, hardwareIdLo: UInt32)

        /// Tool Capability Notification
        /// 
        /// This event notifies the client of any capabilities of this tool,
        /// beyond the main set of x/y axes and tip up/down detection.
        /// One event is sent for each extra capability available on this tool.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_tool_v2.done event.
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
        /// proximity later, a new zwp_tablet_tool_v2 object will be created.
        /// It is compositor-dependent when a tool is removed. A compositor may
        /// remove a tool on proximity out, tablet removal or any other reason.
        /// A compositor may also keep a tool alive until shutdown.
        /// If the tool is currently in proximity, a proximity_out event will be
        /// sent before the removed event. See zwp_tablet_tool_v2.proximity_out for
        /// the handling of any buttons logically down.
        /// When this event is received, the client must zwp_tablet_tool_v2.destroy
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
        case proximityIn(serial: UInt32, tablet: ZwpTabletV2, surface: WlSurface)

        /// Proximity Out Event
        /// 
        /// Notification that this tool has either left proximity, or is no
        /// longer focused on a certain surface.
        /// When the tablet tool leaves proximity of the tablet, button release
        /// events are sent for each button that was held down at the time of
        /// leaving proximity. These events are sent before the proximity_out
        /// event but within the same zwp_tablet_v2.frame.
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
        /// zwp_tablet_v2.proximity_in event, followed by a zwp_tablet_v2.down
        /// event and a zwp_tablet_v2.frame event.
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
        /// receive a zwp_tablet_v2.up event, followed by a zwp_tablet_v2.proximity_out
        /// event and a zwp_tablet_v2.frame event. If the compositor has an ongoing
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
        case motion(x: Double, y: Double)

        /// Pressure Change Event
        /// 
        /// Sent whenever the pressure axis on a tool changes. The value of this
        /// event is normalized to a value between 0 and 65535.
        /// Note that pressure may be nonzero even when a tool is not in logical
        /// contact. See the down and up events for more details.
        case pressure(pressure: UInt32)

        /// Distance Change Event
        /// 
        /// Sent whenever the distance axis on a tool changes. The value of this
        /// event is normalized to a value between 0 and 65535.
        /// Note that distance may be nonzero even when a tool is not in logical
        /// contact. See the down and up events for more details.
        case distance(distance: UInt32)

        /// Tilt Change Event
        /// 
        /// Sent whenever one or both of the tilt axes on a tool change. Each tilt
        /// value is in degrees, relative to the z-axis of the tablet.
        /// The angle is positive when the top of a tool tilts along the
        /// positive x or y axis.
        case tilt(tiltX: Double, tiltY: Double)

        /// Z-Rotation Change Event
        /// 
        /// Sent whenever the z-rotation axis on the tool changes. The
        /// rotation value is in degrees clockwise from the tool's
        /// logical neutral position.
        case rotation(degrees: Double)

        /// Slider Position Change Event
        /// 
        /// Sent whenever the slider position on the tool changes. The
        /// value is normalized between -65535 and 65535, with 0 as the logical
        /// neutral position of the slider.
        /// The slider is available on e.g. the Wacom Airbrush tool.
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
        /// Thus, zwp_tablet_tool_v2.wheel events with non-zero clicks values may
        /// have different degrees values.
        case wheel(degrees: Double, clicks: Int32)

        /// Button Event
        /// 
        /// Sent whenever a button on the tool is pressed or released.
        /// If a button is held down when the tool moves in or out of proximity,
        /// button events are generated by the compositor. See
        /// zwp_tablet_tool_v2.proximity_in and zwp_tablet_tool_v2.proximity_out for
        /// details.
        case button(serial: UInt32, button: UInt32, state: UInt32)

        /// Frame Event
        /// 
        /// Marks the end of a series of axis and/or button updates from the
        /// tablet. The Wayland protocol requires axis updates to be sent
        /// sequentially, however all events within a frame should be considered
        /// one hardware event.
        case frame(time: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.type(toolType: r.uint())
            case 1:
                self = Self.hardwareSerial(hardwareSerialHi: r.uint(), hardwareSerialLo: r.uint())
            case 2:
                self = Self.hardwareIdWacom(hardwareIdHi: r.uint(), hardwareIdLo: r.uint())
            case 3:
                self = Self.capability(capability: r.uint())
            case 4:
                self = Self.done
            case 5:
                self = Self.removed
            case 6:
                self = Self.proximityIn(serial: r.uint(), tablet: r.object(type: ZwpTabletV2.self), surface: r.object(type: WlSurface.self))
            case 7:
                self = Self.proximityOut
            case 8:
                self = Self.down(serial: r.uint())
            case 9:
                self = Self.up
            case 10:
                self = Self.motion(x: r.fixed(), y: r.fixed())
            case 11:
                self = Self.pressure(pressure: r.uint())
            case 12:
                self = Self.distance(distance: r.uint())
            case 13:
                self = Self.tilt(tiltX: r.fixed(), tiltY: r.fixed())
            case 14:
                self = Self.rotation(degrees: r.fixed())
            case 15:
                self = Self.slider(position: r.int())
            case 16:
                self = Self.wheel(degrees: r.fixed(), clicks: r.int())
            case 17:
                self = Self.button(serial: r.uint(), button: r.uint(), state: r.uint())
            case 18:
                self = Self.frame(time: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Graphics Tablet Device
/// 
/// The zwp_tablet_v2 interface represents one graphics tablet device. The
/// tablet interface itself does not generate events; all events are
/// generated by zwp_tablet_tool_v2 objects when in proximity above a tablet.
/// A tablet has a number of static characteristics, e.g. device name and
/// pid/vid. These capabilities are sent in an event sequence after the
/// zwp_tablet_seat_v2.tablet_added event. This initial event sequence is
/// terminated by a zwp_tablet_v2.done event.
public final class ZwpTabletV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_v2",
            version: 2,
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
                    name: "name",
                    arguments: [
                    Argument(
                        name: "name",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "id",
                    arguments: [
                    Argument(
                        name: "vid",
                        type: .uint,
                    ),
                    Argument(
                        name: "pid",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "path",
                    arguments: [
                    Argument(
                        name: "path",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [
                    ],
                ),
                Message(
                    name: "removed",
                    arguments: [
                    ],
                ),
                Message(
                    name: "bustype",
                    arguments: [
                    Argument(
                        name: "bustype",
                        type: .uint,
                    ),
                    ],
                    since: 2
                ),
                ],
        )
    /// Destroy The Tablet Object
    /// 
    /// This destroys the client's resource for this tablet object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletV2)
    }
    public enum Bustype: UInt32 {
        /// USB
        case usb = 3

        /// Bluetooth
        case bluetooth = 5

        /// Virtual
        case virtual = 6

        /// Serial
        case serial = 23

        /// I2C
        case i2c = 36
    }

    public enum Event: Decodable {
        /// Tablet Device Name
        /// 
        /// A descriptive name for the tablet device.
        /// If the device has no descriptive name, this event is not sent.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_v2.done event.
        case name(name: String)

        /// Tablet Device Vendor/Product Id
        /// 
        /// The vendor and product IDs for the tablet device.
        /// The interpretation of the id depends on the zwp_tablet_v2.bustype.
        /// Prior to version v2 of this protocol, the id was implied to be a USB
        /// vendor and product ID. If no zwp_tablet_v2.bustype is sent, the ID
        /// is to be interpreted as USB vendor and product ID.
        /// If the device has no vendor/product ID, this event is not sent.
        /// This can happen for virtual devices or non-USB devices, for instance.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_v2.done event.
        case id(vid: UInt32, pid: UInt32)

        /// Path To The Device
        /// 
        /// A system-specific device path that indicates which device is behind
        /// this zwp_tablet_v2. This information may be used to gather additional
        /// information about the device, e.g. through libwacom.
        /// A device may have more than one device path. If so, multiple
        /// zwp_tablet_v2.path events are sent. A device may be emulated and not
        /// have a device path, and in that case this event will not be sent.
        /// The format of the path is unspecified, it may be a device node, a
        /// sysfs path, or some other identifier. It is up to the client to
        /// identify the string provided.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_v2.done event.
        case path(path: String)

        /// Tablet Description Events Sequence Complete
        /// 
        /// This event is sent immediately to signal the end of the initial
        /// burst of descriptive events. A client may consider the static
        /// description of the tablet to be complete and finalize initialization
        /// of the tablet.
        case done

        /// Tablet Removed Event
        /// 
        /// Sent when the tablet has been removed from the system. When a tablet
        /// is removed, some tools may be removed.
        /// When this event is received, the client must zwp_tablet_v2.destroy
        /// the object.
        case removed

        /// Tablet Device Bus Type
        /// 
        /// The bustype argument is one of the BUS_ defines in the Linux kernel's
        /// linux/input.h
        /// If the device has no known bustype or the bustype cannot be
        /// queried, this event is not sent.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_v2.done event.
        case bustype(bustype: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.name(name: r.string())
            case 1:
                self = Self.id(vid: r.uint(), pid: r.uint())
            case 2:
                self = Self.path(path: r.string())
            case 3:
                self = Self.done
            case 4:
                self = Self.removed
            case 5:
                self = Self.bustype(bustype: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Pad Ring
/// 
/// A circular interaction area, such as the touch ring on the Wacom Intuos
/// Pro series tablets.
/// Events on a ring are logically grouped by the zwp_tablet_pad_ring_v2.frame
/// event.
public final class ZwpTabletPadRingV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_pad_ring_v2",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "set_feedback",
                    arguments: [
                    Argument(
                        name: "description",
                        type: .string,
                    ),
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "source",
                    arguments: [
                    Argument(
                        name: "source",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "angle",
                    arguments: [
                    Argument(
                        name: "degrees",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "stop",
                    arguments: [
                    ],
                ),
                Message(
                    name: "frame",
                    arguments: [
                    Argument(
                        name: "time",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
    /// Set Compositor Feedback
    /// 
    /// Request that the compositor use the provided feedback string
    /// associated with this ring. This request should be issued immediately
    /// after a zwp_tablet_pad_group_v2.mode_switch event from the corresponding
    /// group is received, or whenever the ring is mapped to a different
    /// action. See zwp_tablet_pad_group_v2.mode_switch for more details.
    /// Clients are encouraged to provide context-aware descriptions for
    /// the actions associated with the ring; compositors may use this
    /// information to offer visual feedback about the button layout
    /// (eg. on-screen displays).
    /// The provided string 'description' is a UTF-8 encoded string to be
    /// associated with this ring, and is considered user-visible; general
    /// internationalization rules apply.
    /// The serial argument will be that of the last
    /// zwp_tablet_pad_group_v2.mode_switch event received for the group of this
    /// ring. Requests providing other serials than the most recent one will be
    /// ignored.
    /// 
    /// - Parameters:
    ///   - description: ring description
    ///   - serial: serial of the mode switch event
    public func setFeedback(description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(description),
            .uint(serial),
        ])
    }

    /// Destroy The Ring Object
    /// 
    /// This destroys the client's resource for this ring object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletV2)
    }
    public enum Source: UInt32 {
        /// finger
        case finger = 1
    }

    public enum Event: Decodable {
        /// Ring Event Source
        /// 
        /// Source information for ring events.
        /// This event does not occur on its own. It is sent before a
        /// zwp_tablet_pad_ring_v2.frame event and carries the source information
        /// for all events within that frame.
        /// The source specifies how this event was generated. If the source is
        /// zwp_tablet_pad_ring_v2.source.finger, a zwp_tablet_pad_ring_v2.stop event
        /// will be sent when the user lifts the finger off the device.
        /// This event is optional. If the source is unknown for an interaction,
        /// no event is sent.
        case source(source: UInt32)

        /// Angle Changed
        /// 
        /// Sent whenever the angle on a ring changes.
        /// The angle is provided in degrees clockwise from the logical
        /// north of the ring in the pad's current rotation.
        case angle(degrees: Double)

        /// Interaction Stopped
        /// 
        /// Stop notification for ring events.
        /// For some zwp_tablet_pad_ring_v2.source types, a zwp_tablet_pad_ring_v2.stop
        /// event is sent to notify a client that the interaction with the ring
        /// has terminated. This enables the client to implement kinetic scrolling.
        /// See the zwp_tablet_pad_ring_v2.source documentation for information on
        /// when this event may be generated.
        /// Any zwp_tablet_pad_ring_v2.angle events with the same source after this
        /// event should be considered as the start of a new interaction.
        case stop

        /// End Of A Ring Event Sequence
        /// 
        /// Indicates the end of a set of ring events that logically belong
        /// together. A client is expected to accumulate the data in all events
        /// within the frame before proceeding.
        /// All zwp_tablet_pad_ring_v2 events before a zwp_tablet_pad_ring_v2.frame event belong
        /// logically together. For example, on termination of a finger interaction
        /// on a ring the compositor will send a zwp_tablet_pad_ring_v2.source event,
        /// a zwp_tablet_pad_ring_v2.stop event and a zwp_tablet_pad_ring_v2.frame event.
        /// A zwp_tablet_pad_ring_v2.frame event is sent for every logical event
        /// group, even if the group only contains a single zwp_tablet_pad_ring_v2
        /// event. Specifically, a client may get a sequence: angle, frame,
        /// angle, frame, etc.
        case frame(time: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.source(source: r.uint())
            case 1:
                self = Self.angle(degrees: r.fixed())
            case 2:
                self = Self.stop
            case 3:
                self = Self.frame(time: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Pad Strip
/// 
/// A linear interaction area, such as the strips found in Wacom Cintiq
/// models.
/// Events on a strip are logically grouped by the zwp_tablet_pad_strip_v2.frame
/// event.
public final class ZwpTabletPadStripV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_pad_strip_v2",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "set_feedback",
                    arguments: [
                    Argument(
                        name: "description",
                        type: .string,
                    ),
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "source",
                    arguments: [
                    Argument(
                        name: "source",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "position",
                    arguments: [
                    Argument(
                        name: "position",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "stop",
                    arguments: [
                    ],
                ),
                Message(
                    name: "frame",
                    arguments: [
                    Argument(
                        name: "time",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
    /// Set Compositor Feedback
    /// 
    /// Requests the compositor to use the provided feedback string
    /// associated with this strip. This request should be issued immediately
    /// after a zwp_tablet_pad_group_v2.mode_switch event from the corresponding
    /// group is received, or whenever the strip is mapped to a different
    /// action. See zwp_tablet_pad_group_v2.mode_switch for more details.
    /// Clients are encouraged to provide context-aware descriptions for
    /// the actions associated with the strip, and compositors may use this
    /// information to offer visual feedback about the button layout
    /// (eg. on-screen displays).
    /// The provided string 'description' is a UTF-8 encoded string to be
    /// associated with this ring, and is considered user-visible; general
    /// internationalization rules apply.
    /// The serial argument will be that of the last
    /// zwp_tablet_pad_group_v2.mode_switch event received for the group of this
    /// strip. Requests providing other serials than the most recent one will be
    /// ignored.
    /// 
    /// - Parameters:
    ///   - description: strip description
    ///   - serial: serial of the mode switch event
    public func setFeedback(description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(description),
            .uint(serial),
        ])
    }

    /// Destroy The Strip Object
    /// 
    /// This destroys the client's resource for this strip object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletV2)
    }
    public enum Source: UInt32 {
        /// finger
        case finger = 1
    }

    public enum Event: Decodable {
        /// Strip Event Source
        /// 
        /// Source information for strip events.
        /// This event does not occur on its own. It is sent before a
        /// zwp_tablet_pad_strip_v2.frame event and carries the source information
        /// for all events within that frame.
        /// The source specifies how this event was generated. If the source is
        /// zwp_tablet_pad_strip_v2.source.finger, a zwp_tablet_pad_strip_v2.stop event
        /// will be sent when the user lifts their finger off the device.
        /// This event is optional. If the source is unknown for an interaction,
        /// no event is sent.
        case source(source: UInt32)

        /// Position Changed
        /// 
        /// Sent whenever the position on a strip changes.
        /// The position is normalized to a range of [0, 65535], the 0-value
        /// represents the top-most and/or left-most position of the strip in
        /// the pad's current rotation.
        case position(position: UInt32)

        /// Interaction Stopped
        /// 
        /// Stop notification for strip events.
        /// For some zwp_tablet_pad_strip_v2.source types, a zwp_tablet_pad_strip_v2.stop
        /// event is sent to notify a client that the interaction with the strip
        /// has terminated. This enables the client to implement kinetic
        /// scrolling. See the zwp_tablet_pad_strip_v2.source documentation for
        /// information on when this event may be generated.
        /// Any zwp_tablet_pad_strip_v2.position events with the same source after this
        /// event should be considered as the start of a new interaction.
        case stop

        /// End Of A Strip Event Sequence
        /// 
        /// Indicates the end of a set of events that represent one logical
        /// hardware strip event. A client is expected to accumulate the data
        /// in all events within the frame before proceeding.
        /// All zwp_tablet_pad_strip_v2 events before a zwp_tablet_pad_strip_v2.frame event belong
        /// logically together. For example, on termination of a finger interaction
        /// on a strip the compositor will send a zwp_tablet_pad_strip_v2.source event,
        /// a zwp_tablet_pad_strip_v2.stop event and a zwp_tablet_pad_strip_v2.frame
        /// event.
        /// A zwp_tablet_pad_strip_v2.frame event is sent for every logical event
        /// group, even if the group only contains a single zwp_tablet_pad_strip_v2
        /// event. Specifically, a client may get a sequence: position, frame,
        /// position, frame, etc.
        case frame(time: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.source(source: r.uint())
            case 1:
                self = Self.position(position: r.uint())
            case 2:
                self = Self.stop
            case 3:
                self = Self.frame(time: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// A Set Of Buttons, Rings And Strips
/// 
/// A pad group describes a distinct (sub)set of buttons, rings and strips
/// present in the tablet. The criteria of this grouping is usually positional,
/// eg. if a tablet has buttons on the left and right side, 2 groups will be
/// presented. The physical arrangement of groups is undisclosed and may
/// change on the fly.
/// Pad groups will announce their features during pad initialization. Between
/// the corresponding zwp_tablet_pad_v2.group event and zwp_tablet_pad_group_v2.done, the
/// pad group will announce the buttons, rings and strips contained in it,
/// plus the number of supported modes.
/// Modes are a mechanism to allow multiple groups of actions for every element
/// in the pad group. The number of groups and available modes in each is
/// persistent across device plugs. The current mode is user-switchable, it
/// will be announced through the zwp_tablet_pad_group_v2.mode_switch event both
/// whenever it is switched, and after zwp_tablet_pad_v2.enter.
/// The current mode logically applies to all elements in the pad group,
/// although it is at clients' discretion whether to actually perform different
/// actions, and/or issue the respective .set_feedback requests to notify the
/// compositor. See the zwp_tablet_pad_group_v2.mode_switch event for more details.
public final class ZwpTabletPadGroupV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_pad_group_v2",
            version: 2,
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
                    name: "buttons",
                    arguments: [
                    Argument(
                        name: "buttons",
                        type: .array,
                    ),
                    ],
                ),
                Message(
                    name: "ring",
                    arguments: [
                    Argument(
                        name: "ring",
                        type: .newId,
                        interface: "zwp_tablet_pad_ring_v2"
                    ),
                    ],
                ),
                Message(
                    name: "strip",
                    arguments: [
                    Argument(
                        name: "strip",
                        type: .newId,
                        interface: "zwp_tablet_pad_strip_v2"
                    ),
                    ],
                ),
                Message(
                    name: "modes",
                    arguments: [
                    Argument(
                        name: "modes",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [
                    ],
                ),
                Message(
                    name: "mode_switch",
                    arguments: [
                    Argument(
                        name: "time",
                        type: .uint,
                    ),
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "mode",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "dial",
                    arguments: [
                    Argument(
                        name: "dial",
                        type: .newId,
                        interface: "zwp_tablet_pad_dial_v2"
                    ),
                    ],
                    since: 2
                ),
                ],
        )
    /// Destroy The Pad Object
    /// 
    /// Destroy the zwp_tablet_pad_group_v2 object. Objects created from this object
    /// are unaffected and should be destroyed separately.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletV2)
    }
    public enum Event: Decodable {
        /// Buttons Announced
        /// 
        /// Sent on zwp_tablet_pad_group_v2 initialization to announce the available
        /// buttons in the group. Button indices start at 0, a button may only be
        /// in one group at a time.
        /// This event is first sent in the initial burst of events before the
        /// zwp_tablet_pad_group_v2.done event.
        /// Some buttons are reserved by the compositor. These buttons may not be
        /// assigned to any zwp_tablet_pad_group_v2. Compositors may broadcast this
        /// event in the case of changes to the mapping of these reserved buttons.
        /// If the compositor happens to reserve all buttons in a group, this event
        /// will be sent with an empty array.
        case buttons(buttons: Data)

        /// Ring Announced
        /// 
        /// Sent on zwp_tablet_pad_group_v2 initialization to announce available rings.
        /// One event is sent for each ring available on this pad group.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_group_v2.done event.
        case ring(ring: ZwpTabletPadRingV2)

        /// Strip Announced
        /// 
        /// Sent on zwp_tablet_pad_v2 initialization to announce available strips.
        /// One event is sent for each strip available on this pad group.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_group_v2.done event.
        case strip(strip: ZwpTabletPadStripV2)

        /// Mode-Switch Ability Announced
        /// 
        /// Sent on zwp_tablet_pad_group_v2 initialization to announce that the pad
        /// group may switch between modes. A client may use a mode to store a
        /// specific configuration for buttons, rings and strips and use the
        /// zwp_tablet_pad_group_v2.mode_switch event to toggle between these
        /// configurations. Mode indices start at 0.
        /// Switching modes is compositor-dependent. See the
        /// zwp_tablet_pad_group_v2.mode_switch event for more details.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_group_v2.done event. This event is only sent when
        /// more than one mode is available.
        case modes(modes: UInt32)

        /// Tablet Group Description Events Sequence Complete
        /// 
        /// This event is sent immediately to signal the end of the initial
        /// burst of descriptive events. A client may consider the static
        /// description of the tablet to be complete and finalize initialization
        /// of the tablet group.
        case done

        /// Mode Switch Event
        /// 
        /// Notification that the mode was switched.
        /// A mode applies to all buttons, rings, strips and dials in a group
        /// simultaneously, but a client is not required to assign different actions
        /// for each mode. For example, a client may have mode-specific button
        /// mappings but map the ring to vertical scrolling in all modes. Mode
        /// indices start at 0.
        /// Switching modes is compositor-dependent. The compositor may provide
        /// visual cues to the user about the mode, e.g. by toggling LEDs on
        /// the tablet device. Mode-switching may be software-controlled or
        /// controlled by one or more physical buttons. For example, on a Wacom
        /// Intuos Pro, the button inside the ring may be assigned to switch
        /// between modes.
        /// The compositor will also send this event after zwp_tablet_pad_v2.enter on
        /// each group in order to notify of the current mode. Groups that only
        /// feature one mode will use mode=0 when emitting this event.
        /// If a button action in the new mode differs from the action in the
        /// previous mode, the client should immediately issue a
        /// zwp_tablet_pad_v2.set_feedback request for each changed button.
        /// If a ring, strip or dial action in the new mode differs from the action
        /// in the previous mode, the client should immediately issue a
        /// zwp_tablet_ring_v2.set_feedback, zwp_tablet_strip_v2.set_feedback or
        /// zwp_tablet_dial_v2.set_feedback request for each changed ring, strip or dial.
        case modeSwitch(time: UInt32, serial: UInt32, mode: UInt32)

        /// Dial Announced
        /// 
        /// Sent on zwp_tablet_pad_v2 initialization to announce available dials.
        /// One event is sent for each dial available on this pad group.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_group_v2.done event.
        case dial(dial: ZwpTabletPadDialV2)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.buttons(buttons: r.array())
            case 1:
                self = Self.ring(ring: r.newId(type: ZwpTabletPadRingV2.self))
            case 2:
                self = Self.strip(strip: r.newId(type: ZwpTabletPadStripV2.self))
            case 3:
                self = Self.modes(modes: r.uint())
            case 4:
                self = Self.done
            case 5:
                self = Self.modeSwitch(time: r.uint(), serial: r.uint(), mode: r.uint())
            case 6:
                self = Self.dial(dial: r.newId(type: ZwpTabletPadDialV2.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// A Set Of Buttons, Rings, Strips And Dials
/// 
/// A pad device is a set of buttons, rings, strips and dials
/// usually physically present on the tablet device itself. Some
/// exceptions exist where the pad device is physically detached, e.g. the
/// Wacom ExpressKey Remote.
/// Pad devices have no axes that control the cursor and are generally
/// auxiliary devices to the tool devices used on the tablet surface.
/// A pad device has a number of static characteristics, e.g. the number
/// of rings. These capabilities are sent in an event sequence after the
/// zwp_tablet_seat_v2.pad_added event before any actual events from this pad.
/// This initial event sequence is terminated by a zwp_tablet_pad_v2.done
/// event.
/// All pad features (buttons, rings, strips and dials) are logically divided into
/// groups and all pads have at least one group. The available groups are
/// notified through the zwp_tablet_pad_v2.group event; the compositor will
/// emit one event per group before emitting zwp_tablet_pad_v2.done.
/// Groups may have multiple modes. Modes allow clients to map multiple
/// actions to a single pad feature. Only one mode can be active per group,
/// although different groups may have different active modes.
public final class ZwpTabletPadV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_pad_v2",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "set_feedback",
                    arguments: [
                    Argument(
                        name: "button",
                        type: .uint,
                    ),
                    Argument(
                        name: "description",
                        type: .string,
                    ),
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "group",
                    arguments: [
                    Argument(
                        name: "pad_group",
                        type: .newId,
                        interface: "zwp_tablet_pad_group_v2"
                    ),
                    ],
                ),
                Message(
                    name: "path",
                    arguments: [
                    Argument(
                        name: "path",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "buttons",
                    arguments: [
                    Argument(
                        name: "buttons",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [
                    ],
                ),
                Message(
                    name: "button",
                    arguments: [
                    Argument(
                        name: "time",
                        type: .uint,
                    ),
                    Argument(
                        name: "button",
                        type: .uint,
                    ),
                    Argument(
                        name: "state",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "enter",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "tablet",
                        type: .object,
                        interface: "zwp_tablet_v2"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "leave",
                    arguments: [
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "removed",
                    arguments: [
                    ],
                ),
                ],
        )
    /// Set Compositor Feedback
    /// 
    /// Requests the compositor to use the provided feedback string
    /// associated with this button. This request should be issued immediately
    /// after a zwp_tablet_pad_group_v2.mode_switch event from the corresponding
    /// group is received, or whenever a button is mapped to a different
    /// action. See zwp_tablet_pad_group_v2.mode_switch for more details.
    /// Clients are encouraged to provide context-aware descriptions for
    /// the actions associated with each button, and compositors may use
    /// this information to offer visual feedback on the button layout
    /// (e.g. on-screen displays).
    /// Button indices start at 0. Setting the feedback string on a button
    /// that is reserved by the compositor (i.e. not belonging to any
    /// zwp_tablet_pad_group_v2) does not generate an error but the compositor
    /// is free to ignore the request.
    /// The provided string 'description' is a UTF-8 encoded string to be
    /// associated with this ring, and is considered user-visible; general
    /// internationalization rules apply.
    /// The serial argument will be that of the last
    /// zwp_tablet_pad_group_v2.mode_switch event received for the group of this
    /// button. Requests providing other serials than the most recent one will
    /// be ignored.
    /// 
    /// - Parameters:
    ///   - button: button index
    ///   - description: button description
    ///   - serial: serial of the mode switch event
    public func setFeedback(button: UInt32, description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(button),
            .string(description),
            .uint(serial),
        ])
    }

    /// Destroy The Pad Object
    /// 
    /// Destroy the zwp_tablet_pad_v2 object. Objects created from this object
    /// are unaffected and should be destroyed separately.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletV2)
    }
    public enum ButtonState: UInt32 {
        /// the button is not pressed
        case released = 0

        /// the button is pressed
        case pressed = 1
    }

    public enum Event: Decodable {
        /// Group Announced
        /// 
        /// Sent on zwp_tablet_pad_v2 initialization to announce available groups.
        /// One event is sent for each pad group available.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_v2.done event. At least one group will be announced.
        case group(padGroup: ZwpTabletPadGroupV2)

        /// Path To The Device
        /// 
        /// A system-specific device path that indicates which device is behind
        /// this zwp_tablet_pad_v2. This information may be used to gather additional
        /// information about the device, e.g. through libwacom.
        /// The format of the path is unspecified, it may be a device node, a
        /// sysfs path, or some other identifier. It is up to the client to
        /// identify the string provided.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_v2.done event.
        case path(path: String)

        /// Buttons Announced
        /// 
        /// Sent on zwp_tablet_pad_v2 initialization to announce the available
        /// buttons.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_v2.done event. This event is only sent when at least one
        /// button is available.
        case buttons(buttons: UInt32)

        /// Pad Description Event Sequence Complete
        /// 
        /// This event signals the end of the initial burst of descriptive
        /// events. A client may consider the static description of the pad to
        /// be complete and finalize initialization of the pad.
        case done

        /// Physical Button State
        /// 
        /// Sent whenever the physical state of a button changes.
        case button(time: UInt32, button: UInt32, state: UInt32)

        /// Enter Event
        /// 
        /// Notification that this pad is focused on the specified surface.
        case enter(serial: UInt32, tablet: ZwpTabletV2, surface: WlSurface)

        /// Leave Event
        /// 
        /// Notification that this pad is no longer focused on the specified
        /// surface.
        case leave(serial: UInt32, surface: WlSurface)

        /// Pad Removed Event
        /// 
        /// Sent when the pad has been removed from the system. When a tablet
        /// is removed its pad(s) will be removed too.
        /// When this event is received, the client must destroy all rings, strips
        /// and groups that were offered by this pad, and issue zwp_tablet_pad_v2.destroy
        /// the pad itself.
        case removed

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.group(padGroup: r.newId(type: ZwpTabletPadGroupV2.self))
            case 1:
                self = Self.path(path: r.string())
            case 2:
                self = Self.buttons(buttons: r.uint())
            case 3:
                self = Self.done
            case 4:
                self = Self.button(time: r.uint(), button: r.uint(), state: r.uint())
            case 5:
                self = Self.enter(serial: r.uint(), tablet: r.object(type: ZwpTabletV2.self), surface: r.object(type: WlSurface.self))
            case 6:
                self = Self.leave(serial: r.uint(), surface: r.object(type: WlSurface.self))
            case 7:
                self = Self.removed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Pad Dial
/// 
/// A rotary control, e.g. a dial or a wheel.
/// Events on a dial are logically grouped by the zwp_tablet_pad_dial_v2.frame
/// event.
public final class ZwpTabletPadDialV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_pad_dial_v2",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "set_feedback",
                    arguments: [
                    Argument(
                        name: "description",
                        type: .string,
                    ),
                    Argument(
                        name: "serial",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "delta",
                    arguments: [
                    Argument(
                        name: "value120",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "frame",
                    arguments: [
                    Argument(
                        name: "time",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
    /// Set Compositor Feedback
    /// 
    /// Requests the compositor to use the provided feedback string
    /// associated with this dial. This request should be issued immediately
    /// after a zwp_tablet_pad_group_v2.mode_switch event from the corresponding
    /// group is received, or whenever the dial is mapped to a different
    /// action. See zwp_tablet_pad_group_v2.mode_switch for more details.
    /// Clients are encouraged to provide context-aware descriptions for
    /// the actions associated with the dial, and compositors may use this
    /// information to offer visual feedback about the button layout
    /// (eg. on-screen displays).
    /// The provided string 'description' is a UTF-8 encoded string to be
    /// associated with this ring, and is considered user-visible; general
    /// internationalization rules apply.
    /// The serial argument will be that of the last
    /// zwp_tablet_pad_group_v2.mode_switch event received for the group of this
    /// dial. Requests providing other serials than the most recent one will be
    /// ignored.
    /// 
    /// - Parameters:
    ///   - description: dial description
    ///   - serial: serial of the mode switch event
    public func setFeedback(description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(description),
            .uint(serial),
        ])
    }

    /// Destroy The Dial Object
    /// 
    /// This destroys the client's resource for this dial object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletV2)
    }
    public enum Event: Decodable {
        /// Delta Movement
        /// 
        /// Sent whenever the position on a dial changes.
        /// This event carries the wheel delta as multiples or fractions
        /// of 120 with each multiple of 120 representing one logical wheel detent.
        /// For example, an axis_value120 of 30 is one quarter of
        /// a logical wheel step in the positive direction, a value120 of
        /// -240 are two logical wheel steps in the negative direction within the
        /// same hardware event. See the wl_pointer.axis_value120 for more details.
        /// The value120 must not be zero.
        case delta(value120: Int32)

        /// End Of A Dial Event Sequence
        /// 
        /// Indicates the end of a set of events that represent one logical
        /// hardware dial event. A client is expected to accumulate the data
        /// in all events within the frame before proceeding.
        /// All zwp_tablet_pad_dial_v2 events before a zwp_tablet_pad_dial_v2.frame event belong
        /// logically together.
        /// A zwp_tablet_pad_dial_v2.frame event is sent for every logical event
        /// group, even if the group only contains a single zwp_tablet_pad_dial_v2
        /// event. Specifically, a client may get a sequence: delta, frame,
        /// delta, frame, etc.
        case frame(time: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.delta(value120: r.int())
            case 1:
                self = Self.frame(time: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let TabletV2 = Protocol(
        name: "tablet_v2",
        interfaces: [
            ZwpTabletManagerV2.interface,
ZwpTabletSeatV2.interface,
ZwpTabletToolV2.interface,
ZwpTabletV2.interface,
ZwpTabletPadRingV2.interface,
ZwpTabletPadStripV2.interface,
ZwpTabletPadGroupV2.interface,
ZwpTabletPadV2.interface,
ZwpTabletPadDialV2.interface
        ]
    )
