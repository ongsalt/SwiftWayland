import Foundation
import SwiftWayland

/// Output Color Properties
/// 
/// A wp_color_management_output_v1 describes the color properties of an
/// output.
/// The wp_color_management_output_v1 is associated with the wl_output global
/// underlying the wl_output object. Therefore the client destroying the
/// wl_output object has no impact, but the compositor removing the output
/// global makes the wp_color_management_output_v1 object inert.
public final class WpColorManagementOutputV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_management_output_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Color Management Output
    /// 
    /// Destroy the color wp_color_management_output_v1 object. This does not
    /// affect any remaining protocol objects.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Get The Image Description Of The Output
    /// 
    /// This creates a new wp_image_description_v1 object for the current image
    /// description of the output. There always is exactly one image description
    /// active for an output so the client should destroy the image description
    /// created by earlier invocations of this request. This request is usually
    /// sent as a reaction to the image_description_changed event or when
    /// creating a wp_color_management_output_v1 object.
    /// The image description of an output represents the color encoding the
    /// output expects. There might be performance and power advantages, as well
    /// as improved color reproduction, if a content update matches the image
    /// description of the output it is being shown on. If a content update is
    /// shown on any other output than the one it matches the image description
    /// of, then the color reproduction on those outputs might be considerably
    /// worse.
    /// The created wp_image_description_v1 object preserves the image
    /// description of the output from the time the object was created.
    /// The resulting image description object allows get_information request.
    /// If this protocol object is inert, the resulting image description object
    /// shall immediately deliver the wp_image_description_v1.failed event with
    /// the no_output cause.
    /// If the interface version is inadequate for the output's image
    /// description, meaning that the client does not support all the events
    /// needed to deliver the crucial information, the resulting image
    /// description object shall immediately deliver the
    /// wp_image_description_v1.failed event with the low_version cause.
    /// Otherwise the object shall immediately deliver the ready event.
    public func getImageDescription() throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(imageDescription.id)
        ])
        connection.send(message: message)
        return imageDescription
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// Image Description Changed
        /// 
        /// This event is sent whenever the image description of the output changed,
        /// followed by one wl_output.done event common to output events across all
        /// extensions.
        /// If the client wants to use the updated image description, it needs to do
        /// get_image_description again, because image description objects are
        /// immutable.
        case imageDescriptionChanged
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.imageDescriptionChanged
            default:
                fatalError("Unknown message")
            }
        }
    }
}
