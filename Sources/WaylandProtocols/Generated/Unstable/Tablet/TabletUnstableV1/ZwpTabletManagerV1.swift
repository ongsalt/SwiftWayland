import Foundation
import SwiftWayland

/// Controller Object For Graphic Tablet Devices
/// 
/// An object that provides access to the graphics tablets available on this
/// system. All tablets are associated with a seat, to get access to the
/// actual tablets, use wp_tablet_manager.get_tablet_seat.
public final class ZwpTabletManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Get The Tablet Seat
    /// 
    /// Get the wp_tablet_seat object for the given seat. This object
    /// provides access to all graphics tablets in this seat.
    /// 
    /// - Parameters:
    ///   - Seat: The wl_seat object to retrieve the tablets for
    public func getTabletSeat(seat: WlSeat) throws(WaylandProxyError) -> ZwpTabletSeatV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let tabletSeat = connection.createProxy(type: ZwpTabletSeatV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(tabletSeat.id),
            WaylandData.object(seat)
        ])
        connection.send(message: message)
        return tabletSeat
    }
    
    /// Release The Memory For The Tablet Manager Object
    /// 
    /// Destroy the wp_tablet_manager object. Objects created from this
    /// object are unaffected and should be destroyed separately.
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
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
