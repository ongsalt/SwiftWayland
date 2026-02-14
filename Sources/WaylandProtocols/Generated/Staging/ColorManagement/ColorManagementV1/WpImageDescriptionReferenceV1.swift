import Foundation
import SwiftWayland

/// Reference To An Image Description
/// 
/// This object is a reference to an image description. This interface is
/// frozen at version 1 to allow other protocols to create
/// wp_image_description_v1 objects.
/// The wp_color_manager_v1.get_image_description request can be used to
/// retrieve the underlying image description.
public final class WpImageDescriptionReferenceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_image_description_reference_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Reference
    /// 
    /// Destroy this object. This has no effect on the referenced image
    /// description.
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
