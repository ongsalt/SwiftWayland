import Foundation
import SwiftWayland

/// Color Representation Extension To A Surface
/// 
/// A wp_color_representation_surface_v1 allows the client to set the color
/// representation metadata of a surface.
/// By default, a surface does not have any color representation metadata set.
/// The reconstruction of R, G, B signals on such surfaces is compositor
/// implementation defined. The alpha mode is assumed to be
/// premultiplied_electrical when the alpha mode is unset.
/// If the wl_surface associated with the wp_color_representation_surface_v1
/// is destroyed, the wp_color_representation_surface_v1 object becomes inert.
public final class WpColorRepresentationSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_representation_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Color Representation
    /// 
    /// Destroy the wp_color_representation_surface_v1 object.
    /// Destroying this object unsets all the color representation metadata from
    /// the surface. See the wp_color_representation_surface_v1 interface
    /// description for how a compositor handles a surface without color
    /// representation metadata. Unsetting is double-buffered state, see
    /// wl_surface.commit.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set The Surface Alpha Mode
    /// 
    /// If this protocol object is inert, the protocol error inert is raised.
    /// Assuming an alpha channel exists, it is always linear. The alpha mode
    /// determines whether and how the color channels include pre-multiplied
    /// alpha. Using straight alpha might have performance benefits.
    /// Only alpha modes advertised by the compositor are allowed to be used as
    /// argument for this request. The "alpha_mode" protocol error is raised
    /// otherwise.
    /// Alpha mode is double buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - AlphaMode: alpha mode
    public func setAlphaMode(alphaMode: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.uint(alphaMode)
        ])
        connection.send(message: message)
    }
    
    /// Set The Matrix Coefficients And Range
    /// 
    /// If this protocol object is inert, the protocol error inert is raised.
    /// Set the matrix coefficients and video range which defines the formula
    /// and the related constants used to derive red, green and blue signals.
    /// Usually coefficients correspond to MatrixCoefficients code points in
    /// H.273.
    /// Only combinations advertised by the compositor are allowed to be used as
    /// argument for this request. The "coefficients" protocol error is raised
    /// otherwise.
    /// A call to wl_surface.commit verifies that the pixel format and the
    /// coefficients-range combination in the committed surface contents are
    /// compatible, if contents exist. The "pixel_format" protocol error is
    /// raised otherwise.
    /// A pixel format is compatible with the coefficients-range combination if
    /// the related equations and conventions as defined in H.273 can produce
    /// the color channels (RGB or YCbCr) of the pixel format.
    /// For the definition of the supported combination, see the
    /// wp_color_representation_surface_v1::coefficients and
    /// wp_color_representation_surface_v1::range enums.
    /// The coefficients-range combination is double-buffered, see
    /// wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - Coefficients: matrix coefficients
    ///   - Range: range
    public func setCoefficientsAndRange(coefficients: UInt32, range: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.uint(coefficients),
            WaylandData.uint(range)
        ])
        connection.send(message: message)
    }
    
    /// Set The Chroma Location
    /// 
    /// If this protocol object is inert, the protocol error inert is raised.
    /// Set the chroma location type which defines the position of downsampled
    /// chroma samples, corresponding to Chroma420SampleLocType code points in
    /// H.273.
    /// An invalid chroma location enum value raises the "chroma_location"
    /// protocol error.
    /// A call to wl_surface.commit verifies that the pixel format and chroma
    /// location type in the committed surface contents are compatible, if
    /// contents exist. The "pixel_format" protocol error is raised otherwise.
    /// For the definition of the supported chroma location types, see the
    /// wp_color_representation_surface_v1::chroma_location enum.
    /// The chroma location type is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - ChromaLocation: chroma sample location
    public func setChromaLocation(chromaLocation: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.uint(chromaLocation)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Protocol Errors
    /// 
    /// 
    public enum Error: UInt32, WlEnum {
        /// Unsupported Alpha Mode
        case alphaMode = 1
        
        /// Unsupported Coefficients
        case coefficients = 2
        
        /// The Pixel Format And A Set Value Are Incompatible
        case pixelFormat = 3
        
        /// Forbidden Request On Inert Object
        case inert = 4
        
        /// Invalid Chroma Location
        case chromaLocation = 5
    }
    
    /// Alpha Mode
    /// 
    /// Specifies how the alpha channel affects the color channels.
    public enum AlphaMode: UInt32, WlEnum {
        case premultipliedElectrical = 0
        
        case premultipliedOptical = 1
        
        case straight = 2
    }
    
    /// Named Coefficients
    /// 
    /// Named matrix coefficients used to encode well-known sets of
    /// coefficients. H.273 is the authority, when it comes to the exact values
    /// of coefficients and authoritative specifications, where an equivalent
    /// code point exists.
    /// A value of 0 is invalid and will never be present in the list of enums.
    /// Descriptions do list the specifications for convenience.
    public enum Coefficients: UInt32, WlEnum {
        case identity = 1
        
        case bt709 = 2
        
        case fcc = 3
        
        case bt601 = 4
        
        case smpte240 = 5
        
        case bt2020 = 6
        
        case bt2020Cl = 7
        
        case ictcp = 8
    }
    
    /// Color Range Values
    /// 
    /// Possible color range values.
    /// A value of 0 is invalid and will never be present in the list of enums.
    public enum Range: UInt32, WlEnum {
        /// Full Color Range
        case full = 1
        
        /// Limited Color Range
        case limited = 2
    }
    
    /// Chroma Sample Location For 4:2:0 Ycbcr
    /// 
    /// Chroma sample location as defined by H.273 Chroma420SampleLocType.
    /// A value of 0 is invalid and will never be present in the list of enums.
    /// The descriptions list the matching Vulkan VkChromaLocation combinations
    /// for convenience.
    public enum ChromaLocation: UInt32, WlEnum {
        case type0 = 1
        
        case type1 = 2
        
        case type2 = 3
        
        case type3 = 4
        
        case type4 = 5
        
        case type5 = 6
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
