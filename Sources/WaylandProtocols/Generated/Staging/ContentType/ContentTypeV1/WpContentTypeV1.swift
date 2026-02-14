import Foundation
import SwiftWayland

/// Content Type Object For A Surface
/// 
/// The content type object allows the compositor to optimize for the kind
/// of content shown on the surface. A compositor may for example use it to
/// set relevant drm properties like "content type".
/// The client may request to switch to another content type at any time.
/// When the associated surface gets destroyed, this object becomes inert and
/// the client should destroy it.
public final class WpContentTypeV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_content_type_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Content Type Object
    /// 
    /// Switch back to not specifying the content type of this surface. This is
    /// equivalent to setting the content type to none, including double
    /// buffering semantics. See set_content_type for details.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Specify The Content Type
    /// 
    /// Set the surface content type. This informs the compositor that the
    /// client believes it is displaying buffers matching this content type.
    /// This is purely a hint for the compositor, which can be used to adjust
    /// its behavior or hardware settings to fit the presented content best.
    /// The content type is double-buffered state, see wl_surface.commit for
    /// details.
    /// 
    /// - Parameters:
    ///   - ContentType: the content type
    public func setContentType(contentType: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.uint(contentType)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Possible Content Types
    /// 
    /// These values describe the available content types for a surface.
    public enum `Type`: UInt32, WlEnum {
        case `none` = 0
        
        case photo = 1
        
        case video = 2
        
        case game = 3
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
