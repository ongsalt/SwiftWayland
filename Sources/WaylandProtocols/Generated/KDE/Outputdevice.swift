import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Output Configuration Representation
/// 
/// An outputdevice describes a display device available to the compositor.
/// outputdevice is similar to wl_output, but focuses on output
/// configuration management.
/// A client can query all global outputdevice objects to enlist all
/// available display devices, even those that may currently not be
/// represented by the compositor as a wl_output.
/// The client sends configuration changes to the server through the
/// outputconfiguration interface, and the server applies the configuration
/// changes to the hardware and signals changes to the outputdevices
/// accordingly.
/// This object is published as global during start up for every available
/// display devices, or when one later becomes available, for example by
/// being hotplugged via a physical connector.
public final class KdeOutputdevice: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_outputdevice",
            version: 4,
            enums: [],
            requests: [
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
                    name: "mode",
                    arguments: [
                    Argument(
                        name: "flags",
                        type: .uint,
                    ),
                    Argument(
                        name: "width",
                        type: .int,
                    ),
                    Argument(
                        name: "height",
                        type: .int,
                    ),
                    Argument(
                        name: "refresh",
                        type: .int,
                    ),
                    Argument(
                        name: "mode_id",
                        type: .int,
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
                        type: .int,
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
                    name: "scalef",
                    arguments: [
                    Argument(
                        name: "factor",
                        type: .fixed,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "colorcurves",
                    arguments: [
                    Argument(
                        name: "red",
                        type: .array,
                    ),
                    Argument(
                        name: "green",
                        type: .array,
                    ),
                    Argument(
                        name: "blue",
                        type: .array,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "serial_number",
                    arguments: [
                    Argument(
                        name: "serialNumber",
                        type: .string,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "eisa_id",
                    arguments: [
                    Argument(
                        name: "eisaId",
                        type: .string,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "capabilities",
                    arguments: [
                    Argument(
                        name: "flags",
                        type: .uint,
                    ),
                    ],
                    since: 3
                ),
                Message(
                    name: "overscan",
                    arguments: [
                    Argument(
                        name: "overscan",
                        type: .uint,
                    ),
                    ],
                    since: 3
                ),
                Message(
                    name: "vrr_policy",
                    arguments: [
                    Argument(
                        name: "vrr_policy",
                        type: .uint,
                    ),
                    ],
                    since: 4
                ),
                ],
        )
    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: OrgKdeKwinOutputdeviceProtocol)
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

    public enum Mode: UInt32 {
        /// indicates this is the current mode
        case current = 1

        /// indicates this is the preferred mode
        case preferred = 2
    }

    public enum Enablement: UInt32 {
        case disabled = 0

        case enabled = 1
    }

    public struct Capability: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// if this outputdevice can use overscan
        public static let overscan = Capability(rawValue: 1)

        /// if this outputdevice supports variable refresh rate
        public static let vrr = Capability(rawValue: 2)
    }

    public enum VrrPolicy: UInt32 {
        case never = 0

        case always = 1

        case automatic = 2
    }

    public enum Event: Decodable {
        /// Geometric Properties Of The Output
        /// 
        /// The geometry event describes geometric properties of the output.
        /// The event is sent when binding to the output object and whenever
        /// any of the properties change.
        case geometry(x: Int32, y: Int32, physicalWidth: Int32, physicalHeight: Int32, subpixel: Int32, make: String, model: String, transform: Int32)

        /// Advertise Available Output Modes And Current One
        /// 
        /// The mode event describes an available mode for the output.
        /// When the client binds to the outputdevice object, the server sends this
        /// event once for every available mode the outputdevice can be operated by.
        /// There will always be at least one event sent out on initial binding,
        /// which represents the current mode.
        /// Later on if an output changes its mode the event is sent again, whereby
        /// this event represents the mode that has now become current. In other
        /// words, the current mode is always represented by the latest event sent
        /// with the current flag set.
        /// The size of a mode is given in physical hardware units of the output device.
        /// This is not necessarily the same as the output size in the global compositor
        /// space. For instance, the output may be scaled, as described in
        /// org_kde_kwin_outputdevice.scale, or transformed, as described in
        /// org_kde_kwin_outputdevice.transform.
        /// The id can be used to refer to a mode when calling set_mode on an
        /// org_kde_kwin_outputconfiguration object.
        case mode(flags: UInt32, width: Int32, height: Int32, refresh: Int32, modeId: Int32)

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
        case scale(factor: Int32)

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
        /// wl_output will keep the output scale as an integer. In every situation except
        /// configuring the window manager you want to use that.
        case scalef(factor: Double)

        /// Output Color Curves
        /// 
        /// Describes the color intensity profile of the output.
        /// Commonly used for gamma/color correction.
        /// The array contains all color ramp values of the output.
        /// For example on 8bit screens there are 256 of them.
        /// The array elements are unsigned 16bit integers.
        case colorcurves(red: Data, green: Data, blue: Data)

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

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.geometry(x: r.int(), y: r.int(), physicalWidth: r.int(), physicalHeight: r.int(), subpixel: r.int(), make: r.string(), model: r.string(), transform: r.int())
            case 1:
                self = Self.mode(flags: r.uint(), width: r.int(), height: r.int(), refresh: r.int(), modeId: r.int())
            case 2:
                self = Self.done
            case 3:
                self = Self.scale(factor: r.int())
            case 4:
                self = Self.edid(raw: r.string())
            case 5:
                self = Self.enabled(enabled: r.int())
            case 6:
                self = Self.uuid(uuid: r.string())
            case 7:
                self = Self.scalef(factor: r.fixed())
            case 8:
                self = Self.colorcurves(red: r.array(), green: r.array(), blue: r.array())
            case 9:
                self = Self.serialNumber(serialnumber: r.string())
            case 10:
                self = Self.eisaId(eisaid: r.string())
            case 11:
                self = Self.capabilities(flags: try _parseEnum(into: Capability.self, r.uint()))
            case 12:
                self = Self.overscan(overscan: r.uint())
            case 13:
                self = Self.vrrPolicy(vrrPolicy: try _parseEnum(into: VrrPolicy.self, r.uint()))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let OrgKdeKwinOutputdeviceProtocol = Protocol(
        name: "org_kde_kwin_outputdevice",
        interfaces: [
            KdeOutputdevice.interface
        ]
    )

#endif