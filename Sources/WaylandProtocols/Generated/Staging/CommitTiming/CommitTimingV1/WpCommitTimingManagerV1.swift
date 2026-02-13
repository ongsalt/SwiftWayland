import Foundation
import SwiftWayland

public final class WpCommitTimingManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_commit_timing_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func getTimer(surface: WlSurface) -> WpCommitTimerV1 {
        let id = connection.createProxy(type: WpCommitTimerV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case commitTimerExists = 0
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
