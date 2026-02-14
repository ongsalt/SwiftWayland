import Foundation
import SwiftWayland

/// Pad Strip
/// 
/// A linear interaction area, such as the strips found in Wacom Cintiq
/// models.
/// Events on a strip are logically grouped by the wl_tablet_pad_strip.frame
/// event.
public final class ZwpTabletPadStripV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_pad_strip_v2"
    public var onEvent: (Event) -> Void = { _ in }

    /// Set Compositor Feedback
    /// 
    /// Requests the compositor to use the provided feedback string
    /// associated with this strip. This request should be issued immediately
    /// after a wp_tablet_pad_group.mode_switch event from the corresponding
    /// group is received, or whenever the strip is mapped to a different
    /// action. See wp_tablet_pad_group.mode_switch for more details.
    /// Clients are encouraged to provide context-aware descriptions for
    /// the actions associated with the strip, and compositors may use this
    /// information to offer visual feedback about the button layout
    /// (eg. on-screen displays).
    /// The provided string 'description' is a UTF-8 encoded string to be
    /// associated with this ring, and is considered user-visible; general
    /// internationalization rules apply.
    /// The serial argument will be that of the last
    /// wp_tablet_pad_group.mode_switch event received for the group of this
    /// strip. Requests providing other serials than the most recent one will be
    /// ignored.
    /// 
    /// - Parameters:
    ///   - Description: strip description
    ///   - Serial: serial of the mode switch event
    public func setFeedback(description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.string(description),
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    /// Destroy The Strip Object
    /// 
    /// This destroys the client's resource for this strip object.
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
    
    /// Strip Axis Source
    /// 
    /// Describes the source types for strip events. This indicates to the
    /// client how a strip event was physically generated; a client may
    /// adjust the user interface accordingly. For example, events
    /// from a "finger" source may trigger kinetic scrolling.
    public enum Source: UInt32, WlEnum {
        /// Finger
        case finger = 1
    }
    
    public enum Event: WlEventEnum {
        /// Strip Event Source
        /// 
        /// Source information for strip events.
        /// This event does not occur on its own. It is sent before a
        /// wp_tablet_pad_strip.frame event and carries the source information
        /// for all events within that frame.
        /// The source specifies how this event was generated. If the source is
        /// wp_tablet_pad_strip.source.finger, a wp_tablet_pad_strip.stop event
        /// will be sent when the user lifts their finger off the device.
        /// This event is optional. If the source is unknown for an interaction,
        /// no event is sent.
        /// 
        /// - Parameters:
        ///   - Source: the event source
        case source(source: UInt32)
        
        /// Position Changed
        /// 
        /// Sent whenever the position on a strip changes.
        /// The position is normalized to a range of [0, 65535], the 0-value
        /// represents the top-most and/or left-most position of the strip in
        /// the pad's current rotation.
        /// 
        /// - Parameters:
        ///   - Position: the current position
        case position(position: UInt32)
        
        /// Interaction Stopped
        /// 
        /// Stop notification for strip events.
        /// For some wp_tablet_pad_strip.source types, a wp_tablet_pad_strip.stop
        /// event is sent to notify a client that the interaction with the strip
        /// has terminated. This enables the client to implement kinetic
        /// scrolling. See the wp_tablet_pad_strip.source documentation for
        /// information on when this event may be generated.
        /// Any wp_tablet_pad_strip.position events with the same source after this
        /// event should be considered as the start of a new interaction.
        case stop
        
        /// End Of A Strip Event Sequence
        /// 
        /// Indicates the end of a set of events that represent one logical
        /// hardware strip event. A client is expected to accumulate the data
        /// in all events within the frame before proceeding.
        /// All wp_tablet_pad_strip events before a wp_tablet_pad_strip.frame event belong
        /// logically together. For example, on termination of a finger interaction
        /// on a strip the compositor will send a wp_tablet_pad_strip.source event,
        /// a wp_tablet_pad_strip.stop event and a wp_tablet_pad_strip.frame
        /// event.
        /// A wp_tablet_pad_strip.frame event is sent for every logical event
        /// group, even if the group only contains a single wp_tablet_pad_strip
        /// event. Specifically, a client may get a sequence: position, frame,
        /// position, frame, etc.
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
                return Self.position(position: r.readUInt())
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
