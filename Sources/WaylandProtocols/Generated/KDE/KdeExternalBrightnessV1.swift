import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// External Brightness Control
/// 
/// Some brightness control mechanisms are somewhat unstable, or require root
/// privileges, so putting them inside of the compositor is not desired.
/// This protocol is for outsourcing the actual brightness-setting to a
/// process outside of the compositor.
public final class KdeExternalBrightnessV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_external_brightness_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "create_brightness_control",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "kde_external_brightness_device_v1",
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Object.
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Registers A Brightness Device With The Compositor
    /// 
    /// 
    public func createBrightnessControl(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeExternalBrightnessDeviceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeExternalBrightnessDeviceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdeExternalBrightnessV1Protocol)
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
/// Brightness Control Device
/// 
/// After creating this object, the client should issue all relevant setup requests
/// (set_internal, set_edid, set_max_brightness, optionally set_observed_brightness)
/// and finish the sequence with commit.
/// Afterwards, for each change in values, the client must call commit again.
public final class KdeExternalBrightnessDeviceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_external_brightness_device_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_internal",
                    arguments: [
                    Argument(
                        name: "internal",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_edid",
                    arguments: [
                    Argument(
                        name: "string",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "set_max_brightness",
                    arguments: [
                    Argument(
                        name: "value",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "commit",
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_observed_brightness",
                    arguments: [
                    Argument(
                        name: "value",
                        type: .uint,
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "set_uses_ddc_ci",
                    arguments: [
                    Argument(
                        name: "value",
                        type: .uint,
                    ),
                    ],
                    since: 3
                ),
                ],
            events: [
                Message(
                    name: "requested_brightness",
                    arguments: [
                    Argument(
                        name: "value",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
    /// Destroy The Object And Unregister The Brightness Control Device
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Sets Whether Or Not The Brightness Device Belongs To An Internal Display
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - _: 1 if it's an internal panel, 0 if not
    public func setInternal(_ `internal`: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(`internal`),
        ])
    }

    /// Set The Edid Data For Identification Of The Display
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - string: base-64 encoded string of the first 128 bytes of the EDID
    public func setEdid(string: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .string(string),
        ])
    }

    /// Notifies The Compositor Of The Maximum Brightness That Can Be Set On This Device
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - value: the maximum value that can be set
    public func setMaxBrightness(value: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(value),
        ])
    }

    /// Notifies The Compositor That All Relevant Identifiers And Values Have Been Sent
    /// 
    /// 
    public func commit() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
        ])
    }

    /// Notifies The Compositor Of The Brightness That Was Read From This Device
    /// 
    /// The client can set this to notify the compositor of the device's initial brightness.
    /// It can also set this again after the initial commit to notify the compositor that
    /// the brightness level has changed due to external factors.
    /// The compositor is free to use or ignore this value as it sees fit.
    /// 
    /// - Parameters:
    ///   - value: the observed value that was read
    public func setObservedBrightness(value: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 5, [
            .uint(value),
        ])
    }

    /// Notifies The Compositor That Ddc/Ci Is Used To Control Brightness Etc.
    /// 
    /// The compositor can use this information to ignore this object if its commands
    /// expose monitor issues. The compositor may also reduce the amount of brightness
    /// requests given potentially slow response times and concerns about monitor EEPROM
    /// longevity/wear-out.
    /// 
    /// - Parameters:
    ///   - value: 1 if it uses DDC/CI, 0 if not (assumed by default)
    public func setUsesDdcCi(value: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 6, [
            .uint(value),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdeExternalBrightnessV1Protocol)
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
        /// Requests The Client To Change The Brightness To This Value
        /// 
        /// The client must ensure that if the brightness level changes due to external factors,
        /// that it either overwrites those changes with what the compositor last requested,
        /// or commit again with set_observed_brightness specifying the changed brightness.
        case requestedBrightness(value: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.requestedBrightness(value: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let KdeExternalBrightnessV1Protocol = Protocol(
        name: "kde_external_brightness_v1",
        interfaces: [
            KdeExternalBrightnessV1.interface,
KdeExternalBrightnessDeviceV1.interface
        ]
    )

#endif