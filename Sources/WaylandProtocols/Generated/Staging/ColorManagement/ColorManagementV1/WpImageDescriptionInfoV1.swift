import Foundation
import SwiftWayland

/// Colorimetric Image Description Information
/// 
/// Sends all matching events describing an image description object exactly
/// once and finally sends the 'done' event.
/// This means
/// - if the image description is parametric, it must send
/// - primaries
/// - named_primaries, if applicable
/// - at least one of tf_power and tf_named, as applicable
/// - luminances
/// - target_primaries
/// - target_luminance
/// - if the image description is parametric, it may send, if applicable,
/// - target_max_cll
/// - target_max_fall
/// - if the image description contains an ICC profile, it must send the
/// icc_file event
/// Once a wp_image_description_info_v1 object has delivered a 'done' event it
/// is automatically destroyed.
/// Every wp_image_description_info_v1 created from the same
/// wp_image_description_v1 shall always return the exact same data.
public final class WpImageDescriptionInfoV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_image_description_info_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public enum Event: WlEventEnum {
        /// End Of Information
        /// 
        /// Signals the end of information events and destroys the object.
        case done
        
        /// Icc Profile Matching The Image Description
        /// 
        /// The icc argument provides a file descriptor to the client which may be
        /// memory-mapped to provide the ICC profile matching the image description.
        /// The fd is read-only, and if mapped then it must be mapped with
        /// MAP_PRIVATE by the client.
        /// The ICC profile version and other details are determined by the
        /// compositor. There is no provision for a client to ask for a specific
        /// kind of a profile.
        /// 
        /// - Parameters:
        ///   - Icc: ICC profile file descriptor
        ///   - IccSize: ICC profile size, in bytes
        case iccFile(icc: FileHandle, iccSize: UInt32)
        
        /// Primaries As Chromaticity Coordinates
        /// 
        /// Delivers the primary color volume primaries and white point using CIE
        /// 1931 xy chromaticity coordinates.
        /// Each coordinate value is multiplied by 1 million to get the argument
        /// value to carry precision of 6 decimals.
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
        case primaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32)
        
        /// Named Primaries
        /// 
        /// Delivers the primary color volume primaries and white point using an
        /// explicitly enumerated named set.
        /// 
        /// - Parameters:
        ///   - Primaries: named primaries
        case primariesNamed(primaries: UInt32)
        
        /// Transfer Characteristic As A Power Curve
        /// 
        /// The color component transfer characteristic of this image description is
        /// a pure power curve. This event provides the exponent of the power
        /// function. This curve represents the conversion from electrical to
        /// optical pixel or color values.
        /// The curve exponent has been multiplied by 10000 to get the argument eexp
        /// value to carry the precision of 4 decimals.
        /// 
        /// - Parameters:
        ///   - Eexp: the exponent * 10000
        case tfPower(eexp: UInt32)
        
        /// Named Transfer Characteristic
        /// 
        /// Delivers the transfer characteristic using an explicitly enumerated
        /// named function.
        /// 
        /// - Parameters:
        ///   - Tf: named transfer function
        case tfNamed(tf: UInt32)
        
        /// Primary Color Volume Luminance Range And Reference White
        /// 
        /// Delivers the primary color volume luminance range and the reference
        /// white luminance level. These values include the minimum display emission
        /// and ambient flare luminances, assumed to be optically additive and have
        /// the chromaticity of the primary color volume white point.
        /// The minimum luminance is multiplied by 10000 to get the argument
        /// 'min_lum' value and carries precision of 4 decimals. The maximum
        /// luminance and reference white luminance values are unscaled.
        /// 
        /// - Parameters:
        ///   - MinLum: minimum luminance (cd/m²) * 10000
        ///   - MaxLum: maximum luminance (cd/m²)
        ///   - ReferenceLum: reference white luminance (cd/m²)
        case luminances(minLum: UInt32, maxLum: UInt32, referenceLum: UInt32)
        
        /// Target Primaries As Chromaticity Coordinates
        /// 
        /// Provides the color primaries and white point of the target color volume
        /// using CIE 1931 xy chromaticity coordinates. This is compatible with the
        /// SMPTE ST 2086 definition of HDR static metadata for mastering displays.
        /// While primary color volume is about how color is encoded, the target
        /// color volume is the actually displayable color volume. If target color
        /// volume is equal to the primary color volume, then this event is not
        /// sent.
        /// Each coordinate value is multiplied by 1 million to get the argument
        /// value to carry precision of 6 decimals.
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
        case targetPrimaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32)
        
        /// Target Luminance Range
        /// 
        /// Provides the luminance range that the image description is targeting as
        /// the minimum and maximum absolute luminance L. These values include the
        /// minimum display emission and ambient flare luminances, assumed to be
        /// optically additive and have the chromaticity of the primary color
        /// volume white point. This should be compatible with the SMPTE ST 2086
        /// definition of HDR static metadata.
        /// This luminance range is only theoretical and may not correspond to the
        /// luminance of light emitted on an actual display.
        /// Min L value is multiplied by 10000 to get the argument min_lum value and
        /// carry precision of 4 decimals. Max L value is unscaled for max_lum.
        /// 
        /// - Parameters:
        ///   - MinLum: min L (cd/m²) * 10000
        ///   - MaxLum: max L (cd/m²)
        case targetLuminance(minLum: UInt32, maxLum: UInt32)
        
        /// Target Maximum Content Light Level
        /// 
        /// Provides the targeted max_cll of the image description. max_cll is
        /// defined by CTA-861-H.
        /// This luminance is only theoretical and may not correspond to the
        /// luminance of light emitted on an actual display.
        /// 
        /// - Parameters:
        ///   - MaxCll: Maximum content light-level (cd/m²)
        case targetMaxCll(maxCll: UInt32)
        
        /// Target Maximum Frame-Average Light Level
        /// 
        /// Provides the targeted max_fall of the image description. max_fall is
        /// defined by CTA-861-H.
        /// This luminance is only theoretical and may not correspond to the
        /// luminance of light emitted on an actual display.
        /// 
        /// - Parameters:
        ///   - MaxFall: Maximum frame-average light level (cd/m²)
        case targetMaxFall(maxFall: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.done
            case 1:
                return Self.iccFile(icc: r.readFd(), iccSize: r.readUInt())
            case 2:
                return Self.primaries(rX: r.readInt(), rY: r.readInt(), gX: r.readInt(), gY: r.readInt(), bX: r.readInt(), bY: r.readInt(), wX: r.readInt(), wY: r.readInt())
            case 3:
                return Self.primariesNamed(primaries: r.readUInt())
            case 4:
                return Self.tfPower(eexp: r.readUInt())
            case 5:
                return Self.tfNamed(tf: r.readUInt())
            case 6:
                return Self.luminances(minLum: r.readUInt(), maxLum: r.readUInt(), referenceLum: r.readUInt())
            case 7:
                return Self.targetPrimaries(rX: r.readInt(), rY: r.readInt(), gX: r.readInt(), gY: r.readInt(), bX: r.readInt(), bY: r.readInt(), wX: r.readInt(), wY: r.readInt())
            case 8:
                return Self.targetLuminance(minLum: r.readUInt(), maxLum: r.readUInt())
            case 9:
                return Self.targetMaxCll(maxCll: r.readUInt())
            case 10:
                return Self.targetMaxFall(maxFall: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
