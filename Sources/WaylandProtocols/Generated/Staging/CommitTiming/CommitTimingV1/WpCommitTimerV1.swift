import Foundation
import SwiftWayland

public final class WpCommitTimerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_commit_timer_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func setTimestamp(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .uint(tvSecHi),
            .uint(tvSecLo),
            .uint(tvNsec)
        ])
        connection.queueSend(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidTimestamp = 0
        case timestampExists = 1
        case surfaceDestroyed = 2
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
