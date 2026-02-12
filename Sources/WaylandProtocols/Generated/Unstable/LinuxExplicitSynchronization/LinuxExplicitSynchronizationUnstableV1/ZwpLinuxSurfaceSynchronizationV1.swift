import Foundation
import SwiftWayland

public final class ZwpLinuxSurfaceSynchronizationV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setAcquireFence(fd: FileHandle) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .fd(fd)
        ])
        connection.queueSend(message: message)
    }
    
    public func getRelease() -> ZwpLinuxBufferReleaseV1 {
        let release = connection.createProxy(type: ZwpLinuxBufferReleaseV1.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(release.id)
        ])
        connection.queueSend(message: message)
        return release
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidFence = 0
        case duplicateFence = 1
        case duplicateRelease = 2
        case noSurface = 3
        case unsupportedBuffer = 4
        case noBuffer = 5
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
