import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Output Devices
/// 
/// This interface can be used to list output devices.
/// If this global is bound with a version less than 21, the unsupported_version
/// protocol error will be posted.
public final class KdeOutputDeviceRegistryV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_output_device_registry_v2",
            version: 23,
            enums: [],
            requests: [
                Message(
                    name: "stop",
                    arguments: [
                    ],
                    since: 21
                ),
                ],
            events: [
                Message(
                    name: "finished",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 21
                ),
                Message(
                    name: "output",
                    arguments: [
                    Argument(
                        name: "output",
                        type: .newId,
                        interface: "kde_output_device_v2"
                    ),
                    ],
                    since: 21
                ),
                ],
        )
    /// Stop Receiving Updates
    /// 
    /// This request indicates that the client no longer wants to receive new
    /// output announcements. The compositor will send the
    /// kde_output_device_registry_v2.finished event in response to this request.
    /// The compositor may still send new output announcements after calling this
    /// request until the kde_output_device_registry_v2.finished event is sent.
    public func stop() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 21 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 21) }
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdeOutputDeviceV2)
    }
    
    public enum Error: UInt32 {
        /// the registry was bound with an unsupported version
        case unsupportedVersion = 0
    }

    public enum Event: Decodable {
        /// No New Output Announcements
        /// 
        /// This event is sent in response to the stop request. The compositor will
        /// immediately destroy the object after sending this event.
        case finished

        /// New Available Output
        /// 
        /// This event is sent when a new output is connected or after binding this
        /// global to list all available outputs.
        case output(output: KdeOutputDeviceV2)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.finished
            case 1:
                self = Self.output(output: r.newId(type: KdeOutputDeviceV2.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Output Configuration Representation
/// 
/// An output device describes a display device available to the compositor.
/// output_device is similar to wl_output, but focuses on output
/// configuration management.
/// A client can query all global output_device objects to enlist all
/// available display devices, even those that may currently not be
/// represented by the compositor as a wl_output.
/// The client sends configuration changes to the server through the
/// outputconfiguration interface, and the server applies the configuration
/// changes to the hardware and signals changes to the output devices
/// accordingly.
/// This object is published as global during start up for every available
/// display devices, or when one later becomes available, for example by
/// being hotplugged via a physical connector.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class KdeOutputDeviceV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_output_device_v2",
            version: 23,
            enums: [],
            requests: [
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 21
                ),
                ],
            events: [
                Message(
                    name: "geometry",
                    arguments: [
                    Argument(
                        name: "x",
                        type: .int,
                    ),
                    Argument(
                        name: "y",
                        type: .int,
                    ),
                    Argument(
                        name: "physical_width",
                        type: .int,
                    ),
                    Argument(
                        name: "physical_height",
                        type: .int,
                    ),
                    Argument(
                        name: "subpixel",
                        type: .int,
                    ),
                    Argument(
                        name: "make",
                        type: .string,
                    ),
                    Argument(
                        name: "model",
                        type: .string,
                    ),
                    Argument(
                        name: "transform",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "current_mode",
                    arguments: [
                    Argument(
                        name: "mode",
                        type: .object,
                        interface: "kde_output_device_mode_v2"
                    ),
                    ],
                ),
                Message(
                    name: "mode",
                    arguments: [
                    Argument(
                        name: "mode",
                        type: .newId,
                        interface: "kde_output_device_mode_v2"
                    ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [
                    ],
                ),
                Message(
                    name: "scale",
                    arguments: [
                    Argument(
                        name: "factor",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "edid",
                    arguments: [
                    Argument(
                        name: "raw",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "enabled",
                    arguments: [
                    Argument(
                        name: "enabled",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "uuid",
                    arguments: [
                    Argument(
                        name: "uuid",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "serial_number",
                    arguments: [
                    Argument(
                        name: "serialNumber",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "eisa_id",
                    arguments: [
                    Argument(
                        name: "eisaId",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "capabilities",
                    arguments: [
                    Argument(
                        name: "flags",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "overscan",
                    arguments: [
                    Argument(
                        name: "overscan",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "vrr_policy",
                    arguments: [
                    Argument(
                        name: "vrr_policy",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "rgb_range",
                    arguments: [
                    Argument(
                        name: "rgb_range",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "name",
                    arguments: [
                    Argument(
                        name: "name",
                        type: .string,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "high_dynamic_range",
                    arguments: [
                    Argument(
                        name: "hdr_enabled",
                        type: .uint,
                    ),
                    ],
                    since: 3
                ),
                Message(
                    name: "sdr_brightness",
                    arguments: [
                    Argument(
                        name: "sdr_brightness",
                        type: .uint,
                    ),
                    ],
                    since: 3
                ),
                Message(
                    name: "wide_color_gamut",
                    arguments: [
                    Argument(
                        name: "wcg_enabled",
                        type: .uint,
                    ),
                    ],
                    since: 3
                ),
                Message(
                    name: "auto_rotate_policy",
                    arguments: [
                    Argument(
                        name: "policy",
                        type: .uint,
                    ),
                    ],
                    since: 4
                ),
                Message(
                    name: "icc_profile_path",
                    arguments: [
                    Argument(
                        name: "profile_path",
                        type: .string,
                    ),
                    ],
                    since: 5
                ),
                Message(
                    name: "brightness_metadata",
                    arguments: [
                    Argument(
                        name: "max_peak_brightness",
                        type: .uint,
                    ),
                    Argument(
                        name: "max_frame_average_brightness",
                        type: .uint,
                    ),
                    Argument(
                        name: "min_brightness",
                        type: .uint,
                    ),
                    ],
                    since: 6
                ),
                Message(
                    name: "brightness_overrides",
                    arguments: [
                    Argument(
                        name: "max_peak_brightness",
                        type: .int,
                    ),
                    Argument(
                        name: "max_average_brightness",
                        type: .int,
                    ),
                    Argument(
                        name: "min_brightness",
                        type: .int,
                    ),
                    ],
                    since: 6
                ),
                Message(
                    name: "sdr_gamut_wideness",
                    arguments: [
                    Argument(
                        name: "gamut_wideness",
                        type: .uint,
                    ),
                    ],
                    since: 6
                ),
                Message(
                    name: "color_profile_source",
                    arguments: [
                    Argument(
                        name: "source",
                        type: .uint,
                    ),
                    ],
                    since: 7
                ),
                Message(
                    name: "brightness",
                    arguments: [
                    Argument(
                        name: "brightness",
                        type: .uint,
                    ),
                    ],
                    since: 8
                ),
                Message(
                    name: "color_power_tradeoff",
                    arguments: [
                    Argument(
                        name: "preference",
                        type: .uint,
                    ),
                    ],
                    since: 10
                ),
                Message(
                    name: "dimming",
                    arguments: [
                    Argument(
                        name: "multiplier",
                        type: .uint,
                    ),
                    ],
                    since: 11
                ),
                Message(
                    name: "replication_source",
                    arguments: [
                    Argument(
                        name: "source",
                        type: .string,
                    ),
                    ],
                    since: 13
                ),
                Message(
                    name: "ddc_ci_allowed",
                    arguments: [
                    Argument(
                        name: "allowed",
                        type: .uint,
                    ),
                    ],
                    since: 14
                ),
                Message(
                    name: "max_bits_per_color",
                    arguments: [
                    Argument(
                        name: "max_bpc",
                        type: .uint,
                    ),
                    ],
                    since: 15
                ),
                Message(
                    name: "max_bits_per_color_range",
                    arguments: [
                    Argument(
                        name: "min_value",
                        type: .uint,
                    ),
                    Argument(
                        name: "max_value",
                        type: .uint,
                    ),
                    ],
                    since: 15
                ),
                Message(
                    name: "automatic_max_bits_per_color_limit",
                    arguments: [
                    Argument(
                        name: "max_bpc_limit",
                        type: .uint,
                    ),
                    ],
                    since: 15
                ),
                Message(
                    name: "edr_policy",
                    arguments: [
                    Argument(
                        name: "policy",
                        type: .uint,
                    ),
                    ],
                    since: 16
                ),
                Message(
                    name: "sharpness",
                    arguments: [
                    Argument(
                        name: "sharpness",
                        type: .uint,
                    ),
                    ],
                    since: 17
                ),
                Message(
                    name: "priority",
                    arguments: [
                    Argument(
                        name: "priority",
                        type: .uint,
                    ),
                    ],
                    since: 18
                ),
                Message(
                    name: "auto_brightness",
                    arguments: [
                    Argument(
                        name: "enabled",
                        type: .uint,
                    ),
                    ],
                    since: 20
                ),
                Message(
                    name: "removed",
                    arguments: [
                    ],
                    since: 21
                ),
                Message(
                    name: "hdr_icc_profile_path",
                    arguments: [
                    Argument(
                        name: "profile_path",
                        type: .string,
                    ),
                    ],
                    since: 22
                ),
                Message(
                    name: "hdr_color_profile_source",
                    arguments: [
                    Argument(
                        name: "source",
                        type: .uint,
                    ),
                    ],
                    since: 22
                ),
                Message(
                    name: "abm_level",
                    arguments: [
                    Argument(
                        name: "level",
                        type: .uint,
                    ),
                    ],
                    since: 23
                ),
                ],
        )
    /// Destroy The Output Device
    /// 
    /// This notifies the compositor that the client no longer wishes to use
    /// the kde_output_device_v2 object.
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 21 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 21) }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdeOutputDeviceV2)
    }
    
    public enum Subpixel: UInt32 {
        case unknown = 0

        case `none` = 1

        case horizontalRgb = 2

        case horizontalBgr = 3

        case verticalRgb = 4

        case verticalBgr = 5
    }

    public enum Transform: UInt32 {
        case normal = 0

        case `90` = 1

        case `180` = 2

        case `270` = 3

        case flipped = 4

        case flipped90 = 5

        case flipped180 = 6

        case flipped270 = 7
    }

    public struct Capability: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// if this output_device can use overscan
        static let overscan = Capability(rawValue: 1)

        /// if this outputdevice supports variable refresh rate
        static let vrr = Capability(rawValue: 2)

        /// if setting the rgb range is possible
        static let rgbRange = Capability(rawValue: 4)

        /// if this outputdevice supports high dynamic range
        static let highDynamicRange = Capability(rawValue: 8)

        /// if this outputdevice supports a wide color gamut
        static let wideColorGamut = Capability(rawValue: 16)

        /// if this outputdevice supports autorotation
        static let autoRotate = Capability(rawValue: 32)

        /// if this outputdevice supports icc profiles
        static let iccProfile = Capability(rawValue: 64)

        /// if this outputdevice supports the brightness setting
        static let brightness = Capability(rawValue: 128)

        /// if this outputdevice supports the built-in color profile
        static let builtInColor = Capability(rawValue: 256)

        /// if this outputdevice supports DDC/CI
        static let ddcCi = Capability(rawValue: 512)

        /// if this outputdevice supports setting max bpc
        static let maxBitsPerColor = Capability(rawValue: 1024)

        /// if this outputdevice supports EDR
        static let edr = Capability(rawValue: 2048)

        /// if this outputdevice supports the sharpness setting
        static let sharpness = Capability(rawValue: 4096)

        /// if this outputdevice supports custom modes
        static let customModes = Capability(rawValue: 8192)

        static let autoBrightness = Capability(rawValue: 16384)

        /// if this outputdevice supports HDR ICC profiles
        static let hdrIccProfile = Capability(rawValue: 32768)

        /// if this outputdevice supports the abm level setting
        static let abmLevel = Capability(rawValue: 65536)
    }

    public enum VrrPolicy: UInt32 {
        case never = 0

        case always = 1

        case automatic = 2
    }

    public enum RgbRange: UInt32 {
        case automatic = 0

        case full = 1

        case limited = 2
    }

    public enum AutoRotatePolicy: UInt32 {
        case never = 0

        case inTabletMode = 1

        case always = 2
    }

    public enum ColorProfileSource: UInt32 {
        case srgb = 0

        case icc = 1

        case edid = 2
    }

    public enum ColorPowerTradeoff: UInt32 {
        /// prefer efficiency and performance
        case efficiency = 0

        /// prefer accuracy
        case accuracy = 1
    }

    public enum EdrPolicy: UInt32 {
        case never = 0

        case always = 1
    }

    var destructor: Destructor? = .release

    enum Destructor {
        case release
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .release: try? self.release()
                case nil: break
            }
        }
    }

    public enum Event: Decodable {
        /// Geometric Properties Of The Output
        /// 
        /// The geometry event describes geometric properties of the output.
        /// The event is sent when binding to the output object and whenever
        /// any of the properties change.
        case geometry(x: Int32, y: Int32, physicalWidth: Int32, physicalHeight: Int32, subpixel: Int32, make: String, model: String, transform: Int32)

        /// Current Mode
        /// 
        /// This event describes the mode currently in use for this head. It is only
        /// sent if the output is enabled.
        case currentMode(mode: KdeOutputDeviceModeV2)

        /// Advertise Available Output Modes And Current One
        /// 
        /// The mode event describes an available mode for the output.
        /// When the client binds to the output_device object, the server sends this
        /// event once for every available mode the output_device can be operated by.
        /// There will always be at least one event sent out on initial binding,
        /// which represents the current mode.
        /// Later if an output changes, its mode event is sent again for the
        /// eventual added modes and lastly the current mode. In other words, the
        /// current mode is always represented by the latest event sent with the current
        /// flag set.
        /// The size of a mode is given in physical hardware units of the output device.
        /// This is not necessarily the same as the output size in the global compositor
        /// space. For instance, the output may be scaled, as described in
        /// kde_output_device_v2.scale, or transformed, as described in
        /// kde_output_device_v2.transform.
        case mode(mode: KdeOutputDeviceModeV2)

        /// Sent All Information About Output
        /// 
        /// This event is sent after all other properties have been
        /// sent on binding to the output object as well as after any
        /// other output property change have been applied later on.
        /// This allows to see changes to the output properties as atomic,
        /// even if multiple events successively announce them.
        case done

        /// Output Scaling Properties
        /// 
        /// This event contains scaling geometry information
        /// that is not in the geometry event. It may be sent after
        /// binding the output object or if the output scale changes
        /// later. If it is not sent, the client should assume a
        /// scale of 1.
        /// A scale larger than 1 means that the compositor will
        /// automatically scale surface buffers by this amount
        /// when rendering. This is used for high resolution
        /// displays where applications rendering at the native
        /// resolution would be too small to be legible.
        /// It is intended that scaling aware clients track the
        /// current output of a surface, and if it is on a scaled
        /// output it should use wl_surface.set_buffer_scale with
        /// the scale of the output. That way the compositor can
        /// avoid scaling the surface, and the client can supply
        /// a higher detail image.
        case scale(factor: Double)

        /// Advertise Edid Data For The Output
        /// 
        /// The edid event encapsulates the EDID data for the outputdevice.
        /// The event is sent when binding to the output object. The EDID
        /// data may be empty, in which case this event is sent anyway.
        /// If the EDID information is empty, you can fall back to the name
        /// et al. properties of the outputdevice.
        case edid(raw: String)

        /// Output Is Enabled Or Disabled
        /// 
        /// The enabled event notifies whether this output is currently
        /// enabled and used for displaying content by the server.
        /// The event is sent when binding to the output object and
        /// whenever later on an output changes its state by becoming
        /// enabled or disabled.
        case enabled(enabled: Int32)

        /// A Unique Id For This Outputdevice
        /// 
        /// The uuid can be used to identify the output. It's controlled by
        /// the server entirely. The server should make sure the uuid is
        /// persistent across restarts. An empty uuid is considered invalid.
        case uuid(uuid: String)

        /// Serial Number
        /// 
        /// Serial ID of the monitor, sent on startup before the first done event.
        case serialNumber(serialnumber: String)

        /// Eisa Id
        /// 
        /// EISA ID of the monitor, sent on startup before the first done event.
        case eisaId(eisaid: String)

        /// Capability Flags
        /// 
        /// What capabilities this device has, sent on startup before the first
        /// done event.
        case capabilities(flags: Capability)

        /// Overscan
        /// 
        /// Overscan value of the monitor in percent, sent on startup before the
        /// first done event.
        case overscan(overscan: UInt32)

        /// Variable Refresh Rate Policy
        /// 
        /// What policy the compositor will employ regarding its use of variable
        /// refresh rate.
        case vrrPolicy(vrrPolicy: VrrPolicy)

        /// Rgb Range
        /// 
        /// What rgb range the compositor is using for this output
        case rgbRange(rgbRange: RgbRange)

        /// Output's Name
        /// 
        /// Name of the output, it's useful to cross-reference to an zxdg_output_v1 and ultimately QScreen
        case name(name: String)

        /// If Hdr Is Enabled
        /// 
        /// Whether or not high dynamic range is enabled for this output
        case highDynamicRange(hdrEnabled: UInt32)

        /// The Brightness Of Sdr If Hdr Is Enabled
        /// 
        /// If high dynamic range is used, this value defines the brightness in nits for content
        /// that's in standard dynamic range format. Note that while the value is in nits, that
        /// doesn't necessarily translate to the same brightness on the screen.
        case sdrBrightness(sdrBrightness: UInt32)

        /// If Wcg Is Enabled
        /// 
        /// Whether or not the use of a wide color gamut is enabled for this output
        case wideColorGamut(wcgEnabled: UInt32)

        /// Describes When Auto Rotate Is Used
        /// 
        /// 
        case autoRotatePolicy(policy: AutoRotatePolicy)

        /// Describes The Path To The Icc Profile Used In Sdr Mode
        /// 
        /// 
        case iccProfilePath(profilePath: String)

        /// Metadata About The Screen's Brightness Limits
        /// 
        /// 
        case brightnessMetadata(maxPeakBrightness: UInt32, maxFrameAverageBrightness: UInt32, minBrightness: UInt32)

        /// Overrides For The Screen's Brightness Limits
        /// 
        /// 
        case brightnessOverrides(maxPeakBrightness: Int32, maxAverageBrightness: Int32, minBrightness: Int32)

        /// Describes Which Gamut Is Assumed For Srgb Applications
        /// 
        /// This can be used to provide the colors users assume sRGB applications should have based on the
        /// default experience on many modern sRGB screens.
        case sdrGamutWideness(gamutWideness: UInt32)

        /// Describes Which Source The Compositor Uses For The Color Profile On An Output In Sdr Mode
        /// 
        /// 
        case colorProfileSource(source: ColorProfileSource)

        /// Brightness Multiplier
        /// 
        /// This is the brightness modifier of the output. It doesn't specify
        /// any absolute values, but is merely a multiplier on top of other
        /// brightness values, like sdr_brightness and brightness_metadata.
        /// 0 is the minimum brightness (not completely dark) and 10000 is
        /// the maximum brightness.
        /// This is currently only supported / meaningful while HDR is active.
        case brightness(brightness: UInt32)

        /// The Preferred Color/Power Tradeoff
        /// 
        /// 
        case colorPowerTradeoff(preference: ColorPowerTradeoff)

        /// Dimming Multiplier
        /// 
        /// This is the dimming multiplier of the output. This is similar to
        /// the brightness setting, except it's meant to be a temporary setting
        /// only, not persistent and may be implemented differently depending
        /// on the display.
        /// 0 is the minimum dimming factor (not completely dark) and 10000
        /// means the output is not dimmed.
        case dimming(multiplier: UInt32)

        /// Source Output For Mirroring
        /// 
        /// 
        case replicationSource(source: String)

        /// If Ddc/Ci Should Be Used To Control Brightness Etc.
        /// 
        /// If the ddc_ci capability is present, this determines if settings
        /// such as brightness, contrast or others should be set using DDC/CI.
        case ddcCiAllowed(allowed: UInt32)

        /// Override Max Bpc
        /// 
        /// This limits the amount of bits per color that are sent to the display.
        case maxBitsPerColor(maxBpc: UInt32)

        /// Range Of Max Bits Per Color Value
        /// 
        /// 
        case maxBitsPerColorRange(minValue: UInt32, maxValue: UInt32)

        /// If And To What Value Automatic Max Bpc Is Limited
        /// 
        /// 
        case automaticMaxBitsPerColorLimit(maxBpcLimit: UInt32)

        /// When The Compositor May Apply Edr
        /// 
        /// When EDR is enabled, the compositor may increase the backlight beyond
        /// the user-specified setting, in order to present HDR content on displays
        /// without native HDR support.
        /// This will usually result in better visuals, but also increases battery
        /// usage.
        case edrPolicy(policy: EdrPolicy)

        /// Sharpness Strength
        /// 
        /// This is the sharpness modifier of the output.
        /// 0 is sharpness disabled and 10000 is the maximum sharpness
        case sharpness(sharpness: UInt32)

        /// Output Priority
        /// 
        /// Describes the position of the output in the output order list,
        /// with lower values being earlier in the list. There's no specific
        /// value the list has to start at, this value is only used in sorting
        /// outputs.
        /// Note that the output order protocol is not sufficient for this,
        /// as an output may not be in the output order if it's disabled or
        /// mirroring another screen.
        case priority(priority: UInt32)

        /// Whether Or Not Automatic Brightness Is Enabled
        /// 
        /// 
        case autoBrightness(enabled: UInt32)

        /// The Output Has Been Removed
        /// 
        /// This event is sent when the output device is disconnected and no new
        /// updates will be sent. The client should call the kde_output_device_v2.release
        /// request after receiving this event.
        case removed

        /// Describes The Path To The Icc Profile Used In Hdr Mode
        /// 
        /// 
        case hdrIccProfilePath(profilePath: String)

        /// Describes Which Source The Compositor Uses For The Color Profile On An Output In Hdr Mode
        /// 
        /// 
        case hdrColorProfileSource(source: ColorProfileSource)

        /// Allowed Level Of Adaptive Backlight Modulation
        /// 
        /// Adaptive backlight modulation is a feature that reduces the backlight
        /// and increases contrast of colors on the screen to improve power usage.
        case abmLevel(level: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.geometry(x: r.int(), y: r.int(), physicalWidth: r.int(), physicalHeight: r.int(), subpixel: r.int(), make: r.string(), model: r.string(), transform: r.int())
            case 1:
                self = Self.currentMode(mode: r.object(type: KdeOutputDeviceModeV2.self))
            case 2:
                self = Self.mode(mode: r.newId(type: KdeOutputDeviceModeV2.self))
            case 3:
                self = Self.done
            case 4:
                self = Self.scale(factor: r.fixed())
            case 5:
                self = Self.edid(raw: r.string())
            case 6:
                self = Self.enabled(enabled: r.int())
            case 7:
                self = Self.uuid(uuid: r.string())
            case 8:
                self = Self.serialNumber(serialnumber: r.string())
            case 9:
                self = Self.eisaId(eisaid: r.string())
            case 10:
                self = Self.capabilities(flags: try _parseEnum(into: Capability.self, r.uint()))
            case 11:
                self = Self.overscan(overscan: r.uint())
            case 12:
                self = Self.vrrPolicy(vrrPolicy: try _parseEnum(into: VrrPolicy.self, r.uint()))
            case 13:
                self = Self.rgbRange(rgbRange: try _parseEnum(into: RgbRange.self, r.uint()))
            case 14:
                self = Self.name(name: r.string())
            case 15:
                self = Self.highDynamicRange(hdrEnabled: r.uint())
            case 16:
                self = Self.sdrBrightness(sdrBrightness: r.uint())
            case 17:
                self = Self.wideColorGamut(wcgEnabled: r.uint())
            case 18:
                self = Self.autoRotatePolicy(policy: try _parseEnum(into: AutoRotatePolicy.self, r.uint()))
            case 19:
                self = Self.iccProfilePath(profilePath: r.string())
            case 20:
                self = Self.brightnessMetadata(maxPeakBrightness: r.uint(), maxFrameAverageBrightness: r.uint(), minBrightness: r.uint())
            case 21:
                self = Self.brightnessOverrides(maxPeakBrightness: r.int(), maxAverageBrightness: r.int(), minBrightness: r.int())
            case 22:
                self = Self.sdrGamutWideness(gamutWideness: r.uint())
            case 23:
                self = Self.colorProfileSource(source: try _parseEnum(into: ColorProfileSource.self, r.uint()))
            case 24:
                self = Self.brightness(brightness: r.uint())
            case 25:
                self = Self.colorPowerTradeoff(preference: try _parseEnum(into: ColorPowerTradeoff.self, r.uint()))
            case 26:
                self = Self.dimming(multiplier: r.uint())
            case 27:
                self = Self.replicationSource(source: r.string())
            case 28:
                self = Self.ddcCiAllowed(allowed: r.uint())
            case 29:
                self = Self.maxBitsPerColor(maxBpc: r.uint())
            case 30:
                self = Self.maxBitsPerColorRange(minValue: r.uint(), maxValue: r.uint())
            case 31:
                self = Self.automaticMaxBitsPerColorLimit(maxBpcLimit: r.uint())
            case 32:
                self = Self.edrPolicy(policy: try _parseEnum(into: EdrPolicy.self, r.uint()))
            case 33:
                self = Self.sharpness(sharpness: r.uint())
            case 34:
                self = Self.priority(priority: r.uint())
            case 35:
                self = Self.autoBrightness(enabled: r.uint())
            case 36:
                self = Self.removed
            case 37:
                self = Self.hdrIccProfilePath(profilePath: r.string())
            case 38:
                self = Self.hdrColorProfileSource(source: try _parseEnum(into: ColorProfileSource.self, r.uint()))
            case 39:
                self = Self.abmLevel(level: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Output Mode
/// 
/// This object describes an output mode.
/// Some heads don't support output modes, in which case modes won't be
/// advertised.
/// Properties sent via this interface are applied atomically via the
/// kde_output_device.done event. No guarantees are made regarding the order
/// in which properties are sent.
public final class KdeOutputDeviceModeV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_output_device_mode_v2",
            version: 22,
            enums: [],
            requests: [
                ],
            events: [
                Message(
                    name: "size",
                    arguments: [
                    Argument(
                        name: "width",
                        type: .int,
                    ),
                    Argument(
                        name: "height",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "refresh",
                    arguments: [
                    Argument(
                        name: "refresh",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "preferred",
                    arguments: [
                    ],
                ),
                Message(
                    name: "removed",
                    arguments: [
                    ],
                ),
                Message(
                    name: "flags",
                    arguments: [
                    Argument(
                        name: "flags",
                        type: .uint,
                    ),
                    ],
                    since: 19
                ),
                ],
        )
    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdeOutputDeviceV2)
    }
    
    public enum Flags: UInt32 {
        case custom = 1

        case reducedBlanking = 2
    }

    public enum Event: Decodable {
        /// Mode Size
        /// 
        /// This event describes the mode size. The size is given in physical
        /// hardware units of the output device. This is not necessarily the same as
        /// the output size in the global compositor space. For instance, the output
        /// may be scaled or transformed.
        case size(width: Int32, height: Int32)

        /// Mode Refresh Rate
        /// 
        /// This event describes the mode's fixed vertical refresh rate. It is only
        /// sent if the mode has a fixed refresh rate.
        case refresh(refresh: Int32)

        /// Mode Is Preferred
        /// 
        /// This event advertises this mode as preferred.
        case preferred

        /// The Mode Has Been Destroyed
        /// 
        /// The compositor will destroy the object immediately after sending this
        /// event, so it will become invalid and the client should release any
        /// resources associated with it.
        case removed

        /// Mode Flags
        /// 
        /// This event describes the mode's flags.
        case flags(flags: Flags)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.size(width: r.int(), height: r.int())
            case 1:
                self = Self.refresh(refresh: r.int())
            case 2:
                self = Self.preferred
            case 3:
                self = Self.removed
            case 4:
                self = Self.flags(flags: try _parseEnum(into: Flags.self, r.uint()))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let KdeOutputDeviceV2 = Protocol(
        name: "kde_output_device_v2",
        interfaces: [
            KdeOutputDeviceRegistryV2.interface,
KdeOutputDeviceV2.interface,
KdeOutputDeviceModeV2.interface
        ]
    )

#endif