import Foundation
import SwiftWayland

public final class WpLinuxDrmSyncobjSurfaceV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setAcquirePoint(timeline: WpLinuxDrmSyncobjTimelineV1, pointHi: UInt32, pointLo: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(timeline),
            .uint(pointHi),
            .uint(pointLo)
        ])
        connection.queueSend(message: message)
    }
    
    public func setReleasePoint(timeline: WpLinuxDrmSyncobjTimelineV1, pointHi: UInt32, pointLo: UInt32) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(timeline),
            .uint(pointHi),
            .uint(pointLo)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case noSurface = 1
        case unsupportedBuffer = 2
        case noBuffer = 3
        case noAcquirePoint = 4
        case noReleasePoint = 5
        case conflictingPoints = 6
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
