import Foundation
import SwiftWayland

public final class ZwpTabletManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func getTabletSeat(seat: WlSeat) -> ZwpTabletSeatV1 {
        let tabletSeat = connection.createProxy(type: ZwpTabletSeatV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(tabletSeat.id),
            .object(seat)
        ])
        connection.queueSend(message: message)
        return tabletSeat
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
