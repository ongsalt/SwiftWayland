import Foundation
import SwiftWayland

/// Holder Of Image Description Icc Information
/// 
/// This type of object is used for collecting all the information required
/// to create a wp_image_description_v1 object from an ICC file. A complete
/// set of required parameters consists of these properties:
/// - ICC file
/// Each required property must be set exactly once if the client is to create
/// an image description. The set requests verify that a property was not
/// already set. The create request verifies that all required properties are
/// set. There may be several alternative requests for setting each property,
/// and in that case the client must choose one of them.
/// Once all properties have been set, the create request must be used to
/// create the image description object, destroying the creator in the
/// process.
/// The link between a pixel value (a device value in ICC) and its respective
/// colorimetry is defined by the details of the particular ICC profile.
/// Those details also determine when colorimetry becomes undefined.
public final class WpImageDescriptionCreatorIccV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_image_description_creator_icc_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create The Image Description Object From Icc Data
    /// 
    /// Create an image description object based on the ICC information
    /// previously set on this object. A compositor must parse the ICC data in
    /// some undefined but finite amount of time.
    /// The completeness of the parameter set is verified. If the set is not
    /// complete, the protocol error incomplete_set is raised. For the
    /// definition of a complete set, see the description of this interface.
    /// If the particular combination of the information is not supported
    /// by the compositor, the resulting image description object shall
    /// immediately deliver the wp_image_description_v1.failed event with the
    /// 'unsupported' cause. If a valid image description was created from the
    /// information, the wp_image_description_v1.ready event will eventually
    /// be sent instead.
    /// This request destroys the wp_image_description_creator_icc_v1 object.
    /// The resulting image description object does not allow get_information
    /// request.
    public consuming func create() throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(imageDescription.id)
        ])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
        return imageDescription
    }
    
    /// Set The Icc Profile File
    /// 
    /// Sets the ICC profile file to be used as the basis of the image
    /// description.
    /// The data shall be found through the given fd at the given offset, having
    /// the given length. The fd must be seekable and readable. Violating these
    /// requirements raises the bad_fd protocol error.
    /// If reading the data fails due to an error independent of the client, the
    /// compositor shall send the wp_image_description_v1.failed event on the
    /// created wp_image_description_v1 with the 'operating_system' cause.
    /// The maximum size of the ICC profile is 32 MB. If length is greater than
    /// that or zero, the protocol error bad_size is raised. If offset + length
    /// exceeds the file size, the protocol error out_of_file is raised.
    /// A compositor may read the file at any time starting from this request
    /// and only until whichever happens first:
    /// - If create request was issued, the wp_image_description_v1 object
    /// delivers either failed or ready event; or
    /// - if create request was not issued, this
    /// wp_image_description_creator_icc_v1 object is destroyed.
    /// A compositor shall not modify the contents of the file, and the fd may
    /// be sealed for writes and size changes. The client must ensure to its
    /// best ability that the data does not change while the compositor is
    /// reading it.
    /// The data must represent a valid ICC profile. The ICC profile version
    /// must be 2 or 4, it must be a 3 channel profile and the class must be
    /// Display or ColorSpace. Violating these requirements will not result in a
    /// protocol error, but will eventually send the
    /// wp_image_description_v1.failed event on the created
    /// wp_image_description_v1 with the 'unsupported' cause.
    /// See the International Color Consortium specification ICC.1:2022 for more
    /// details about ICC profiles.
    /// If ICC file has already been set on this object, the protocol error
    /// already_set is raised.
    /// 
    /// - Parameters:
    ///   - IccProfile: ICC profile
    ///   - Offset: byte offset in fd to start of ICC data
    ///   - Length: length of ICC data in bytes
    public func setIccFile(iccProfile: FileHandle, offset: UInt32, length: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.fd(iccProfile),
            WaylandData.uint(offset),
            WaylandData.uint(length)
        ])
        connection.send(message: message)
    }
    
    /// Protocol Errors
    /// 
    /// 
    public enum Error: UInt32, WlEnum {
        /// Incomplete Parameter Set
        case incompleteSet = 0
        
        /// Property Already Set
        case alreadySet = 1
        
        /// Fd Not Seekable And Readable
        case badFd = 2
        
        /// No Or Too Much Data
        case badSize = 3
        
        /// Offset + Length Exceeds File Size
        case outOfFile = 4
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
