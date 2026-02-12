import Foundation
import SwiftWayland

public final class ZwpTabletManagerV2: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func getTabletSeat(seat: WlSeat) -> ZwpTabletSeatV2 {
        let tabletSeat = connection.createProxy(type: ZwpTabletSeatV2.self)
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
