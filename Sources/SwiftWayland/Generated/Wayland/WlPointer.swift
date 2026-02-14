import Foundation

/// Pointer Input Device
/// 
/// The wl_pointer interface represents one or more input devices,
/// such as mice, which control the pointer location and pointer_focus
/// of a seat.
/// The wl_pointer interface generates motion, enter and leave
/// events for the surfaces that the pointer is located over,
/// and button and axis events for button presses, button releases
/// and scrolling.
public final class WlPointer: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_pointer"
    public var onEvent: (Event) -> Void = { _ in }

    /// Set The Pointer Surface
    /// 
    /// Set the pointer surface, i.e., the surface that contains the
    /// pointer image (cursor). This request gives the surface the role
    /// of a cursor. If the surface already has another role, it raises
    /// a protocol error.
    /// The cursor actually changes only if the pointer
    /// focus for this device is one of the requesting client's surfaces
    /// or the surface parameter is the current pointer surface. If
    /// there was a previous surface set with this request it is
    /// replaced. If surface is NULL, the pointer image is hidden.
    /// The parameters hotspot_x and hotspot_y define the position of
    /// the pointer surface relative to the pointer location. Its
    /// top-left corner is always at (x, y) - (hotspot_x, hotspot_y),
    /// where (x, y) are the coordinates of the pointer location, in
    /// surface-local coordinates.
    /// On wl_surface.offset requests to the pointer surface, hotspot_x
    /// and hotspot_y are decremented by the x and y parameters
    /// passed to the request. The offset must be applied by
    /// wl_surface.commit as usual.
    /// The hotspot can also be updated by passing the currently set
    /// pointer surface to this request with new values for hotspot_x
    /// and hotspot_y.
    /// The input region is ignored for wl_surfaces with the role of
    /// a cursor. When the use as a cursor ends, the wl_surface is
    /// unmapped.
    /// The serial parameter must match the latest wl_pointer.enter
    /// serial number sent to the client. Otherwise the request will be
    /// ignored.
    /// 
    /// - Parameters:
    ///   - Serial: serial number of the enter event
    ///   - Surface: pointer surface
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
    
    /// Release The Pointer Object
    /// 
    /// Using this request a client can tell the server that it is not going to
    /// use the pointer object anymore.
    /// This request destroys the pointer proxy object, so clients must not call
    /// wl_pointer_destroy() after using this request.
    /// 
    /// Available since version 3
    public consuming func release() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.release()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Given Wl_Surface Has Another Role
        case role = 0
    }
    
    /// Physical Button State
    /// 
    /// Describes the physical state of a button that produced the button
    /// event.
    public enum ButtonState: UInt32, WlEnum {
        /// The Button Is Not Pressed
        case released = 0
        
        /// The Button Is Pressed
        case pressed = 1
    }
    
    /// Axis Types
    /// 
    /// Describes the axis types of scroll events.
    public enum Axis: UInt32, WlEnum {
        /// Vertical Axis
        case verticalScroll = 0
        
        /// Horizontal Axis
        case horizontalScroll = 1
    }
    
    /// Axis Source Types
    /// 
    /// Describes the source types for axis events. This indicates to the
    /// client how an axis event was physically generated; a client may
    /// adjust the user interface accordingly. For example, scroll events
    /// from a "finger" source may be in a smooth coordinate space with
    /// kinetic scrolling whereas a "wheel" source may be in discrete steps
    /// of a number of lines.
    /// The "continuous" axis source is a device generating events in a
    /// continuous coordinate space, but using something other than a
    /// finger. One example for this source is button-based scrolling where
    /// the vertical motion of a device is converted to scroll events while
    /// a button is held down.
    /// The "wheel tilt" axis source indicates that the actual device is a
    /// wheel but the scroll event is not caused by a rotation but a
    /// (usually sideways) tilt of the wheel.
    public enum AxisSource: UInt32, WlEnum {
        /// A Physical Wheel Rotation
        case wheel = 0
        
        /// Finger On A Touch Surface
        case finger = 1
        
        /// Continuous Coordinate Space
        case continuous = 2
        
        /// A Physical Wheel Tilt
        case wheelTilt = 3
    }
    
    /// Axis Relative Direction
    /// 
    /// This specifies the direction of the physical motion that caused a
    /// wl_pointer.axis event, relative to the wl_pointer.axis direction.
    public enum AxisRelativeDirection: UInt32, WlEnum {
        /// Physical Motion Matches Axis Direction
        case identical = 0
        
        /// Physical Motion Is The Inverse Of The Axis Direction
        case inverted = 1
    }
    
    public enum Event: WlEventEnum {
        /// Enter Event
        /// 
        /// Notification that this seat's pointer is focused on a certain
        /// surface.
        /// When a seat's focus enters a surface, the pointer image
        /// is undefined and a client should respond to this event by setting
        /// an appropriate pointer image with the set_cursor request.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the enter event
        ///   - Surface: surface entered by the pointer
        ///   - SurfaceX: surface-local x coordinate
        ///   - SurfaceY: surface-local y coordinate
        case enter(serial: UInt32, surface: WlSurface, surfaceX: Double, surfaceY: Double)
        
        /// Leave Event
        /// 
        /// Notification that this seat's pointer is no longer focused on
        /// a certain surface.
        /// The leave notification is sent before the enter notification
        /// for the new focus.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the leave event
        ///   - Surface: surface left by the pointer
        case leave(serial: UInt32, surface: WlSurface)
        
        /// Pointer Motion Event
        /// 
        /// Notification of pointer location change. The arguments
        /// surface_x and surface_y are the location relative to the
        /// focused surface.
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        ///   - SurfaceX: surface-local x coordinate
        ///   - SurfaceY: surface-local y coordinate
        case motion(time: UInt32, surfaceX: Double, surfaceY: Double)
        
        /// Pointer Button Event
        /// 
        /// Mouse button click and release notifications.
        /// The location of the click is given by the last motion or
        /// enter event.
        /// The time argument is a timestamp with millisecond
        /// granularity, with an undefined base.
        /// The button is a button code as defined in the Linux kernel's
        /// linux/input-event-codes.h header file, e.g. BTN_LEFT.
        /// Any 16-bit button code value is reserved for future additions to the
        /// kernel's event code list. All other button codes above 0xFFFF are
        /// currently undefined but may be used in future versions of this
        /// protocol.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the button event
        ///   - Time: timestamp with millisecond granularity
        ///   - Button: button that produced the event
        ///   - State: physical state of the button
        case button(serial: UInt32, time: UInt32, button: UInt32, state: UInt32)
        
        /// Axis Event
        /// 
        /// Scroll and other axis notifications.
        /// For scroll events (vertical and horizontal scroll axes), the
        /// value parameter is the length of a vector along the specified
        /// axis in a coordinate space identical to those of motion events,
        /// representing a relative movement along the specified axis.
        /// For devices that support movements non-parallel to axes multiple
        /// axis events will be emitted.
        /// When applicable, for example for touch pads, the server can
        /// choose to emit scroll events where the motion vector is
        /// equivalent to a motion event vector.
        /// When applicable, a client can transform its content relative to the
        /// scroll distance.
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        ///   - Axis: axis type
        ///   - Value: length of vector in surface-local coordinate space
        case axis(time: UInt32, axis: UInt32, value: Double)
        
        /// End Of A Pointer Event Sequence
        /// 
        /// Indicates the end of a set of events that logically belong together.
        /// A client is expected to accumulate the data in all events within the
        /// frame before proceeding.
        /// All wl_pointer events before a wl_pointer.frame event belong
        /// logically together. For example, in a diagonal scroll motion the
        /// compositor will send an optional wl_pointer.axis_source event, two
        /// wl_pointer.axis events (horizontal and vertical) and finally a
        /// wl_pointer.frame event. The client may use this information to
        /// calculate a diagonal vector for scrolling.
        /// When multiple wl_pointer.axis events occur within the same frame,
        /// the motion vector is the combined motion of all events.
        /// When a wl_pointer.axis and a wl_pointer.axis_stop event occur within
        /// the same frame, this indicates that axis movement in one axis has
        /// stopped but continues in the other axis.
        /// When multiple wl_pointer.axis_stop events occur within the same
        /// frame, this indicates that these axes stopped in the same instance.
        /// A wl_pointer.frame event is sent for every logical event group,
        /// even if the group only contains a single wl_pointer event.
        /// Specifically, a client may get a sequence: motion, frame, button,
        /// frame, axis, frame, axis_stop, frame.
        /// The wl_pointer.enter and wl_pointer.leave events are logical events
        /// generated by the compositor and not the hardware. These events are
        /// also grouped by a wl_pointer.frame. When a pointer moves from one
        /// surface to another, a compositor should group the
        /// wl_pointer.leave event within the same wl_pointer.frame.
        /// However, a client must not rely on wl_pointer.leave and
        /// wl_pointer.enter being in the same wl_pointer.frame.
        /// Compositor-specific policies may require the wl_pointer.leave and
        /// wl_pointer.enter event being split across multiple wl_pointer.frame
        /// groups.
        /// 
        /// Available since version 5
        case frame
        
        /// Axis Source Event
        /// 
        /// Source information for scroll and other axes.
        /// This event does not occur on its own. It is sent before a
        /// wl_pointer.frame event and carries the source information for
        /// all events within that frame.
        /// The source specifies how this event was generated. If the source is
        /// wl_pointer.axis_source.finger, a wl_pointer.axis_stop event will be
        /// sent when the user lifts the finger off the device.
        /// If the source is wl_pointer.axis_source.wheel,
        /// wl_pointer.axis_source.wheel_tilt or
        /// wl_pointer.axis_source.continuous, a wl_pointer.axis_stop event may
        /// or may not be sent. Whether a compositor sends an axis_stop event
        /// for these sources is hardware-specific and implementation-dependent;
        /// clients must not rely on receiving an axis_stop event for these
        /// scroll sources and should treat scroll sequences from these scroll
        /// sources as unterminated by default.
        /// This event is optional. If the source is unknown for a particular
        /// axis event sequence, no event is sent.
        /// Only one wl_pointer.axis_source event is permitted per frame.
        /// The order of wl_pointer.axis_discrete and wl_pointer.axis_source is
        /// not guaranteed.
        /// 
        /// - Parameters:
        ///   - AxisSource: source of the axis event
        /// 
        /// Available since version 5
        case axisSource(axisSource: UInt32)
        
        /// Axis Stop Event
        /// 
        /// Stop notification for scroll and other axes.
        /// For some wl_pointer.axis_source types, a wl_pointer.axis_stop event
        /// is sent to notify a client that the axis sequence has terminated.
        /// This enables the client to implement kinetic scrolling.
        /// See the wl_pointer.axis_source documentation for information on when
        /// this event may be generated.
        /// Any wl_pointer.axis events with the same axis_source after this
        /// event should be considered as the start of a new axis motion.
        /// The timestamp is to be interpreted identical to the timestamp in the
        /// wl_pointer.axis event. The timestamp value may be the same as a
        /// preceding wl_pointer.axis event.
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        ///   - Axis: the axis stopped with this event
        /// 
        /// Available since version 5
        case axisStop(time: UInt32, axis: UInt32)
        
        /// Axis Click Event
        /// 
        /// Discrete step information for scroll and other axes.
        /// This event carries the axis value of the wl_pointer.axis event in
        /// discrete steps (e.g. mouse wheel clicks).
        /// This event is deprecated with wl_pointer version 8 - this event is not
        /// sent to clients supporting version 8 or later.
        /// This event does not occur on its own, it is coupled with a
        /// wl_pointer.axis event that represents this axis value on a
        /// continuous scale. The protocol guarantees that each axis_discrete
        /// event is always followed by exactly one axis event with the same
        /// axis number within the same wl_pointer.frame. Note that the protocol
        /// allows for other events to occur between the axis_discrete and
        /// its coupled axis event, including other axis_discrete or axis
        /// events. A wl_pointer.frame must not contain more than one axis_discrete
        /// event per axis type.
        /// This event is optional; continuous scrolling devices
        /// like two-finger scrolling on touchpads do not have discrete
        /// steps and do not generate this event.
        /// The discrete value carries the directional information. e.g. a value
        /// of -2 is two steps towards the negative direction of this axis.
        /// The axis number is identical to the axis number in the associated
        /// axis event.
        /// The order of wl_pointer.axis_discrete and wl_pointer.axis_source is
        /// not guaranteed.
        /// 
        /// - Parameters:
        ///   - Axis: axis type
        ///   - Discrete: number of steps
        /// 
        /// Available since version 5
        case axisDiscrete(axis: UInt32, discrete: Int32)
        
        /// Axis High-Resolution Scroll Event
        /// 
        /// Discrete high-resolution scroll information.
        /// This event carries high-resolution wheel scroll information,
        /// with each multiple of 120 representing one logical scroll step
        /// (a wheel detent). For example, an axis_value120 of 30 is one quarter of
        /// a logical scroll step in the positive direction, a value120 of
        /// -240 are two logical scroll steps in the negative direction within the
        /// same hardware event.
        /// Clients that rely on discrete scrolling should accumulate the
        /// value120 to multiples of 120 before processing the event.
        /// The value120 must not be zero.
        /// This event replaces the wl_pointer.axis_discrete event in clients
        /// supporting wl_pointer version 8 or later.
        /// Where a wl_pointer.axis_source event occurs in the same
        /// wl_pointer.frame, the axis source applies to this event.
        /// The order of wl_pointer.axis_value120 and wl_pointer.axis_source is
        /// not guaranteed.
        /// 
        /// - Parameters:
        ///   - Axis: axis type
        ///   - Value120: scroll distance as fraction of 120
        /// 
        /// Available since version 8
        case axisValue120(axis: UInt32, value120: Int32)
        
        /// Axis Relative Physical Direction Event
        /// 
        /// Relative directional information of the entity causing the axis
        /// motion.
        /// For a wl_pointer.axis event, the wl_pointer.axis_relative_direction
        /// event specifies the movement direction of the entity causing the
        /// wl_pointer.axis event. For example:
        /// - if a user's fingers on a touchpad move down and this
        /// causes a wl_pointer.axis vertical_scroll down event, the physical
        /// direction is 'identical'
        /// - if a user's fingers on a touchpad move down and this causes a
        /// wl_pointer.axis vertical_scroll up scroll up event ('natural
        /// scrolling'), the physical direction is 'inverted'.
        /// A client may use this information to adjust scroll motion of
        /// components. Specifically, enabling natural scrolling causes the
        /// content to change direction compared to traditional scrolling.
        /// Some widgets like volume control sliders should usually match the
        /// physical direction regardless of whether natural scrolling is
        /// active. This event enables clients to match the scroll direction of
        /// a widget to the physical direction.
        /// This event does not occur on its own, it is coupled with a
        /// wl_pointer.axis event that represents this axis value.
        /// The protocol guarantees that each axis_relative_direction event is
        /// always followed by exactly one axis event with the same
        /// axis number within the same wl_pointer.frame. Note that the protocol
        /// allows for other events to occur between the axis_relative_direction
        /// and its coupled axis event.
        /// The axis number is identical to the axis number in the associated
        /// axis event.
        /// The order of wl_pointer.axis_relative_direction,
        /// wl_pointer.axis_discrete and wl_pointer.axis_source is not
        /// guaranteed.
        /// 
        /// - Parameters:
        ///   - Axis: axis type
        ///   - Direction: physical direction relative to axis motion
        /// 
        /// Available since version 9
        case axisRelativeDirection(axis: UInt32, direction: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.enter(serial: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!, surfaceX: r.readFixed(), surfaceY: r.readFixed())
            case 1:
                return Self.leave(serial: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 2:
                return Self.motion(time: r.readUInt(), surfaceX: r.readFixed(), surfaceY: r.readFixed())
            case 3:
                return Self.button(serial: r.readUInt(), time: r.readUInt(), button: r.readUInt(), state: r.readUInt())
            case 4:
                return Self.axis(time: r.readUInt(), axis: r.readUInt(), value: r.readFixed())
            case 5:
                return Self.frame
            case 6:
                return Self.axisSource(axisSource: r.readUInt())
            case 7:
                return Self.axisStop(time: r.readUInt(), axis: r.readUInt())
            case 8:
                return Self.axisDiscrete(axis: r.readUInt(), discrete: r.readInt())
            case 9:
                return Self.axisValue120(axis: r.readUInt(), value120: r.readInt())
            case 10:
                return Self.axisRelativeDirection(axis: r.readUInt(), direction: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
