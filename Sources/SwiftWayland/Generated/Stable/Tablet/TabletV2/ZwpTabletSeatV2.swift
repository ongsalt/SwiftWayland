import Foundation

/// Controller Object For Graphic Tablet Devices Of A Seat
/// 
/// An object that provides access to the graphics tablets available on this
/// seat. After binding to this interface, the compositor sends a set of
/// zwp_tablet_seat_v2.tablet_added and zwp_tablet_seat_v2.tool_added events.
public final class ZwpTabletSeatV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_seat_v2"
    public var onEvent: (Event) -> Void = { _ in }

    /// Release The Memory For The Tablet Seat Object
    /// 
    /// Destroy the zwp_tablet_seat_v2 object. Objects created from this
    /// object are unaffected and should be destroyed separately.
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
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.tabletAdded(id: connection.createProxy(type: ZwpTabletV2.self, version: version, id: r.readNewId()))
            case 1:
                return Self.toolAdded(id: connection.createProxy(type: ZwpTabletToolV2.self, version: version, id: r.readNewId()))
            case 2:
                return Self.padAdded(id: connection.createProxy(type: ZwpTabletPadV2.self, version: version, id: r.readNewId()))
            default:
                fatalError("Unknown message")
            }
        }
    }
}
