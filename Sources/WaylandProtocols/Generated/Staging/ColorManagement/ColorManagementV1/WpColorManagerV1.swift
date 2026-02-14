import Foundation
import SwiftWayland

/// Color Manager Singleton
/// 
/// A singleton global interface used for getting color management extensions
/// for wl_surface and wl_output objects, and for creating client defined
/// image description objects. The extension interfaces allow
/// getting the image description of outputs and setting the image
/// description of surfaces.
/// Compositors should never remove this global.
public final class WpColorManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Color Manager
    /// 
    /// Destroy the wp_color_manager_v1 object. This does not affect any other
    /// objects in any way.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A Color Management Interface For A Wl_Output
    /// 
    /// This creates a new wp_color_management_output_v1 object for the
    /// given wl_output.
    /// See the wp_color_management_output_v1 interface for more details.
    public func getOutput(output: WlOutput) throws(WaylandProxyError) -> WpColorManagementOutputV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpColorManagementOutputV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(output)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Create A Color Management Interface For A Wl_Surface
    /// 
    /// If a wp_color_management_surface_v1 object already exists for the given
    /// wl_surface, the protocol error surface_exists is raised.
    /// This creates a new color wp_color_management_surface_v1 object for the
    /// given wl_surface.
    /// See the wp_color_management_surface_v1 interface for more details.
    public func getSurface(surface: WlSurface) throws(WaylandProxyError) -> WpColorManagementSurfaceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpColorManagementSurfaceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Create A Color Management Feedback Interface
    /// 
    /// This creates a new color wp_color_management_surface_feedback_v1 object
    /// for the given wl_surface.
    /// See the wp_color_management_surface_feedback_v1 interface for more
    /// details.
    public func getSurfaceFeedback(surface: WlSurface) throws(WaylandProxyError) -> WpColorManagementSurfaceFeedbackV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpColorManagementSurfaceFeedbackV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Make A New Icc-Based Image Description Creator Object
    /// 
    /// Makes a new ICC-based image description creator object with all
    /// properties initially unset. The client can then use the object's
    /// interface to define all the required properties for an image description
    /// and finally create a wp_image_description_v1 object.
    /// This request can be used when the compositor advertises
    /// wp_color_manager_v1.feature.icc_v2_v4.
    /// Otherwise this request raises the protocol error unsupported_feature.
    public func createIccCreator() throws(WaylandProxyError) -> WpImageDescriptionCreatorIccV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let obj = connection.createProxy(type: WpImageDescriptionCreatorIccV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.newId(obj.id)
        ])
        connection.send(message: message)
        return obj
    }
    
    /// Make A New Parametric Image Description Creator Object
    /// 
    /// Makes a new parametric image description creator object with all
    /// properties initially unset. The client can then use the object's
    /// interface to define all the required properties for an image description
    /// and finally create a wp_image_description_v1 object.
    /// This request can be used when the compositor advertises
    /// wp_color_manager_v1.feature.parametric.
    /// Otherwise this request raises the protocol error unsupported_feature.
    public func createParametricCreator() throws(WaylandProxyError) -> WpImageDescriptionCreatorParamsV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let obj = connection.createProxy(type: WpImageDescriptionCreatorParamsV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.newId(obj.id)
        ])
        connection.send(message: message)
        return obj
    }
    
    /// Create Windows-Scrgb Image Description Object
    /// 
    /// This creates a pre-defined image description for the so-called
    /// Windows-scRGB stimulus encoding. This comes from the Windows 10 handling
    /// of its own definition of an scRGB color space for an HDR screen
    /// driven in BT.2100/PQ signalling mode.
    /// Windows-scRGB uses sRGB (BT.709) color primaries and white point.
    /// The transfer characteristic is extended linear.
    /// The nominal color channel value range is extended, meaning it includes
    /// negative and greater than 1.0 values. Negative values are used to
    /// escape the sRGB color gamut boundaries. To make use of the extended
    /// range, the client needs to use a pixel format that can represent those
    /// values, e.g. floating-point 16 bits per channel.
    /// Nominal color value R=G=B=0.0 corresponds to BT.2100/PQ system
    /// 0 cd/m², and R=G=B=1.0 corresponds to BT.2100/PQ system 80 cd/m².
    /// The maximum is R=G=B=125.0 corresponding to 10k cd/m².
    /// Windows-scRGB is displayed by Windows 10 by converting it to
    /// BT.2100/PQ, maintaining the CIE 1931 chromaticity and mapping the
    /// luminance as above. No adjustment is made to the signal to account
    /// for the viewing conditions.
    /// The reference white level of Windows-scRGB is unknown. If a
    /// reference white level must be assumed for compositor processing, it
    /// should be R=G=B=2.5375 corresponding to 203 cd/m² of Report ITU-R
    /// BT.2408-7.
    /// The target color volume of Windows-scRGB is unknown. The color gamut
    /// may be anything between sRGB and BT.2100.
    /// Note: EGL_EXT_gl_colorspace_scrgb_linear definition differs from
    /// Windows-scRGB by using R=G=B=1.0 as the reference white level, while
    /// Windows-scRGB reference white level is unknown or varies. However,
    /// it seems probable that Windows implements both
    /// EGL_EXT_gl_colorspace_scrgb_linear and Vulkan
    /// VK_COLOR_SPACE_EXTENDED_SRGB_LINEAR_EXT as Windows-scRGB.
    /// This request can be used when the compositor advertises
    /// wp_color_manager_v1.feature.windows_scrgb.
    /// Otherwise this request raises the protocol error unsupported_feature.
    /// The resulting image description object does not allow get_information
    /// request. The wp_image_description_v1.ready event shall be sent.
    public func createWindowsScrgb() throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 6, contents: [
            WaylandData.newId(imageDescription.id)
        ])
        connection.send(message: message)
        return imageDescription
    }
    
    /// Create An Image Description From A Reference
    /// 
    /// This request retrieves the image description backing a reference.
    /// The get_information request can be used if and only if the request that
    /// creates the reference allows it.
    /// 
    /// Available since version 2
    public func getImageDescription(reference: WpImageDescriptionReferenceV1) throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 7, contents: [
            WaylandData.newId(imageDescription.id),
            WaylandData.object(reference)
        ])
        connection.send(message: message)
        return imageDescription
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Request Not Supported
        case unsupportedFeature = 0
        
        /// Color Management Surface Exists Already
        case surfaceExists = 1
    }
    
    /// Rendering Intents
    /// 
    /// See the ICC.1:2022 specification from the International Color Consortium
    /// for more details about rendering intents.
    /// The principles of ICC defined rendering intents apply with all types of
    /// image descriptions, not only those with ICC file profiles.
    /// Compositors must support the perceptual rendering intent. Other
    /// rendering intents are optional.
    public enum RenderIntent: UInt32, WlEnum {
        /// Perceptual
        case perceptual = 0
        
        /// Media-Relative Colorimetric
        case relative = 1
        
        /// Saturation
        case saturation = 2
        
        /// Icc-Absolute Colorimetric
        case absolute = 3
        
        /// Media-Relative Colorimetric + Black Point Compensation
        case relativeBpc = 4
        
        case absoluteNoAdaptation = 5
    }
    
    /// Compositor Supported Features
    /// 
    /// 
    public enum Feature: UInt32, WlEnum {
        /// Create_Icc_Creator Request
        case iccV2V4 = 0
        
        /// Create_Parametric_Creator Request
        case parametric = 1
        
        /// Parametric Set_Primaries Request
        case setPrimaries = 2
        
        /// Parametric Set_Tf_Power Request
        case setTfPower = 3
        
        /// Parametric Set_Luminances Request
        case setLuminances = 4
        
        case setMasteringDisplayPrimaries = 5
        
        case extendedTargetVolume = 6
        
        /// Create_Windows_Scrgb Request
        case windowsScrgb = 7
    }
    
    /// Named Color Primaries
    /// 
    /// Named color primaries used to encode well-known sets of primaries.
    /// A value of 0 is invalid and will never be present in the list of enums.
    public enum Primaries: UInt32, WlEnum {
        case srgb = 1
        
        case palM = 2
        
        case pal = 3
        
        case ntsc = 4
        
        case genericFilm = 5
        
        case bt2020 = 6
        
        case cie1931Xyz = 7
        
        case dciP3 = 8
        
        case displayP3 = 9
        
        case adobeRgb = 10
    }
    
    /// Named Transfer Functions
    /// 
    /// Named transfer functions used to represent well-known transfer
    /// characteristics of displays.
    /// A value of 0 is invalid and will never be present in the list of enums.
    /// See appendix.md for the formulae.
    public enum TransferFunction: UInt32, WlEnum {
        case bt1886 = 1
        
        case gamma22 = 2
        
        case gamma28 = 3
        
        case st240 = 4
        
        case extLinear = 5
        
        case log100 = 6
        
        case log316 = 7
        
        case xvycc = 8
        
        case srgb = 9
        
        case extSrgb = 10
        
        case st2084Pq = 11
        
        case st428 = 12
        
        case hlg = 13
        
        case compoundPower24 = 14
    }
    
    public enum Event: WlEventEnum {
        /// Supported Rendering Intent
        /// 
        /// When this object is created, it shall immediately send this event once
        /// for each rendering intent the compositor supports.
        /// A compositor must not advertise intents that are deprecated in the
        /// bound version of the interface.
        /// 
        /// - Parameters:
        ///   - RenderIntent: rendering intent
        case supportedIntent(renderIntent: UInt32)
        
        /// Supported Features
        /// 
        /// When this object is created, it shall immediately send this event once
        /// for each compositor supported feature listed in the enumeration.
        /// A compositor must not advertise features that are deprecated in the
        /// bound version of the interface.
        /// 
        /// - Parameters:
        ///   - Feature: supported feature
        case supportedFeature(feature: UInt32)
        
        /// Supported Named Transfer Characteristic
        /// 
        /// When this object is created, it shall immediately send this event once
        /// for each named transfer function the compositor supports with the
        /// parametric image description creator.
        /// A compositor must not advertise transfer functions that are deprecated
        /// in the bound version of the interface.
        /// 
        /// - Parameters:
        ///   - Tf: Named transfer function
        case supportedTfNamed(tf: UInt32)
        
        /// Supported Named Primaries
        /// 
        /// When this object is created, it shall immediately send this event once
        /// for each named set of primaries the compositor supports with the
        /// parametric image description creator.
        /// A compositor must not advertise names that are deprecated in the
        /// bound version of the interface.
        /// 
        /// - Parameters:
        ///   - Primaries: Named color primaries
        case supportedPrimariesNamed(primaries: UInt32)
        
        /// All Features Have Been Sent
        /// 
        /// This event is sent when all supported rendering intents, features,
        /// transfer functions and named primaries have been sent.
        case done
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.supportedIntent(renderIntent: r.readUInt())
            case 1:
                return Self.supportedFeature(feature: r.readUInt())
            case 2:
                return Self.supportedTfNamed(tf: r.readUInt())
            case 3:
                return Self.supportedPrimariesNamed(primaries: r.readUInt())
            case 4:
                return Self.done
            default:
                fatalError("Unknown message")
            }
        }
    }
}
