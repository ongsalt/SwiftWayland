import Foundation

/// Pad Dial
/// 
/// A rotary control, e.g. a dial or a wheel.
/// Events on a dial are logically grouped by the zwp_tablet_pad_dial_v2.frame
/// event.
public final class ZwpTabletPadDialV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_pad_dial_v2"
    public var onEvent: (Event) -> Void = { _ in }

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
    ///   - Description: dial description
    ///   - Serial: serial of the mode switch event
    public func setFeedback(description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.string(description),
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    /// Destroy The Dial Object
    /// 
    /// This destroys the client's resource for this dial object.
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
    
    public enum Event: WlEventEnum {
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
        /// 
        /// - Parameters:
        ///   - Value120: rotation distance as fraction of 120
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
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        case frame(time: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.delta(value120: r.readInt())
            case 1:
                return Self.frame(time: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
