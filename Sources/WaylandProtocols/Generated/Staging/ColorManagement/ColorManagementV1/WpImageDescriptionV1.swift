import Foundation
import SwiftWayland

/// Colorimetric Image Description
/// 
/// An image description carries information about the pixel color encoding
/// and its intended display and viewing environment. The image description is
/// attached to a wl_surface via
/// wp_color_management_surface_v1.set_image_description. A compositor can use
/// this information to decode pixel values into colorimetrically meaningful
/// quantities, which allows the compositor to transform the surface contents
/// to become suitable for various displays and viewing environments.
/// Note, that the wp_image_description_v1 object is not ready to be used
/// immediately after creation. The object eventually delivers either the
/// 'ready' or the 'failed' event, specified in all requests creating it. The
/// object is deemed "ready" after receiving the 'ready' event.
/// An object which is not ready is illegal to use, it can only be destroyed.
/// Any other request in this interface shall result in the 'not_ready'
/// protocol error. Attempts to use an object which is not ready through other
/// interfaces shall raise protocol errors defined there.
/// Once created and regardless of how it was created, a
/// wp_image_description_v1 object always refers to one fixed image
/// description. It cannot change after creation.
public final class WpImageDescriptionV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_image_description_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Image Description
    /// 
    /// Destroy this object. It is safe to destroy an object which is not ready.
    /// Destroying a wp_image_description_v1 object has no side-effects, not
    /// even if a wp_color_management_surface_v1.set_image_description has not
    /// yet been followed by a wl_surface.commit.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Get Information About The Image Description
    /// 
    /// Creates a wp_image_description_info_v1 object which delivers the
    /// information that makes up the image description.
    /// Not all image description protocol objects allow get_information
    /// request. Whether it is allowed or not is defined by the request that
    /// created the object. If get_information is not allowed, the protocol
    /// error no_information is raised.
    public func getInformation() throws(WaylandProxyError) -> WpImageDescriptionInfoV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let information = connection.createProxy(type: WpImageDescriptionInfoV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(information.id)
        ])
        connection.send(message: message)
        return information
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Protocol Errors
    /// 
    /// 
    public enum Error: UInt32, WlEnum {
        /// Attempted To Use An Object Which Is Not Ready
        case notReady = 0
        
        /// Get_Information Not Allowed
        case noInformation = 1
    }
    
    /// Generic Reason For Failure
    /// 
    /// 
    public enum Cause: UInt32, WlEnum {
        /// Interface Version Too Low
        case lowVersion = 0
        
        /// Unsupported Image Description Data
        case unsupported = 1
        
        /// Error Independent Of The Client
        case operatingSystem = 2
        
        /// The Relevant Output No Longer Exists
        case noOutput = 3
    }
    
    public enum Event: WlEventEnum {
        /// Graceful Error On Creating The Image Description
        /// 
        /// If creating a wp_image_description_v1 object fails for a reason that is
        /// not defined as a protocol error, this event is sent.
        /// The requests that create image description objects define whether and
        /// when this can occur. Only such creation requests can trigger this event.
        /// This event cannot be triggered after the image description was
        /// successfully formed.
        /// Once this event has been sent, the wp_image_description_v1 object will
        /// never become ready and it can only be destroyed.
        /// 
        /// - Parameters:
        ///   - Cause: generic reason
        ///   - Msg: ad hoc human-readable explanation
        case failed(cause: UInt32, msg: String)
        
        /// The Object Is Ready To Be Used (32-Bit)
        /// 
        /// Starting from interface version 2, the 'ready2' event is sent instead
        /// of this event.
        /// For the definition of this event, see the 'ready2' event. The
        /// difference to this event is as follows.
        /// The id number is valid only as long as the protocol object is alive. If
        /// all protocol objects referring to the same image description record are
        /// destroyed, the id number may be recycled for a different image
        /// description record.
        /// 
        /// - Parameters:
        ///   - Identity: the 32-bit image description id number
        case ready(identity: UInt32)
        
        /// The Object Is Ready To Be Used
        /// 
        /// Once this event has been sent, the wp_image_description_v1 object is
        /// deemed "ready". Ready objects can be used to send requests and can be
        /// used through other interfaces.
        /// Every ready wp_image_description_v1 protocol object refers to an
        /// underlying image description record in the compositor. Multiple protocol
        /// objects may end up referring to the same record. Clients may identify
        /// these "copies" by comparing their id numbers: if the numbers from two
        /// protocol objects are identical, the protocol objects refer to the same
        /// image description record. Two different image description records
        /// cannot have the same id number simultaneously. The id number does not
        /// change during the lifetime of the image description record.
        /// Image description id number is not a protocol object id. Zero is
        /// reserved as an invalid id number. It shall not be possible for a client
        /// to refer to an image description by its id number in protocol. The id
        /// numbers might not be portable between Wayland connections. A compositor
        /// shall not send an invalid id number.
        /// Compositors must not recycle image description id numbers.
        /// This identity allows clients to de-duplicate image description records
        /// and avoid get_information request if they already have the image
        /// description information.
        /// 
        /// - Parameters:
        ///   - IdentityHi: high 32 bits of the 64-bit image description id number
        ///   - IdentityLo: low 32 bits of the 64-bit image description id number
        /// 
        /// Available since version 2
        case ready2(identityHi: UInt32, identityLo: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.failed(cause: r.readUInt(), msg: r.readString())
            case 1:
                return Self.ready(identity: r.readUInt())
            case 2:
                return Self.ready2(identityHi: r.readUInt(), identityLo: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
