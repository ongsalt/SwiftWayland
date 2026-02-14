import Foundation
import SwiftWayland

/// Holder Of Image Description Parameters
/// 
/// This type of object is used for collecting all the parameters required
/// to create a wp_image_description_v1 object. A complete set of required
/// parameters consists of these properties:
/// - transfer characteristic function (tf)
/// - chromaticities of primaries and white point (primary color volume)
/// The following properties are optional and have a well-defined default
/// if not explicitly set:
/// - primary color volume luminance range
/// - reference white luminance level
/// - mastering display primaries and white point (target color volume)
/// - mastering luminance range
/// The following properties are optional and will be ignored
/// if not explicitly set:
/// - maximum content light level
/// - maximum frame-average light level
/// Each required property must be set exactly once if the client is to create
/// an image description. The set requests verify that a property was not
/// already set. The create request verifies that all required properties are
/// set. There may be several alternative requests for setting each property,
/// and in that case the client must choose one of them.
/// Once all properties have been set, the create request must be used to
/// create the image description object, destroying the creator in the
/// process.
/// A viewer, who is viewing the display defined by the resulting image
/// description (the viewing environment included), is assumed to be fully
/// adapted to the primary color volume's white point.
/// Any of the following conditions will cause the colorimetry of a pixel
/// to become undefined:
/// - Values outside of the defined range of the transfer characteristic.
/// - Tristimulus that exceeds the target color volume.
/// - If extended_target_volume is not supported: tristimulus that exceeds
/// the primary color volume.
/// The closest correspondence to an image description created through this
/// interface is the Display class of profiles in ICC.
public final class WpImageDescriptionCreatorParamsV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_image_description_creator_params_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create The Image Description Object Using Params
    /// 
    /// Create an image description object based on the parameters previously
    /// set on this object.
    /// The completeness of the parameter set is verified. If the set is not
    /// complete, the protocol error incomplete_set is raised. For the
    /// definition of a complete set, see the description of this interface.
    /// When both max_cll and max_fall are set, max_fall must be less or equal
    /// to max_cll otherwise the invalid_luminance protocol error is raised.
    /// In version 1, these following conditions also result in the
    /// invalid_luminance protocol error. Version 2 and later do not have this
    /// requirement.
    /// - When max_cll is set, it must be greater than min L and less or equal
    /// to max L of the mastering luminance range.
    /// - When max_fall is set, it must be greater than min L and less or equal
    /// to max L of the mastering luminance range.
    /// If the particular combination of the parameter set is not supported
    /// by the compositor, the resulting image description object shall
    /// immediately deliver the wp_image_description_v1.failed event with the
    /// 'unsupported' cause. If a valid image description was created from the
    /// parameter set, the wp_image_description_v1.ready event will eventually
    /// be sent instead.
    /// This request destroys the wp_image_description_creator_params_v1
    /// object.
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
    
    /// Named Transfer Characteristic
    /// 
    /// Sets the transfer characteristic using explicitly enumerated named
    /// functions.
    /// When the resulting image description is attached to an image, the
    /// content should be decoded according to the industry standard
    /// practices for the transfer characteristic.
    /// Only names advertised with wp_color_manager_v1 event supported_tf_named
    /// are allowed. Other values shall raise the protocol error invalid_tf.
    /// If transfer characteristic has already been set on this object, the
    /// protocol error already_set is raised.
    /// 
    /// - Parameters:
    ///   - Tf: named transfer function
    public func setTfNamed(tf: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.uint(tf)
        ])
        connection.send(message: message)
    }
    
    /// Transfer Characteristic As A Power Curve
    /// 
    /// Sets the color component transfer characteristic to a power curve with
    /// the given exponent. Negative values are handled by mirroring the
    /// positive half of the curve through the origin. The valid domain and
    /// range of the curve are all finite real numbers. This curve represents
    /// the conversion from electrical to optical color channel values.
    /// The curve exponent shall be multiplied by 10000 to get the argument eexp
    /// value to carry the precision of 4 decimals.
    /// The curve exponent must be at least 1.0 and at most 10.0. Otherwise the
    /// protocol error invalid_tf is raised.
    /// If transfer characteristic has already been set on this object, the
    /// protocol error already_set is raised.
    /// This request can be used when the compositor advertises
    /// wp_color_manager_v1.feature.set_tf_power. Otherwise this request raises
    /// the protocol error unsupported_feature.
    /// 
    /// - Parameters:
    ///   - Eexp: the exponent * 10000
    public func setTfPower(eexp: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.uint(eexp)
        ])
        connection.send(message: message)
    }
    
    /// Named Primaries
    /// 
    /// Sets the color primaries and white point using explicitly named sets.
    /// This describes the primary color volume which is the basis for color
    /// value encoding.
    /// Only names advertised with wp_color_manager_v1 event
    /// supported_primaries_named are allowed. Other values shall raise the
    /// protocol error invalid_primaries_named.
    /// If primaries have already been set on this object, the protocol error
    /// already_set is raised.
    /// 
    /// - Parameters:
    ///   - Primaries: named primaries
    public func setPrimariesNamed(primaries: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.uint(primaries)
        ])
        connection.send(message: message)
    }
    
    /// Primaries As Chromaticity Coordinates
    /// 
    /// Sets the color primaries and white point using CIE 1931 xy chromaticity
    /// coordinates. This describes the primary color volume which is the basis
    /// for color value encoding.
    /// Each coordinate value is multiplied by 1 million to get the argument
    /// value to carry precision of 6 decimals.
    /// If primaries have already been set on this object, the protocol error
    /// already_set is raised.
    /// This request can be used if the compositor advertises
    /// wp_color_manager_v1.feature.set_primaries. Otherwise this request raises
    /// the protocol error unsupported_feature.
    /// 
    /// - Parameters:
    ///   - RX: Red x * 1M
    ///   - RY: Red y * 1M
    ///   - GX: Green x * 1M
    ///   - GY: Green y * 1M
    ///   - BX: Blue x * 1M
    ///   - BY: Blue y * 1M
    ///   - WX: White x * 1M
    ///   - WY: White y * 1M
    public func setPrimaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.int(rX),
            WaylandData.int(rY),
            WaylandData.int(gX),
            WaylandData.int(gY),
            WaylandData.int(bX),
            WaylandData.int(bY),
            WaylandData.int(wX),
            WaylandData.int(wY)
        ])
        connection.send(message: message)
    }
    
    /// Primary Color Volume Luminance Range And Reference White
    /// 
    /// Sets the primary color volume luminance range and the reference white
    /// luminance level. These values include the minimum display emission, but
    /// not external flare. The minimum display emission is assumed to have
    /// the chromaticity of the primary color volume white point.
    /// The default luminances from
    /// https://www.color.org/chardata/rgb/srgb.xalter are
    /// - primary color volume minimum: 0.2 cd/m²
    /// - primary color volume maximum: 80 cd/m²
    /// - reference white: 80 cd/m²
    /// Setting a named transfer characteristic can imply other default
    /// luminances.
    /// The default luminances get overwritten when this request is used.
    /// With transfer_function.st2084_pq the given 'max_lum' value is ignored,
    /// and 'max_lum' is taken as 'min_lum' + 10000 cd/m².
    /// 'min_lum' and 'max_lum' specify the minimum and maximum luminances of
    /// the primary color volume as reproduced by the targeted display.
    /// 'reference_lum' specifies the luminance of the reference white as
    /// reproduced by the targeted display, and reflects the targeted viewing
    /// environment.
    /// Compositors should make sure that all content is anchored, meaning that
    /// an input signal level of 'reference_lum' on one image description and
    /// another input signal level of 'reference_lum' on another image
    /// description should produce the same output level, even though the
    /// 'reference_lum' on both image representations can be different.
    /// 'reference_lum' may be higher than 'max_lum'. In that case reaching
    /// the reference white output level in image content requires the
    /// 'extended_target_volume' feature support.
    /// If 'max_lum' or 'reference_lum' are less than or equal to 'min_lum',
    /// the protocol error invalid_luminance is raised.
    /// The minimum luminance is multiplied by 10000 to get the argument
    /// 'min_lum' value and carries precision of 4 decimals. The maximum
    /// luminance and reference white luminance values are unscaled.
    /// If the primary color volume luminance range and the reference white
    /// luminance level have already been set on this object, the protocol error
    /// already_set is raised.
    /// This request can be used if the compositor advertises
    /// wp_color_manager_v1.feature.set_luminances. Otherwise this request
    /// raises the protocol error unsupported_feature.
    /// 
    /// - Parameters:
    ///   - MinLum: minimum luminance (cd/m²) * 10000
    ///   - MaxLum: maximum luminance (cd/m²)
    ///   - ReferenceLum: reference white luminance (cd/m²)
    public func setLuminances(minLum: UInt32, maxLum: UInt32, referenceLum: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.uint(minLum),
            WaylandData.uint(maxLum),
            WaylandData.uint(referenceLum)
        ])
        connection.send(message: message)
    }
    
    /// Mastering Display Primaries As Chromaticity Coordinates
    /// 
    /// Provides the color primaries and white point of the mastering display
    /// using CIE 1931 xy chromaticity coordinates. This is compatible with the
    /// SMPTE ST 2086 definition of HDR static metadata.
    /// The mastering display primaries and mastering display luminances define
    /// the target color volume.
    /// If mastering display primaries are not explicitly set, the target color
    /// volume is assumed to have the same primaries as the primary color volume.
    /// The target color volume is defined by all tristimulus values between 0.0
    /// and 1.0 (inclusive) of the color space defined by the given mastering
    /// display primaries and white point. The colorimetry is identical between
    /// the container color space and the mastering display color space,
    /// including that no chromatic adaptation is applied even if the white
    /// points differ.
    /// The target color volume can exceed the primary color volume to allow for
    /// a greater color volume with an existing color space definition (for
    /// example scRGB). It can be smaller than the primary color volume to
    /// minimize gamut and tone mapping distances for big color spaces (HDR
    /// metadata).
    /// To make use of the entire target color volume a suitable pixel format
    /// has to be chosen (e.g. floating point to exceed the primary color
    /// volume, or abusing limited quantization range as with xvYCC).
    /// Each coordinate value is multiplied by 1 million to get the argument
    /// value to carry precision of 6 decimals.
    /// If mastering display primaries have already been set on this object, the
    /// protocol error already_set is raised.
    /// This request can be used if the compositor advertises
    /// wp_color_manager_v1.feature.set_mastering_display_primaries. Otherwise
    /// this request raises the protocol error unsupported_feature. The
    /// advertisement implies support only for target color volumes fully
    /// contained within the primary color volume.
    /// If a compositor additionally supports target color volume exceeding the
    /// primary color volume, it must advertise
    /// wp_color_manager_v1.feature.extended_target_volume. If a client uses
    /// target color volume exceeding the primary color volume and the
    /// compositor does not support it, the result is implementation defined.
    /// Compositors are recommended to detect this case and fail the image
    /// description gracefully, but it may as well result in color artifacts.
    /// 
    /// - Parameters:
    ///   - RX: Red x * 1M
    ///   - RY: Red y * 1M
    ///   - GX: Green x * 1M
    ///   - GY: Green y * 1M
    ///   - BX: Blue x * 1M
    ///   - BY: Blue y * 1M
    ///   - WX: White x * 1M
    ///   - WY: White y * 1M
    public func setMasteringDisplayPrimaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            WaylandData.int(rX),
            WaylandData.int(rY),
            WaylandData.int(gX),
            WaylandData.int(gY),
            WaylandData.int(bX),
            WaylandData.int(bY),
            WaylandData.int(wX),
            WaylandData.int(wY)
        ])
        connection.send(message: message)
    }
    
    /// Display Mastering Luminance Range
    /// 
    /// Sets the luminance range that was used during the content mastering
    /// process as the minimum and maximum absolute luminance L. These values
    /// include the minimum display emission and ambient flare luminances,
    /// assumed to be optically additive and have the chromaticity of the
    /// primary color volume white point. This should be
    /// compatible with the SMPTE ST 2086 definition of HDR static metadata.
    /// The mastering display primaries and mastering display luminances define
    /// the target color volume.
    /// If mastering luminances are not explicitly set, the target color volume
    /// is assumed to have the same min and max luminances as the primary color
    /// volume.
    /// If max L is less than or equal to min L, the protocol error
    /// invalid_luminance is raised.
    /// Min L value is multiplied by 10000 to get the argument min_lum value
    /// and carry precision of 4 decimals. Max L value is unscaled for max_lum.
    /// This request can be used if the compositor advertises
    /// wp_color_manager_v1.feature.set_mastering_display_primaries. Otherwise
    /// this request raises the protocol error unsupported_feature. The
    /// advertisement implies support only for target color volumes fully
    /// contained within the primary color volume.
    /// If a compositor additionally supports target color volume exceeding the
    /// primary color volume, it must advertise
    /// wp_color_manager_v1.feature.extended_target_volume. If a client uses
    /// target color volume exceeding the primary color volume and the
    /// compositor does not support it, the result is implementation defined.
    /// Compositors are recommended to detect this case and fail the image
    /// description gracefully, but it may as well result in color artifacts.
    /// 
    /// - Parameters:
    ///   - MinLum: min L (cd/m²) * 10000
    ///   - MaxLum: max L (cd/m²)
    public func setMasteringLuminance(minLum: UInt32, maxLum: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 7, contents: [
            WaylandData.uint(minLum),
            WaylandData.uint(maxLum)
        ])
        connection.send(message: message)
    }
    
    /// Maximum Content Light Level
    /// 
    /// Sets the maximum content light level (max_cll) as defined by CTA-861-H.
    /// max_cll is undefined by default.
    /// 
    /// - Parameters:
    ///   - MaxCll: Maximum content light level (cd/m²)
    public func setMaxCll(maxCll: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            WaylandData.uint(maxCll)
        ])
        connection.send(message: message)
    }
    
    /// Maximum Frame-Average Light Level
    /// 
    /// Sets the maximum frame-average light level (max_fall) as defined by
    /// CTA-861-H.
    /// max_fall is undefined by default.
    /// 
    /// - Parameters:
    ///   - MaxFall: Maximum frame-average light level (cd/m²)
    public func setMaxFall(maxFall: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 9, contents: [
            WaylandData.uint(maxFall)
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
        
        /// Request Not Supported
        case unsupportedFeature = 2
        
        /// Invalid Transfer Characteristic
        case invalidTf = 3
        
        /// Invalid Primaries Named
        case invalidPrimariesNamed = 4
        
        /// Invalid Luminance Value Or Range
        case invalidLuminance = 5
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
