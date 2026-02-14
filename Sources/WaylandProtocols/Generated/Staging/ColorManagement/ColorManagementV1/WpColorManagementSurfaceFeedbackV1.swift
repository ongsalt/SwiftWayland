import Foundation
import SwiftWayland

/// Color Management Extension To A Surface
/// 
/// A wp_color_management_surface_feedback_v1 allows the client to get the
/// preferred image description of a surface.
/// If the wl_surface associated with this object is destroyed, the
/// wp_color_management_surface_feedback_v1 object becomes inert.
public final class WpColorManagementSurfaceFeedbackV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_management_surface_feedback_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Color Management Interface For A Surface
    /// 
    /// Destroy the wp_color_management_surface_feedback_v1 object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Get The Preferred Image Description
    /// 
    /// If this protocol object is inert, the protocol error inert is raised.
    /// The preferred image description represents the compositor's preferred
    /// color encoding for this wl_surface at the current time. There might be
    /// performance and power advantages, as well as improved color
    /// reproduction, if the image description of a content update matches the
    /// preferred image description.
    /// This creates a new wp_image_description_v1 object for the currently
    /// preferred image description for the wl_surface. The client should
    /// stop using and destroy the image descriptions created by earlier
    /// invocations of this request for the associated wl_surface.
    /// This request is usually sent as a reaction to the preferred_changed
    /// event or when creating a wp_color_management_surface_feedback_v1 object
    /// if the client is capable of adapting to image descriptions.
    /// The created wp_image_description_v1 object preserves the preferred image
    /// description of the wl_surface from the time the object was created.
    /// The resulting image description object allows get_information request.
    /// If the image description is parametric, the client should set it on its
    /// wl_surface only if the image description is an exact match with the
    /// client content. Particularly if everything else matches, but the target
    /// color volume is greater than what the client needs, the client should
    /// create its own parameric image description with its exact parameters.
    /// If the interface version is inadequate for the preferred image
    /// description, meaning that the client does not support all the
    /// events needed to deliver the crucial information, the resulting image
    /// description object shall immediately deliver the
    /// wp_image_description_v1.failed event with the low_version cause,
    /// otherwise the object shall immediately deliver the ready event.
    public func getPreferred() throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(imageDescription.id)
        ])
        connection.send(message: message)
        return imageDescription
    }
    
    /// Get The Preferred Image Description
    /// 
    /// The same description as for get_preferred applies, except the returned
    /// image description is guaranteed to be parametric. This is meant for
    /// clients that can only deal with parametric image descriptions.
    /// If the compositor doesn't support parametric image descriptions, the
    /// unsupported_feature error is emitted.
    public func getPreferredParametric() throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.newId(imageDescription.id)
        ])
        connection.send(message: message)
        return imageDescription
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Protocol Errors
    /// 
    /// 
    public enum Error: UInt32, WlEnum {
        /// Forbidden Request On Inert Object
        case inert = 0
        
        /// Attempted To Use An Unsupported Feature
        case unsupportedFeature = 1
    }
    
    public enum Event: WlEventEnum {
        /// The Preferred Image Description Changed (32-Bit)
        /// 
        /// Starting from interface version 2, 'preferred_changed2' is sent instead
        /// of this event. See the 'preferred_changed2' event for the definition.
        /// 
        /// - Parameters:
        ///   - Identity: the 32-bit image description id number
        case preferredChanged(identity: UInt32)
        
        /// The Preferred Image Description Changed
        /// 
        /// The preferred image description is the one which likely has the most
        /// performance and/or quality benefits for the compositor if used by the
        /// client for its wl_surface contents. This event is sent whenever the
        /// compositor changes the wl_surface's preferred image description.
        /// This event sends the identity of the new preferred state as the argument,
        /// so clients who are aware of the image description already can reuse it.
        /// Otherwise, if the client client wants to know what the preferred image
        /// description is, it shall use the get_preferred request.
        /// The preferred image description is not automatically used for anything.
        /// It is only a hint, and clients may set any valid image description with
        /// set_image_description, but there might be performance and color accuracy
        /// improvements by providing the wl_surface contents in the preferred
        /// image description. Therefore clients that can, should render according
        /// to the preferred image description
        /// 
        /// - Parameters:
        ///   - IdentityHi: high 32 bits of the 64-bit image description id number
        ///   - IdentityLo: low 32 bits of the 64-bit image description id number
        /// 
        /// Available since version 2
        case preferredChanged2(identityHi: UInt32, identityLo: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.preferredChanged(identity: r.readUInt())
            case 1:
                return Self.preferredChanged2(identityHi: r.readUInt(), identityLo: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
