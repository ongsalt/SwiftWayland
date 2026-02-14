import Foundation

/// Pad Ring
/// 
/// A circular interaction area, such as the touch ring on the Wacom Intuos
/// Pro series tablets.
/// Events on a ring are logically grouped by the zwp_tablet_pad_ring_v2.frame
/// event.
public final class ZwpTabletPadRingV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_pad_ring_v2"
    public var onEvent: (Event) -> Void = { _ in }

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
    ///   - Description: ring description
    ///   - Serial: serial of the mode switch event
    public func setFeedback(description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.string(description),
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    /// Destroy The Ring Object
    /// 
    /// This destroys the client's resource for this ring object.
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
    
    /// Ring Axis Source
    /// 
    /// Describes the source types for ring events. This indicates to the
    /// client how a ring event was physically generated; a client may
    /// adjust the user interface accordingly. For example, events
    /// from a "finger" source may trigger kinetic scrolling.
    public enum Source: UInt32, WlEnum {
        /// Finger
        case finger = 1
    }
    
    public enum Event: WlEventEnum {
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
        /// 
        /// - Parameters:
        ///   - Source: the event source
        case source(source: UInt32)
        
        /// Angle Changed
        /// 
        /// Sent whenever the angle on a ring changes.
        /// The angle is provided in degrees clockwise from the logical
        /// north of the ring in the pad's current rotation.
        /// 
        /// - Parameters:
        ///   - Degrees: the current angle in degrees
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
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        case frame(time: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.source(source: r.readUInt())
            case 1:
                return Self.angle(degrees: r.readFixed())
            case 2:
                return Self.stop
            case 3:
                return Self.frame(time: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
