import Foundation
import SwiftWayland

public final class WpLinuxDrmSyncobjSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_linux_drm_syncobj_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func setAcquirePoint(timeline: WpLinuxDrmSyncobjTimelineV1, pointHi: UInt32, pointLo: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(timeline),
            .uint(pointHi),
            .uint(pointLo)
        ])
        connection.send(message: message)
    }
    
    public func setReleasePoint(timeline: WpLinuxDrmSyncobjTimelineV1, pointHi: UInt32, pointLo: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(timeline),
            .uint(pointHi),
            .uint(pointLo)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
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
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
