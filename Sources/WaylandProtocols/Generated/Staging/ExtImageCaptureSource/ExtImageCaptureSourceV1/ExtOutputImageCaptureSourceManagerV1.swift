import Foundation
import SwiftWayland

/// Image Capture Source Manager For Outputs
/// 
/// A manager for creating image capture source objects for wl_output objects.
public final class ExtOutputImageCaptureSourceManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_output_image_capture_source_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create Source Object For Output
    /// 
    /// Creates a source object for an output. Images captured from this source
    /// will show the same content as the output. Some elements may be omitted,
    /// such as cursors and overlays that have been marked as transparent to
    /// capturing.
    public func createSource(output: WlOutput) throws(WaylandProxyError) -> ExtImageCaptureSourceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let source = connection.createProxy(type: ExtImageCaptureSourceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(source.id),
            WaylandData.object(output)
        ])
        connection.send(message: message)
        return source
    }
    
    /// Delete This Object
    /// 
    /// Destroys the manager. This request may be sent at any time by the client
    /// and objects created by the manager will remain valid after its
    /// destruction.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
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
