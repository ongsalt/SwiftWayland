import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Configuration Of Server Outputs Through Clients
/// 
/// This interface enables clients to set properties of output devices for screen
/// configuration purposes via the server. To this end output devices are referenced
/// by global org_kde_kwin_outputdevice objects.
/// outputmanagement (wl_global)
/// --------------------------
/// request:
/// * create_configuration -> outputconfiguration (wl_resource)
/// outputconfiguration (wl_resource)
/// --------------------------
/// requests:
/// * enable(outputdevice, bool)
/// * mode(outputdevice, mode_id)
/// * transformation(outputdevice, flag)
/// * position(outputdevice, x, y)
/// * apply
/// events:
/// * applied
/// * failed
/// The server registers one outputmanagement object as a global object. In order
/// to configure outputs a client requests create_configuration, which provides a
/// resource referencing an outputconfiguration for one-time configuration. That
/// way the server knows which requests belong together and can group them by that.
/// On the outputconfiguration object the client calls for each output whether the
/// output should be enabled, which mode should be set (by referencing the mode from
/// the list of announced modes) and the output's global position. Once all outputs
/// are configured that way, the client calls apply.
/// At that point and not earlier the server should try to apply the configuration.
/// If this succeeds the server emits the applied signal, otherwise the failed
/// signal, such that the configuring client is noticed about the success of its
/// configuration request.
/// Through this design the interface enables atomic output configuration changes if
/// internally supported by the server.
public final class KdeOutputmanagement: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_outputmanagement",
            version: 4,
            enums: [],
            requests: [
                Message(
                    name: "create_configuration",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "org_kde_kwin_outputconfiguration"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Provide Outputconfiguration Object For Configuring Outputs
    /// 
    /// Request an outputconfiguration object through which the client can configure
    /// output devices.
    public func createConfiguration(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeOutputconfiguration {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeOutputconfiguration.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: Outputmanagement)
    }
    
    public typealias Event = NoEvent
}
/// Configure Single Output Devices
/// 
/// outputconfiguration is a client-specific resource that can be used to ask
/// the server to apply changes to available output devices.
/// The client receives a list of output devices from the registry. When it wants
/// to apply new settings, it creates a configuration object from the
/// outputmanagement global, writes changes through this object's enable, scale,
/// transform and mode calls. It then asks the server to apply these settings in
/// an atomic fashion, for example through Linux' DRM interface.
/// The server signals back whether the new settings have applied successfully
/// or failed to apply. outputdevice objects are updated after the changes have been
/// applied to the hardware and before the server side sends the applied event.
public final class KdeOutputconfiguration: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_outputconfiguration",
            version: 4,
            enums: [],
            requests: [
                Message(
                    name: "enable",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "org_kde_kwin_outputdevice"
                    ),
                    Argument(
                        name: "enable",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "mode",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "org_kde_kwin_outputdevice"
                    ),
                    Argument(
                        name: "mode_id",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "transform",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "org_kde_kwin_outputdevice"
                    ),
                    Argument(
                        name: "transform",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "position",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "org_kde_kwin_outputdevice"
                    ),
                    Argument(
                        name: "x",
                        type: .int,
                    ),
                    Argument(
                        name: "y",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "scale",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "org_kde_kwin_outputdevice"
                    ),
                    Argument(
                        name: "scale",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "apply",
                    arguments: [
                    ],
                ),
                Message(
                    name: "scalef",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "org_kde_kwin_outputdevice"
                    ),
                    Argument(
                        name: "scale",
                        type: .fixed,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "colorcurves",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "org_kde_kwin_outputdevice"
                    ),
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
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 2
                ),
                Message(
                    name: "overscan",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "org_kde_kwin_outputdevice"
                    ),
                    Argument(
                        name: "overscan",
                        type: .uint,
                    ),
                    ],
                    since: 3
                ),
                Message(
                    name: "set_vrr_policy",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "org_kde_kwin_outputdevice"
                    ),
                    Argument(
                        name: "policy",
                        type: .uint,
                    ),
                    ],
                    since: 4
                ),
                ],
            events: [
                Message(
                    name: "applied",
                    arguments: [
                    ],
                ),
                Message(
                    name: "failed",
                    arguments: [
                    ],
                ),
                ],
        )
    /// Enable Or Disable An Output
    /// 
    /// Mark the output as enabled or disabled.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice to be en- or disabled
    ///   - enable: 1 to enable or 0 to disable this output
    public func enable(outputdevice: KdeOutputdevice, enable: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(outputdevice.id),
            .int(enable),
        ])
    }

    /// Switch Outputdevice To Mode
    /// 
    /// Sets the mode for a given output by its mode size (width and height) and refresh rate.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this mode change applies to
    ///   - modeId: aspired mode's id
    public func mode(outputdevice: KdeOutputdevice, modeId: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(outputdevice.id),
            .int(modeId),
        ])
    }

    /// Transform Outputdevice
    /// 
    /// Sets the transformation for a given output.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this transformation change applies to
    ///   - transform: transform enum
    public func transform(outputdevice: KdeOutputdevice, transform: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(outputdevice.id),
            .int(transform),
        ])
    }

    /// Position Output In Global Space
    /// 
    /// Sets the position for this output device. (x,y) describe the top-left corner
    /// of the output in global space, whereby the origin (0,0) of the global space
    /// has to be aligned with the top-left corner of the most left and in case this
    /// does not define a single one the top output.
    /// There may be no gaps or overlaps between outputs, i.e. the outputs are
    /// stacked horizontally, vertically, or both on each other.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this position applies to
    ///   - x: position on the x-axis
    ///   - y: position on the y-axis
    public func position(outputdevice: KdeOutputdevice, x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .object(outputdevice.id),
            .int(x),
            .int(y),
        ])
    }

    /// Set Scaling Factor Of This Output
    /// 
    /// Sets the scaling factor for this output device.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this mode change applies to
    ///   - scale: scaling factor
    public func scale(outputdevice: KdeOutputdevice, scale: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .object(outputdevice.id),
            .int(scale),
        ])
    }

    /// Apply Configuration Changes To All Output Devices
    /// 
    /// Asks the server to apply property changes requested through this outputconfiguration
    /// object to all outputs on the server side.
    public func apply() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
        ])
    }

    /// Set Scaling Factor Of This Output
    /// 
    /// Sets the scaling factor for this output device.
    /// Sending both scale and scalef is undefined.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this mode change applies to
    ///   - scale: scaling factor
    public func scalef(outputdevice: KdeOutputdevice, scale: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 6, [
            .object(outputdevice.id),
            .fixed(scale),
        ])
    }

    /// Set Output Color Curves
    /// 
    /// Set color curves of output devices through RGB color ramps. Allows color
    /// correction of output device from user space.
    /// These are the raw values. A compositor might opt to adjust these values
    /// internally, for example to shift color temperature at night.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice curves apply to
    ///   - red: red color ramp
    ///   - green: green color ramp
    ///   - blue: blue color ramp
    public func colorcurves(outputdevice: KdeOutputdevice, red: Data, green: Data, blue: Data) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 7, [
            .object(outputdevice.id),
            .array(red),
            .array(green),
            .array(blue),
        ])
    }

    /// Release The Outputconfiguration Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        self.markDead()
        connection.send(self, 8, [
        ])
    }

    /// Set Overscan Value
    /// 
    /// Set the overscan value of this output device with a value in percent.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice overscan applies to
    ///   - overscan: overscan value
    public func overscan(outputdevice: KdeOutputdevice, overscan: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 9, [
            .object(outputdevice.id),
            .uint(overscan),
        ])
    }

    /// Set The Vrr Policy
    /// 
    /// Set what policy the compositor should employ regarding its use of
    /// variable refresh rate.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this VRR policy applies to
    ///   - policy: the vrr policy to apply
    public func setVrrPolicy(outputdevice: KdeOutputdevice, policy: VrrPolicy) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 10, [
            .object(outputdevice.id),
            .uint(policy.rawValue),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: Outputmanagement)
    }
    
    public enum VrrPolicy: UInt32 {
        case never = 0

        case always = 1

        case automatic = 2
    }

    var destructor: Destructor? = .destroy

    enum Destructor {
        case destroy
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .destroy: try? self.destroy()
                case nil: break
            }
        }
    }

    public enum Event: Decodable {
        /// Configuration Changes Have Been Applied
        /// 
        /// Sent after the server has successfully applied the changes.
        /// .
        case applied

        /// Configuration Changes Failed To Apply
        /// 
        /// Sent if the server rejects the changes or failed to apply them.
        case failed

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.applied
            case 1:
                self = Self.failed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let Outputmanagement = Protocol(
        name: "outputmanagement",
        interfaces: [
            KdeOutputmanagement.interface,
KdeOutputconfiguration.interface
        ]
    )

#endif