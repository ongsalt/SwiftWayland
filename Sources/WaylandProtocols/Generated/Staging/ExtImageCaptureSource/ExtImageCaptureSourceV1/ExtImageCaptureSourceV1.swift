import Foundation
import SwiftWayland

/// Opaque Image Capture Source Object
/// 
/// The image capture source object is an opaque descriptor for a capturable
/// resource.  This resource may be any sort of entity from which an image
/// may be derived.
/// Note, because ext_image_capture_source_v1 objects are created from multiple
/// independent factory interfaces, the ext_image_capture_source_v1 interface is
/// frozen at version 1.
public final class ExtImageCaptureSourceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_image_capture_source_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Delete This Object
    /// 
    /// Destroys the image capture source. This request may be sent at any time
    /// by the client.
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
