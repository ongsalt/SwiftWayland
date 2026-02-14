import Foundation

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
public final class ZwpTabletPadV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_pad_v2"
    public var onEvent: (Event) -> Void = { _ in }

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
    ///   - Button: button index
    ///   - Description: button description
    ///   - Serial: serial of the mode switch event
    public func setFeedback(button: UInt32, description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.uint(button),
            WaylandData.string(description),
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    /// Destroy The Pad Object
    /// 
    /// Destroy the zwp_tablet_pad_v2 object. Objects created from this object
    /// are unaffected and should be destroyed separately.
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
    
    /// Physical Button State
    /// 
    /// Describes the physical state of a button that caused the button
    /// event.
    public enum ButtonState: UInt32, WlEnum {
        /// The Button Is Not Pressed
        case released = 0
        
        /// The Button Is Pressed
        case pressed = 1
    }
    
    public enum Event: WlEventEnum {
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
        /// 
        /// - Parameters:
        ///   - Path: path to local device
        case path(path: String)
        
        /// Buttons Announced
        /// 
        /// Sent on zwp_tablet_pad_v2 initialization to announce the available
        /// buttons.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_v2.done event. This event is only sent when at least one
        /// button is available.
        /// 
        /// - Parameters:
        ///   - Buttons: the number of buttons
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
        /// 
        /// - Parameters:
        ///   - Time: the time of the event with millisecond granularity
        ///   - Button: the index of the button that changed state
        case button(time: UInt32, button: UInt32, state: UInt32)
        
        /// Enter Event
        /// 
        /// Notification that this pad is focused on the specified surface.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the enter event
        ///   - Tablet: the tablet the pad is attached to
        ///   - Surface: surface the pad is focused on
        case enter(serial: UInt32, tablet: ZwpTabletV2, surface: WlSurface)
        
        /// Leave Event
        /// 
        /// Notification that this pad is no longer focused on the specified
        /// surface.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the leave event
        ///   - Surface: surface the pad is no longer focused on
        case leave(serial: UInt32, surface: WlSurface)
        
        /// Pad Removed Event
        /// 
        /// Sent when the pad has been removed from the system. When a tablet
        /// is removed its pad(s) will be removed too.
        /// When this event is received, the client must destroy all rings, strips
        /// and groups that were offered by this pad, and issue zwp_tablet_pad_v2.destroy
        /// the pad itself.
        case removed
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.group(padGroup: connection.createProxy(type: ZwpTabletPadGroupV2.self, version: version, id: r.readNewId()))
            case 1:
                return Self.path(path: r.readString())
            case 2:
                return Self.buttons(buttons: r.readUInt())
            case 3:
                return Self.done
            case 4:
                return Self.button(time: r.readUInt(), button: r.readUInt(), state: r.readUInt())
            case 5:
                return Self.enter(serial: r.readUInt(), tablet: connection.get(as: ZwpTabletV2.self, id: r.readObjectId())!, surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 6:
                return Self.leave(serial: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 7:
                return Self.removed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
