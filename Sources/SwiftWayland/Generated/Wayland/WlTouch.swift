import Foundation

/// Touchscreen Input Device
/// 
/// The wl_touch interface represents a touchscreen
/// associated with a seat.
/// Touch interactions can consist of one or more contacts.
/// For each contact, a series of events is generated, starting
/// with a down event, followed by zero or more motion events,
/// and ending with an up event. Events relating to the same
/// contact point can be identified by the ID of the sequence.
public final class WlTouch: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_touch"
    public var onEvent: (Event) -> Void = { _ in }

    /// Release The Touch Object
    /// 
    /// 
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
    
    public enum Event: WlEventEnum {
        /// Touch Down Event And Beginning Of A Touch Sequence
        /// 
        /// A new touch point has appeared on the surface. This touch point is
        /// assigned a unique ID. Future events from this touch point reference
        /// this ID. The ID ceases to be valid after a touch up event and may be
        /// reused in the future.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the touch down event
        ///   - Time: timestamp with millisecond granularity
        ///   - Surface: surface touched
        ///   - Id: the unique ID of this touch point
        ///   - X: surface-local x coordinate
        ///   - Y: surface-local y coordinate
        case down(serial: UInt32, time: UInt32, surface: WlSurface, id: Int32, x: Double, y: Double)
        
        /// End Of A Touch Event Sequence
        /// 
        /// The touch point has disappeared. No further events will be sent for
        /// this touch point and the touch point's ID is released and may be
        /// reused in a future touch down event.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the touch up event
        ///   - Time: timestamp with millisecond granularity
        ///   - Id: the unique ID of this touch point
        case up(serial: UInt32, time: UInt32, id: Int32)
        
        /// Update Of Touch Point Coordinates
        /// 
        /// A touch point has changed coordinates.
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        ///   - Id: the unique ID of this touch point
        ///   - X: surface-local x coordinate
        ///   - Y: surface-local y coordinate
        case motion(time: UInt32, id: Int32, x: Double, y: Double)
        
        /// End Of Touch Frame Event
        /// 
        /// Indicates the end of a set of events that logically belong together.
        /// A client is expected to accumulate the data in all events within the
        /// frame before proceeding.
        /// A wl_touch.frame terminates at least one event but otherwise no
        /// guarantee is provided about the set of events within a frame. A client
        /// must assume that any state not updated in a frame is unchanged from the
        /// previously known state.
        case frame
        
        /// Touch Session Cancelled
        /// 
        /// Sent if the compositor decides the touch stream is a global
        /// gesture. No further events are sent to the clients from that
        /// particular gesture. Touch cancellation applies to all touch points
        /// currently active on this client's surface. The client is
        /// responsible for finalizing the touch points, future touch points on
        /// this surface may reuse the touch point ID.
        /// No frame event is required after the cancel event.
        case cancel
        
        /// Update Shape Of Touch Point
        /// 
        /// Sent when a touchpoint has changed its shape.
        /// This event does not occur on its own. It is sent before a
        /// wl_touch.frame event and carries the new shape information for
        /// any previously reported, or new touch points of that frame.
        /// Other events describing the touch point such as wl_touch.down,
        /// wl_touch.motion or wl_touch.orientation may be sent within the
        /// same wl_touch.frame. A client should treat these events as a single
        /// logical touch point update. The order of wl_touch.shape,
        /// wl_touch.orientation and wl_touch.motion is not guaranteed.
        /// A wl_touch.down event is guaranteed to occur before the first
        /// wl_touch.shape event for this touch ID but both events may occur within
        /// the same wl_touch.frame.
        /// A touchpoint shape is approximated by an ellipse through the major and
        /// minor axis length. The major axis length describes the longer diameter
        /// of the ellipse, while the minor axis length describes the shorter
        /// diameter. Major and minor are orthogonal and both are specified in
        /// surface-local coordinates. The center of the ellipse is always at the
        /// touchpoint location as reported by wl_touch.down or wl_touch.move.
        /// This event is only sent by the compositor if the touch device supports
        /// shape reports. The client has to make reasonable assumptions about the
        /// shape if it did not receive this event.
        /// 
        /// - Parameters:
        ///   - Id: the unique ID of this touch point
        ///   - Major: length of the major axis in surface-local coordinates
        ///   - Minor: length of the minor axis in surface-local coordinates
        /// 
        /// Available since version 6
        case shape(id: Int32, major: Double, minor: Double)
        
        /// Update Orientation Of Touch Point
        /// 
        /// Sent when a touchpoint has changed its orientation.
        /// This event does not occur on its own. It is sent before a
        /// wl_touch.frame event and carries the new shape information for
        /// any previously reported, or new touch points of that frame.
        /// Other events describing the touch point such as wl_touch.down,
        /// wl_touch.motion or wl_touch.shape may be sent within the
        /// same wl_touch.frame. A client should treat these events as a single
        /// logical touch point update. The order of wl_touch.shape,
        /// wl_touch.orientation and wl_touch.motion is not guaranteed.
        /// A wl_touch.down event is guaranteed to occur before the first
        /// wl_touch.orientation event for this touch ID but both events may occur
        /// within the same wl_touch.frame.
        /// The orientation describes the clockwise angle of a touchpoint's major
        /// axis to the positive surface y-axis and is normalized to the -180 to
        /// +180 degree range. The granularity of orientation depends on the touch
        /// device, some devices only support binary rotation values between 0 and
        /// 90 degrees.
        /// This event is only sent by the compositor if the touch device supports
        /// orientation reports.
        /// 
        /// - Parameters:
        ///   - Id: the unique ID of this touch point
        ///   - Orientation: angle between major axis and positive surface y-axis in degrees
        /// 
        /// Available since version 6
        case orientation(id: Int32, orientation: Double)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.down(serial: r.readUInt(), time: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!, id: r.readInt(), x: r.readFixed(), y: r.readFixed())
            case 1:
                return Self.up(serial: r.readUInt(), time: r.readUInt(), id: r.readInt())
            case 2:
                return Self.motion(time: r.readUInt(), id: r.readInt(), x: r.readFixed(), y: r.readFixed())
            case 3:
                return Self.frame
            case 4:
                return Self.cancel
            case 5:
                return Self.shape(id: r.readInt(), major: r.readFixed(), minor: r.readFixed())
            case 6:
                return Self.orientation(id: r.readInt(), orientation: r.readFixed())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
