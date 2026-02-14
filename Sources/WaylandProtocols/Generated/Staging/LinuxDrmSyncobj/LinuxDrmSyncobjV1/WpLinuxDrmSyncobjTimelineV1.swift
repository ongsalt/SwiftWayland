import Foundation
import SwiftWayland

/// Synchronization Object Timeline
/// 
/// This object represents an explicit synchronization object timeline
/// imported by the client to the compositor.
public final class WpLinuxDrmSyncobjTimelineV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_linux_drm_syncobj_timeline_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Timeline
    /// 
    /// Destroy the synchronization object timeline. Other objects are not
    /// affected by this request, in particular timeline points set by
    /// set_acquire_point and set_release_point are not unset.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
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
