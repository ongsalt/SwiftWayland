import Foundation
import SwiftWayland

public final class ZwpLinuxSurfaceSynchronizationV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_linux_surface_synchronization_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func setAcquireFence(fd: FileHandle) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .fd(fd)
        ])
        connection.send(message: message)
    }
    
    public func getRelease() -> ZwpLinuxBufferReleaseV1 {
        let release = connection.createProxy(type: ZwpLinuxBufferReleaseV1.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(release.id)
        ])
        connection.send(message: message)
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
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
