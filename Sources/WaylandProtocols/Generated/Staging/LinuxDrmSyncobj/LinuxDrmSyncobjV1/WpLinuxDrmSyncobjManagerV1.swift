import Foundation
import SwiftWayland

public final class WpLinuxDrmSyncobjManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_linux_drm_syncobj_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func getSurface(surface: WlSurface) -> WpLinuxDrmSyncobjSurfaceV1 {
        let id = connection.createProxy(type: WpLinuxDrmSyncobjSurfaceV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    public func importTimeline(fd: FileHandle) -> WpLinuxDrmSyncobjTimelineV1 {
        let id = connection.createProxy(type: WpLinuxDrmSyncobjTimelineV1.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id),
            .fd(fd)
        ])
        connection.send(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case surfaceExists = 0
        case invalidTimeline = 1
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
