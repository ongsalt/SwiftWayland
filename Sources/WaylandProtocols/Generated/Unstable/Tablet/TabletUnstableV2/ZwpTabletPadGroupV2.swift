import Foundation
import SwiftWayland

/// A Set Of Buttons, Rings And Strips
/// 
/// A pad group describes a distinct (sub)set of buttons, rings and strips
/// present in the tablet. The criteria of this grouping is usually positional,
/// eg. if a tablet has buttons on the left and right side, 2 groups will be
/// presented. The physical arrangement of groups is undisclosed and may
/// change on the fly.
/// Pad groups will announce their features during pad initialization. Between
/// the corresponding wp_tablet_pad.group event and wp_tablet_pad_group.done, the
/// pad group will announce the buttons, rings and strips contained in it,
/// plus the number of supported modes.
/// Modes are a mechanism to allow multiple groups of actions for every element
/// in the pad group. The number of groups and available modes in each is
/// persistent across device plugs. The current mode is user-switchable, it
/// will be announced through the wp_tablet_pad_group.mode_switch event both
/// whenever it is switched, and after wp_tablet_pad.enter.
/// The current mode logically applies to all elements in the pad group,
/// although it is at clients' discretion whether to actually perform different
/// actions, and/or issue the respective .set_feedback requests to notify the
/// compositor. See the wp_tablet_pad_group.mode_switch event for more details.
public final class ZwpTabletPadGroupV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_pad_group_v2"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Pad Object
    /// 
    /// Destroy the wp_tablet_pad_group object. Objects created from this object
    /// are unaffected and should be destroyed separately.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// Buttons Announced
        /// 
        /// Sent on wp_tablet_pad_group initialization to announce the available
        /// buttons in the group. Button indices start at 0, a button may only be
        /// in one group at a time.
        /// This event is first sent in the initial burst of events before the
        /// wp_tablet_pad_group.done event.
        /// Some buttons are reserved by the compositor. These buttons may not be
        /// assigned to any wp_tablet_pad_group. Compositors may broadcast this
        /// event in the case of changes to the mapping of these reserved buttons.
        /// If the compositor happens to reserve all buttons in a group, this event
        /// will be sent with an empty array.
        /// 
        /// - Parameters:
        ///   - Buttons: buttons in this group
        case buttons(buttons: Data)
        
        /// Ring Announced
        /// 
        /// Sent on wp_tablet_pad_group initialization to announce available rings.
        /// One event is sent for each ring available on this pad group.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_pad_group.done event.
        case ring(ring: ZwpTabletPadRingV2)
        
        /// Strip Announced
        /// 
        /// Sent on wp_tablet_pad initialization to announce available strips.
        /// One event is sent for each strip available on this pad group.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_pad_group.done event.
        case strip(strip: ZwpTabletPadStripV2)
        
        /// Mode-Switch Ability Announced
        /// 
        /// Sent on wp_tablet_pad_group initialization to announce that the pad
        /// group may switch between modes. A client may use a mode to store a
        /// specific configuration for buttons, rings and strips and use the
        /// wl_tablet_pad_group.mode_switch event to toggle between these
        /// configurations. Mode indices start at 0.
        /// Switching modes is compositor-dependent. See the
        /// wp_tablet_pad_group.mode_switch event for more details.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_pad_group.done event. This event is only sent when more than
        /// more than one mode is available.
        /// 
        /// - Parameters:
        ///   - Modes: the number of modes
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
        /// A mode applies to all buttons, rings and strips in a group
        /// simultaneously, but a client is not required to assign different actions
        /// for each mode. For example, a client may have mode-specific button
        /// mappings but map the ring to vertical scrolling in all modes. Mode
        /// indices start at 0.
        /// Switching modes is compositor-dependent. The compositor may provide
        /// visual cues to the client about the mode, e.g. by toggling LEDs on
        /// the tablet device. Mode-switching may be software-controlled or
        /// controlled by one or more physical buttons. For example, on a Wacom
        /// Intuos Pro, the button inside the ring may be assigned to switch
        /// between modes.
        /// The compositor will also send this event after wp_tablet_pad.enter on
        /// each group in order to notify of the current mode. Groups that only
        /// feature one mode will use mode=0 when emitting this event.
        /// If a button action in the new mode differs from the action in the
        /// previous mode, the client should immediately issue a
        /// wp_tablet_pad.set_feedback request for each changed button.
        /// If a ring or strip action in the new mode differs from the action
        /// in the previous mode, the client should immediately issue a
        /// wp_tablet_ring.set_feedback or wp_tablet_strip.set_feedback request
        /// for each changed ring or strip.
        /// 
        /// - Parameters:
        ///   - Time: the time of the event with millisecond granularity
        ///   - Mode: the new mode of the pad
        case modeSwitch(time: UInt32, serial: UInt32, mode: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.buttons(buttons: r.readArray())
            case 1:
                return Self.ring(ring: connection.createProxy(type: ZwpTabletPadRingV2.self, version: version, id: r.readNewId()))
            case 2:
                return Self.strip(strip: connection.createProxy(type: ZwpTabletPadStripV2.self, version: version, id: r.readNewId()))
            case 3:
                return Self.modes(modes: r.readUInt())
            case 4:
                return Self.done
            case 5:
                return Self.modeSwitch(time: r.readUInt(), serial: r.readUInt(), mode: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
