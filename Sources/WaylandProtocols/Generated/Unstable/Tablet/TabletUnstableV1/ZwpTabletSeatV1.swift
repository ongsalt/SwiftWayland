import Foundation
import SwiftWayland

/// Controller Object For Graphic Tablet Devices Of A Seat
/// 
/// An object that provides access to the graphics tablets available on this
/// seat. After binding to this interface, the compositor sends a set of
/// wp_tablet_seat.tablet_added and wp_tablet_seat.tool_added events.
public final class ZwpTabletSeatV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_seat_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Release The Memory For The Tablet Seat Object
    /// 
    /// Destroy the wp_tablet_seat object. Objects created from this
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
        /// sent through the wp_tablet interface.
        case tabletAdded(id: ZwpTabletV1)
        
        /// A New Tool Has Been Used With A Tablet
        /// 
        /// This event is sent whenever a tool that has not previously been used
        /// with a tablet comes into use. This event only provides the object id
        /// of the tool; any static information about the tool (capabilities,
        /// type, etc.) is sent through the wp_tablet_tool interface.
        case toolAdded(id: ZwpTabletToolV1)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.tabletAdded(id: connection.createProxy(type: ZwpTabletV1.self, version: version, id: r.readNewId()))
            case 1:
                return Self.toolAdded(id: connection.createProxy(type: ZwpTabletToolV1.self, version: version, id: r.readNewId()))
            default:
                fatalError("Unknown message")
            }
        }
    }
}
