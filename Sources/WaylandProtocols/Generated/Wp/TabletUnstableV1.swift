import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// Controller Object For Graphic Tablet Devices
/// 
/// An object that provides access to the graphics tablets available on this
/// system. All tablets are associated with a seat, to get access to the
/// actual tablets, use wp_tablet_manager.get_tablet_seat.
public final class ZwpTabletManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_manager_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "get_tablet_seat",
                    arguments: [
                    Argument(
                        name: "tablet_seat",
                        type: .newId,
                        interface: "zwp_tablet_seat_v1",
                    ),
                    Argument(
                        name: "seat",
                        type: .object,
                        interface: "wl_seat",
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
    /// Get the wp_tablet_seat object for the given seat. This object
    /// provides access to all graphics tablets in this seat.
    /// 
    /// - Parameters:
    ///   - seat: The wl_seat object to retrieve the tablets for
    public func getTabletSeat(seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpTabletSeatV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let tabletSeat = connection.createProxy(type: ZwpTabletSeatV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(tabletSeat.id),
            .object(seat.id),
        ])
        return tabletSeat
    }

    /// Release The Memory For The Tablet Manager Object
    /// 
    /// Destroy the wp_tablet_manager object. Objects created from this
    /// object are unaffected and should be destroyed separately.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletUnstableV1Protocol)
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
/// Controller Object For Graphic Tablet Devices Of A Seat
/// 
/// An object that provides access to the graphics tablets available on this
/// seat. After binding to this interface, the compositor sends a set of
/// wp_tablet_seat.tablet_added and wp_tablet_seat.tool_added events.
public final class ZwpTabletSeatV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_seat_v1",
            version: 1,
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
                        interface: "zwp_tablet_v1",
                    ),
                    ],
                ),
                Message(
                    name: "tool_added",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_tablet_tool_v1",
                    ),
                    ],
                ),
                ],
        )
    /// Release The Memory For The Tablet Seat Object
    /// 
    /// Destroy the wp_tablet_seat object. Objects created from this
    /// object are unaffected and should be destroyed separately.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletUnstableV1Protocol)
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
        /// New Device Notification
        /// 
        /// This event is sent whenever a new tablet becomes available on this
        /// seat. This event only provides the object id of the tablet, any
        /// static information about the tablet (device name, vid/pid, etc.) is
        /// sent through the wp_tablet interface.
        case tabletAdded(id: ZwpTabletV1)

        /// A New Tool Has Been Used With A Tablet
        /// 
        /// This event is sent whenever a tool that has not previously been used
        /// with a tablet comes into use. This event only provides the object id
        /// of the tool; any static information about the tool (capabilities,
        /// type, etc.) is sent through the wp_tablet_tool interface.
        case toolAdded(id: ZwpTabletToolV1)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.tabletAdded(id: r.newId(type: ZwpTabletV1.self))
            case 1:
                self = Self.toolAdded(id: r.newId(type: ZwpTabletToolV1.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
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
public final class ZwpTabletToolV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_tool_v1",
            version: 1,
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
                        interface: "wl_surface",
                        nullable: true,
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
                        interface: "zwp_tablet_v1",
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface",
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
                        type: .int,
                    ),
                    Argument(
                        name: "tilt_y",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "rotation",
                    arguments: [
                    Argument(
                        name: "degrees",
                        type: .int,
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
                        type: .int,
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
    /// This request gives the surface the role of a cursor. The role
    /// assigned by this request is the same as assigned by
    /// wl_pointer.set_cursor meaning the same surface can be
    /// used both as a wl_pointer cursor and a wp_tablet cursor. If the
    /// surface already has another role, it raises a protocol error.
    /// The surface may be used on multiple tablets and across multiple
    /// seats.
    /// 
    /// - Parameters:
    ///   - serial: serial of the enter event
    ///   - hotspotX: surface-local x coordinate
    ///   - hotspotY: surface-local y coordinate
    public func setCursor(serial: UInt32, surface: WlSurface? = nil, hotspotX: Int32, hotspotY: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(serial),
            .object(surface?.id ?? 0),
            .int(hotspotX),
            .int(hotspotY),
        ])
    }

    /// Destroy The Tool Object
    /// 
    /// This destroys the client's resource for this tool object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletUnstableV1Protocol)
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
        /// Tool Type
        /// 
        /// The tool type is the high-level type of the tool and usually decides
        /// the interaction expected from this tool.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_tool.done event.
        case type(toolType: Type)

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
        case hardwareIdWacom(hardwareIdHi: UInt32, hardwareIdLo: UInt32)

        /// Tool Capability Notification
        /// 
        /// This event notifies the client of any capabilities of this tool,
        /// beyond the main set of x/y axes and tip up/down detection.
        /// One event is sent for each extra capability available on this tool.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_tool.done event.
        case capability(capability: Capability)

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
        case proximityIn(serial: UInt32, tablet: ZwpTabletV1, surface: WlSurface)

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
        /// value is in 0.01 of a degree, relative to the z-axis of the tablet.
        /// The angle is positive when the top of a tool tilts along the
        /// positive x or y axis.
        case tilt(tiltX: Int32, tiltY: Int32)

        /// Z-Rotation Change Event
        /// 
        /// Sent whenever the z-rotation axis on the tool changes. The
        /// rotation value is in 0.01 of a degree clockwise from the tool's
        /// logical neutral position.
        case rotation(degrees: Int32)

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
        /// in 0.01 of a degree in the same orientation as the
        /// wl_pointer.vertical_scroll axis. The clicks value is in discrete
        /// logical clicks of the mouse wheel. This value may be zero if the
        /// movement of the wheel was less than one logical click.
        /// Clients should choose either value and avoid mixing degrees and
        /// clicks. The compositor may accumulate values smaller than a logical
        /// click and emulate click events when a certain threshold is met.
        /// Thus, wl_tablet_tool.wheel events with non-zero clicks values may
        /// have different degrees values.
        case wheel(degrees: Int32, clicks: Int32)

        /// Button Event
        /// 
        /// Sent whenever a button on the tool is pressed or released.
        /// If a button is held down when the tool moves in or out of proximity,
        /// button events are generated by the compositor. See
        /// wp_tablet_tool.proximity_in and wp_tablet_tool.proximity_out for
        /// details.
        case button(serial: UInt32, button: UInt32, state: ButtonState)

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
                self = Self.type(toolType: try _parseEnum(into: Type.self, r.uint()))
            case 1:
                self = Self.hardwareSerial(hardwareSerialHi: r.uint(), hardwareSerialLo: r.uint())
            case 2:
                self = Self.hardwareIdWacom(hardwareIdHi: r.uint(), hardwareIdLo: r.uint())
            case 3:
                self = Self.capability(capability: try _parseEnum(into: Capability.self, r.uint()))
            case 4:
                self = Self.done
            case 5:
                self = Self.removed
            case 6:
                self = Self.proximityIn(serial: r.uint(), tablet: r.object(type: ZwpTabletV1.self), surface: r.object(type: WlSurface.self))
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
                self = Self.tilt(tiltX: r.int(), tiltY: r.int())
            case 14:
                self = Self.rotation(degrees: r.int())
            case 15:
                self = Self.slider(position: r.int())
            case 16:
                self = Self.wheel(degrees: r.int(), clicks: r.int())
            case 17:
                self = Self.button(serial: r.uint(), button: r.uint(), state: try _parseEnum(into: ButtonState.self, r.uint()))
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
/// The wp_tablet interface represents one graphics tablet device. The
/// tablet interface itself does not generate events; all events are
/// generated by wp_tablet_tool objects when in proximity above a tablet.
/// A tablet has a number of static characteristics, e.g. device name and
/// pid/vid. These capabilities are sent in an event sequence after the
/// wp_tablet_seat.tablet_added event. This initial event sequence is
/// terminated by a wp_tablet.done event.
public final class ZwpTabletV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_v1",
            version: 1,
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
                ],
        )
    /// Destroy The Tablet Object
    /// 
    /// This destroys the client's resource for this tablet object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: TabletUnstableV1Protocol)
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
        /// Tablet Device Name
        /// 
        /// This event is sent in the initial burst of events before the
        /// wp_tablet.done event.
        case name(name: String)

        /// Tablet Device Usb Vendor/Product Id
        /// 
        /// This event is sent in the initial burst of events before the
        /// wp_tablet.done event.
        case id(vid: UInt32, pid: UInt32)

        /// Path To The Device
        /// 
        /// A system-specific device path that indicates which device is behind
        /// this wp_tablet. This information may be used to gather additional
        /// information about the device, e.g. through libwacom.
        /// A device may have more than one device path. If so, multiple
        /// wp_tablet.path events are sent. A device may be emulated and not
        /// have a device path, and in that case this event will not be sent.
        /// The format of the path is unspecified, it may be a device node, a
        /// sysfs path, or some other identifier. It is up to the client to
        /// identify the string provided.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet.done event.
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
        /// When this event is received, the client must wp_tablet.destroy
        /// the object.
        case removed

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
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let TabletUnstableV1Protocol = Protocol(
        name: "tablet_unstable_v1",
        interfaces: [
            ZwpTabletManagerV1.interface,
ZwpTabletSeatV1.interface,
ZwpTabletToolV1.interface,
ZwpTabletV1.interface
        ]
    )

#endif