import Foundation
import SwiftWayland

public final class ZwpTabletManagerV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_manager_v2"
    public var onEvent: (Event) -> Void = { _ in }

    public func getTabletSeat(seat: WlSeat) throws(WaylandProxyError) -> ZwpTabletSeatV2 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let tabletSeat = connection.createProxy(type: ZwpTabletSeatV2.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(tabletSeat.id),
            .object(seat)
        ])
        connection.send(message: message)
        return tabletSeat
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
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
