import Foundation
import SwiftWayland

/// Color Management Extension To A Surface
/// 
/// A wp_color_management_surface_v1 allows the client to set the color
/// space and HDR properties of a surface.
/// If the wl_surface associated with the wp_color_management_surface_v1 is
/// destroyed, the wp_color_management_surface_v1 object becomes inert.
public final class WpColorManagementSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_management_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Color Management Interface For A Surface
    /// 
    /// Destroy the wp_color_management_surface_v1 object and do the same as
    /// unset_image_description.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set The Surface Image Description
    /// 
    /// If this protocol object is inert, the protocol error inert is raised.
    /// Set the image description of the underlying surface. The image
    /// description and rendering intent are double-buffered state, see
    /// wl_surface.commit.
    /// It is the client's responsibility to understand the image description
    /// it sets on a surface, and to provide content that matches that image
    /// description. Compositors might convert images to match their own or any
    /// other image descriptions.
    /// Image descriptions which are not ready (see wp_image_description_v1)
    /// are forbidden in this request, and in such case the protocol error
    /// image_description is raised.
    /// All image descriptions which are ready (see wp_image_description_v1)
    /// are allowed and must always be accepted by the compositor.
    /// When an image description is set on a surface, it establishes an
    /// explicit link between surface pixel values and surface colorimetry.
    /// This link may be undefined for some pixel values, see the image
    /// description creator interfaces for the conditions. Non-finite
    /// floating-point values (NaN, Inf) always have an undefined colorimetry.
    /// A rendering intent provides the client's preference on how surface
    /// colorimetry should be mapped to each output. The render_intent value
    /// must be one advertised by the compositor with
    /// wp_color_manager_v1.render_intent event, otherwise the protocol error
    /// render_intent is raised.
    /// By default, a surface does not have an associated image description
    /// nor a rendering intent. The handling of color on such surfaces is
    /// compositor implementation defined. Compositors should handle such
    /// surfaces as sRGB, but may handle them differently if they have specific
    /// requirements.
    /// Setting the image description has copy semantics; after this request,
    /// the image description can be immediately destroyed without affecting
    /// the pending state of the surface.
    /// 
    /// - Parameters:
    ///   - RenderIntent: rendering intent
    public func setImageDescription(imageDescription: WpImageDescriptionV1, renderIntent: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(imageDescription),
            WaylandData.uint(renderIntent)
        ])
        connection.send(message: message)
    }
    
    /// Remove The Surface Image Description
    /// 
    /// If this protocol object is inert, the protocol error inert is raised.
    /// This request removes any image description from the surface. See
    /// set_image_description for how a compositor handles a surface without
    /// an image description. This is double-buffered state, see
    /// wl_surface.commit.
    public func unsetImageDescription() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Protocol Errors
    /// 
    /// 
    public enum Error: UInt32, WlEnum {
        /// Unsupported Rendering Intent
        case renderIntent = 0
        
        /// Invalid Image Description
        case imageDescription = 1
        
        /// Forbidden Request On Inert Object
        case inert = 2
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
