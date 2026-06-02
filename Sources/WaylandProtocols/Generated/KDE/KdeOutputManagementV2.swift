import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Configuration Of Server Outputs Through Clients
/// 
/// This interface enables clients to set properties of output devices for screen
/// configuration purposes via the server. To this end output devices are referenced
/// by global kde_output_device_v2 objects.
/// outputmanagement (wl_global)
/// --------------------------
/// request:
/// * create_configuration -> outputconfiguration (wl_resource)
/// outputconfiguration (wl_resource)
/// --------------------------
/// requests:
/// * enable(outputdevice, bool)
/// * mode(outputdevice, mode)
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
/// Warning! The protocol described in this file is a desktop environment implementation
/// detail. Regular clients must not use this protocol. Backward incompatible
/// changes may be added without bumping the major version of the extension.
public final class KdeOutputManagementV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_output_management_v2",
            version: 21,
            enums: [],
            requests: [
                Message(
                    name: "create_configuration",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "kde_output_configuration_v2",
                    ),
                    ],
                ),
                Message(
                    name: "create_mode_list",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "kde_mode_list_v2",
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
    public func createConfiguration(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeOutputConfigurationV2 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeOutputConfigurationV2.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
        ])
        return id
    }

    /// Create A List Of Custom Modes
    /// 
    /// For details, see the description of kde_mode_list_v2 and
    /// kde_output_configuration_v2.set_custom_modes.
    public func createModeList(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeModeListV2 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeModeListV2.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdeOutputManagementV2Protocol)
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
public final class KdeOutputConfigurationV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_output_configuration_v2",
            version: 21,
            enums: [],
            requests: [
                Message(
                    name: "enable",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
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
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "mode",
                        type: .object,
                        interface: "kde_output_device_mode_v2",
                    ),
                    ],
                ),
                Message(
                    name: "transform",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
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
                        interface: "kde_output_device_v2",
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
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "scale",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "apply",
                    arguments: [
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "overscan",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "overscan",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_vrr_policy",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "policy",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_rgb_range",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "rgb_range",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_primary_output",
                    arguments: [
                    Argument(
                        name: "output",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "set_priority",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "priority",
                        type: .uint,
                    ),
                    ],
                    since: 3
                ),
                Message(
                    name: "set_high_dynamic_range",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "enable_hdr",
                        type: .uint,
                    ),
                    ],
                    since: 4
                ),
                Message(
                    name: "set_sdr_brightness",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "sdr_brightness",
                        type: .uint,
                    ),
                    ],
                    since: 4
                ),
                Message(
                    name: "set_wide_color_gamut",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "enable_wcg",
                        type: .uint,
                    ),
                    ],
                    since: 4
                ),
                Message(
                    name: "set_auto_rotate_policy",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "policy",
                        type: .uint,
                    ),
                    ],
                    since: 5
                ),
                Message(
                    name: "set_icc_profile_path",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "profile_path",
                        type: .string,
                    ),
                    ],
                    since: 6
                ),
                Message(
                    name: "set_brightness_overrides",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "max_peak_brightness",
                        type: .int,
                    ),
                    Argument(
                        name: "max_frame_average_brightness",
                        type: .int,
                    ),
                    Argument(
                        name: "min_brightness",
                        type: .int,
                    ),
                    ],
                    since: 7
                ),
                Message(
                    name: "set_sdr_gamut_wideness",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "gamut_wideness",
                        type: .uint,
                    ),
                    ],
                    since: 7
                ),
                Message(
                    name: "set_color_profile_source",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "color_profile_source",
                        type: .uint,
                    ),
                    ],
                    since: 8
                ),
                Message(
                    name: "set_brightness",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "brightness",
                        type: .uint,
                    ),
                    ],
                    since: 9
                ),
                Message(
                    name: "set_color_power_tradeoff",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "preference",
                        type: .uint,
                    ),
                    ],
                    since: 10
                ),
                Message(
                    name: "set_dimming",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "multiplier",
                        type: .uint,
                    ),
                    ],
                    since: 11
                ),
                Message(
                    name: "set_replication_source",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "source",
                        type: .string,
                    ),
                    ],
                    since: 13
                ),
                Message(
                    name: "set_ddc_ci_allowed",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "allowed",
                        type: .uint,
                    ),
                    ],
                    since: 14
                ),
                Message(
                    name: "set_max_bits_per_color",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "max_bpc",
                        type: .uint,
                    ),
                    ],
                    since: 15
                ),
                Message(
                    name: "set_edr_policy",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "policy",
                        type: .uint,
                    ),
                    ],
                    since: 16
                ),
                Message(
                    name: "set_sharpness",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "sharpness",
                        type: .uint,
                    ),
                    ],
                    since: 17
                ),
                Message(
                    name: "set_custom_modes",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "modes",
                        type: .object,
                        interface: "kde_mode_list_v2",
                    ),
                    ],
                    since: 18
                ),
                Message(
                    name: "set_auto_brightness",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "enabled",
                        type: .uint,
                    ),
                    ],
                    since: 19
                ),
                Message(
                    name: "set_hdr_icc_profile_path",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "profile_path",
                        type: .string,
                    ),
                    ],
                    since: 20
                ),
                Message(
                    name: "set_hdr_color_profile_source",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "color_profile_source",
                        type: .uint,
                    ),
                    ],
                    since: 20
                ),
                Message(
                    name: "set_abm_level",
                    arguments: [
                    Argument(
                        name: "outputdevice",
                        type: .object,
                        interface: "kde_output_device_v2",
                    ),
                    Argument(
                        name: "level",
                        type: .uint,
                    ),
                    ],
                    since: 21
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
                Message(
                    name: "failure_reason",
                    arguments: [
                    Argument(
                        name: "reason",
                        type: .string,
                    ),
                    ],
                    since: 12
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
    public func enable(outputdevice: KdeOutputDeviceV2, enable: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(outputdevice.id),
            .int(enable),
        ])
    }

    /// Switch Output-Device To Mode
    /// 
    /// Sets the mode for a given output.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this mode change applies to
    ///   - mode: the mode to apply
    public func mode(outputdevice: KdeOutputDeviceV2, mode: KdeOutputDeviceModeV2) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(outputdevice.id),
            .object(mode.id),
        ])
    }

    /// Transform Output-Device
    /// 
    /// Sets the transformation for a given output.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this transformation change applies to
    ///   - transform: transform enum
    public func transform(outputdevice: KdeOutputDeviceV2, transform: Int32) throws(WaylandProxyError) {
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
    public func position(outputdevice: KdeOutputDeviceV2, x: Int32, y: Int32) throws(WaylandProxyError) {
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
    ///   - outputdevice: outputdevice this scale change applies to
    ///   - scale: scaling factor
    public func scale(outputdevice: KdeOutputDeviceV2, scale: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .object(outputdevice.id),
            .fixed(scale),
        ])
    }

    /// Apply Configuration Changes To All Output Devices
    /// 
    /// Asks the server to apply property changes requested through this outputconfiguration
    /// object to all outputs on the server side.
    /// The output configuration can be applied only once. The already_applied protocol error
    /// will be posted if the apply request is called the second time.
    public func apply() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
        ])
    }

    /// Release The Outputconfiguration Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 6, [
        ])
    }

    /// Set Overscan Value
    /// 
    /// Set the overscan value of this output device with a value in percent.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice overscan applies to
    ///   - overscan: overscan value
    public func overscan(outputdevice: KdeOutputDeviceV2, overscan: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
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
    public func setVrrPolicy(outputdevice: KdeOutputDeviceV2, policy: VrrPolicy) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .object(outputdevice.id),
            .uint(policy.rawValue),
        ])
    }

    /// Rgb Range
    /// 
    /// Whether full or limited color range should be used
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice the rgb range applies to
    public func setRgbRange(outputdevice: KdeOutputDeviceV2, rgbRange: RgbRange) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 9, [
            .object(outputdevice.id),
            .uint(rgbRange.rawValue),
        ])
    }

    /// Select Which Primary Output To Use
    /// 
    /// 
    /// 
    /// - Parameters:
    public func setPrimaryOutput(output: KdeOutputDeviceV2) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 10, [
            .object(output.id),
        ])
    }

    /// Set The Order Of Outputs
    /// 
    /// Set the position of the output in the output order list, with lower values
    /// being earlier in the list. There's no specific value the list has to start
    /// at, this value is only used in sorting outputs.
    /// The order of outputs can be used to assign desktop environment components
    /// to a specific screen, see kde_output_order_v1 and kde-output-device-v2 for
    /// details. Note that for consistent behavior, the priority value needs to be
    /// unique among all enabled outputs.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice the index applies to
    ///   - priority: the priority of the output
    public func setPriority(outputdevice: KdeOutputDeviceV2, priority: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 11, [
            .object(outputdevice.id),
            .uint(priority),
        ])
    }

    /// Change If Hdr Should Be Enabled
    /// 
    /// Sets whether or not the output should be set to HDR mode.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - enableHdr: 1 to enable, 0 to disable hdr
    public func setHighDynamicRange(outputdevice: KdeOutputDeviceV2, enableHdr: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 12, [
            .object(outputdevice.id),
            .uint(enableHdr),
        ])
    }

    /// Set The Brightness For Sdr Content
    /// 
    /// Sets the brightness of standard dynamic range content in nits. Only has an effect while the output is in HDR mode.
    /// Note that while the value is in nits, that doesn't necessarily translate to the same brightness on the screen.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setSdrBrightness(outputdevice: KdeOutputDeviceV2, sdrBrightness: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 13, [
            .object(outputdevice.id),
            .uint(sdrBrightness),
        ])
    }

    /// Change If A Wide Color Gamut Should Be Used
    /// 
    /// Whether or not the output should use a wide color gamut
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - enableWcg: 1 to enable, 0 to disable wcg
    public func setWideColorGamut(outputdevice: KdeOutputDeviceV2, enableWcg: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 14, [
            .object(outputdevice.id),
            .uint(enableWcg),
        ])
    }

    /// Change When Auto Rotate Should Be Used
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setAutoRotatePolicy(outputdevice: KdeOutputDeviceV2, policy: AutoRotatePolicy) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 5 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 5) }
        connection.send(self, 15, [
            .object(outputdevice.id),
            .uint(policy.rawValue),
        ])
    }

    /// Change The Used Icc Profile For Sdr Mode
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setIccProfilePath(outputdevice: KdeOutputDeviceV2, profilePath: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 6 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 6) }
        connection.send(self, 16, [
            .object(outputdevice.id),
            .string(profilePath),
        ])
    }

    /// Override Metadata About The Screen's Brightness Limits
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - maxPeakBrightness: -1 for not overriding, or positive values in nits
    ///   - maxFrameAverageBrightness: -1 for not overriding, or positive values in nits
    ///   - minBrightness: -1 for not overriding, or positive values in 0.0001 nits
    public func setBrightnessOverrides(outputdevice: KdeOutputDeviceV2, maxPeakBrightness: Int32, maxFrameAverageBrightness: Int32, minBrightness: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 7 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 7) }
        connection.send(self, 17, [
            .object(outputdevice.id),
            .int(maxPeakBrightness),
            .int(maxFrameAverageBrightness),
            .int(minBrightness),
        ])
    }

    /// Describes Which Gamut Is Assumed For Srgb Applications
    /// 
    /// This can be used to provide the colors users assume sRGB applications should have based on the
    /// default experience on many modern sRGB screens.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - gamutWideness: 0 means rec.709 primaries, 10000 means native primaries
    public func setSdrGamutWideness(outputdevice: KdeOutputDeviceV2, gamutWideness: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 7 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 7) }
        connection.send(self, 18, [
            .object(outputdevice.id),
            .uint(gamutWideness),
        ])
    }

    /// Which Source The Compositor Should Use For The Color Profile On An Output In Sdr Mode
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - colorProfileSource: the color profile source
    public func setColorProfileSource(outputdevice: KdeOutputDeviceV2, colorProfileSource: ColorProfileSource) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 8 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 8) }
        connection.send(self, 19, [
            .object(outputdevice.id),
            .uint(colorProfileSource.rawValue),
        ])
    }

    /// Brightness Multiplier
    /// 
    /// Set the brightness modifier of the output. It doesn't specify
    /// any absolute values, but is merely a multiplier on top of other
    /// brightness values, like sdr_brightness and brightness_metadata.
    /// 0 is the minimum brightness (not completely dark) and 10000 is
    /// the maximum brightness.
    /// This is supported while HDR is active in versions 8 and below,
    /// or when the device supports the "brightness" capability in
    /// versions 9 and above.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - brightness: brightness in 0-10000
    public func setBrightness(outputdevice: KdeOutputDeviceV2, brightness: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 9 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 9) }
        connection.send(self, 20, [
            .object(outputdevice.id),
            .uint(brightness),
        ])
    }

    /// Set The Preferred Color/Power Tradeoff
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setColorPowerTradeoff(outputdevice: KdeOutputDeviceV2, preference: ColorPowerTradeoff) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 10 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 10) }
        connection.send(self, 21, [
            .object(outputdevice.id),
            .uint(preference.rawValue),
        ])
    }

    /// Dimming Multiplier
    /// 
    /// Set the dimming multiplier of the output. This is similar to the
    /// brightness setting, except it's meant to be a temporary setting
    /// only, not persistent and may be implemented differently depending
    /// on the display.
    /// 0 is the minimum dimming factor (not completely dark) and 10000
    /// means the output is not dimmed.
    /// This is supported only when the "brightness" capability is
    /// also supported.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - multiplier: multiplier in 0-10000
    public func setDimming(outputdevice: KdeOutputDeviceV2, multiplier: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 11 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 11) }
        connection.send(self, 22, [
            .object(outputdevice.id),
            .uint(multiplier),
        ])
    }

    /// Source Output For Mirroring
    /// 
    /// Set the source output that the outputdevice should mirror its
    /// viewport from.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - source: uuid of the source output
    public func setReplicationSource(outputdevice: KdeOutputDeviceV2, source: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 13 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 13) }
        connection.send(self, 23, [
            .object(outputdevice.id),
            .string(source),
        ])
    }

    /// If Ddc/Ci Should Be Used To Control Brightness Etc.
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - allowed: 1 if allowed, 0 if disabled
    public func setDdcCiAllowed(outputdevice: KdeOutputDeviceV2, allowed: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 14 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 14) }
        connection.send(self, 24, [
            .object(outputdevice.id),
            .uint(allowed),
        ])
    }

    /// Override The Max Bpc
    /// 
    /// This limits the amount of bits per color that are sent to the display.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - maxBpc: 0 for the default / automatic
    public func setMaxBitsPerColor(outputdevice: KdeOutputDeviceV2, maxBpc: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 15 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 15) }
        connection.send(self, 25, [
            .object(outputdevice.id),
            .uint(maxBpc),
        ])
    }

    /// Set When The Compositor May Apply Edr
    /// 
    /// When EDR is enabled, the compositor may increase the backlight beyond
    /// the user-specified setting, in order to present HDR content on displays
    /// without native HDR support.
    /// This will usually result in better visuals, but also increases battery
    /// usage.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setEdrPolicy(outputdevice: KdeOutputDeviceV2, policy: EdrPolicy) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 16 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 16) }
        connection.send(self, 26, [
            .object(outputdevice.id),
            .uint(policy.rawValue),
        ])
    }

    /// Sharpness Strength
    /// 
    /// This is the sharpness modifier of the output.
    /// 0 is sharpness disabled and 10000 is the maximum sharpness
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - sharpness: sharpness in 0-10000
    public func setSharpness(outputdevice: KdeOutputDeviceV2, sharpness: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 17 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 17) }
        connection.send(self, 27, [
            .object(outputdevice.id),
            .uint(sharpness),
        ])
    }

    /// Set The Custom Mode List
    /// 
    /// Set the list of custom modes for this output. The compositor
    /// will in response generate the requested modes and add them to
    /// the output (or delete ones no longer in the list).
    /// This can be useful for overclocking displays, or for working
    /// around broken EDIDs.
    /// Note that there is no guarantee for any custom mode to
    /// actually work, or even to leave the display undamaged (in the
    /// case of CRTs). It's entirely the responsibility of the user
    /// to ensure each added mode is the right one for their display.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setCustomModes(outputdevice: KdeOutputDeviceV2, modes: KdeModeListV2) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 18 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 18) }
        connection.send(self, 28, [
            .object(outputdevice.id),
            .object(modes.id),
        ])
    }

    /// Whether Or Not Automatic Brightness Is Enabled
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - enabled: 1 for enabled, 0 for disabled
    public func setAutoBrightness(outputdevice: KdeOutputDeviceV2, enabled: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 19 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 19) }
        connection.send(self, 29, [
            .object(outputdevice.id),
            .uint(enabled),
        ])
    }

    /// Change The Used Icc Profile For Hdr Mode
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setHdrIccProfilePath(outputdevice: KdeOutputDeviceV2, profilePath: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 20 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 20) }
        connection.send(self, 30, [
            .object(outputdevice.id),
            .string(profilePath),
        ])
    }

    /// Which Source The Compositor Should Use For The Color Profile On An Output In Hdr Mode
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - colorProfileSource: the color profile source
    public func setHdrColorProfileSource(outputdevice: KdeOutputDeviceV2, colorProfileSource: ColorProfileSource) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 20 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 20) }
        connection.send(self, 31, [
            .object(outputdevice.id),
            .uint(colorProfileSource.rawValue),
        ])
    }

    /// Set The Allowed Level Of Adaptive Backlight Modulation
    /// 
    /// Adaptive backlight modulation is a feature that reduces the backlight
    /// and increases contrast of colors on the screen to improve power usage.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - level: 0 is off, 4 is the maximum level
    public func setAbmLevel(outputdevice: KdeOutputDeviceV2, level: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 21 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 21) }
        connection.send(self, 32, [
            .object(outputdevice.id),
            .uint(level),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdeOutputManagementV2Protocol)
    }
    
    public enum Error: UInt32 {
        /// the config is already applied
        case alreadyApplied = 0
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

        /// Reason For Failure
        /// 
        /// Describes why applying the output configuration failed. Is only
        /// sent before the failure event.
        case failureReason(reason: String)

        public init(from r: some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.applied
            case 1:
                self = Self.failed
            case 2:
                self = Self.failureReason(reason: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// A List Of Custom Modes
/// 
/// This list is populated by first setting each relevant property,
/// and then calling add_mode to add a mode with these properties.
/// One would for example call
/// - set_resolution
/// - set_refresh_rate
/// - set_reduced_blanking
/// - add_mode
/// add_mode does not reset the properties that were previously set,
/// they are valid until the object is destroyed.
/// The compositor may additionally have sensible defaults for some
/// properties like reduced_blanking, but for consistent results,
/// it's best to always set each known property every time.
/// The parameters resolution and refresh rate are required, if they
/// are not set, the missing_parameters error will be emitted.
public final class KdeModeListV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_mode_list_v2",
            version: 20,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "add_mode",
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_resolution",
                    arguments: [
                    Argument(
                        name: "width",
                        type: .uint,
                    ),
                    Argument(
                        name: "height",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_refresh_rate",
                    arguments: [
                    Argument(
                        name: "rate",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_reduced_blanking",
                    arguments: [
                    Argument(
                        name: "reduced",
                        type: .uint,
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Mode List Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Add The Current Mode Configuration To The List
    /// 
    /// 
    public func addMode() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    /// 
    /// - Parameters:
    public func setResolution(width: UInt32, height: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .uint(width),
            .uint(height),
        ])
    }

    /// 
    /// - Parameters:
    ///   - rate: in milliHz
    public func setRefreshRate(rate: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(rate),
        ])
    }

    /// Whether Or Not The Mode Should Have Reduced Blanking
    /// 
    /// Reduced blanking is an optimization that can reduce bandwidth / timing
    /// requirements for a display mode by reducing the time vblank takes.
    /// As not all displays support it, it may be desired to still turn it off
    /// though (like with CRTs, where full blanking is required).
    /// 
    /// - Parameters:
    ///   - reduced: 1 for reduced blanking, 0 for normal vblank duration
    public func setReducedBlanking(reduced: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .uint(reduced),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdeOutputManagementV2Protocol)
    }
    
    public enum Error: UInt32 {
        /// a required parameter wasn't set
        case missingParameters = 0
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

    public typealias Event = NoEvent
}

public let KdeOutputManagementV2Protocol = Protocol(
        name: "kde_output_management_v2",
        interfaces: [
            KdeOutputManagementV2.interface,
KdeOutputConfigurationV2.interface,
KdeModeListV2.interface
        ]
    )

#endif