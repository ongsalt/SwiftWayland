import Foundation
import SwiftWayland

public final class ExtOutputImageCaptureSourceManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_output_image_capture_source_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func createSource(output: WlOutput) throws(WaylandProxyError)  -> ExtImageCaptureSourceV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let source = connection.createProxy(type: ExtImageCaptureSourceV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(source.id),
            .object(output)
        ])
        connection.send(message: message)
        return source
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
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
