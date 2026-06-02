import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WLR
/// Manager To Create Per-Output Power Management
/// 
/// This interface is a manager that allows creating per-output power
/// management mode controls.
public final class ZwlrOutputPowerManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_power_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "get_output_power",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_output_power_v1",
                        ),
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
            ],
        )
    /// Get A Power Management For An Output
    /// 
    /// Create an output power management mode control that can be used to
    /// adjust the power management mode for a given output.
    /// 
    /// - Parameters:
    public func getOutputPower(output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrOutputPowerV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwlrOutputPowerV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(output.id),
        ])
        return id
    }

    /// Destroy The Manager
    /// 
    /// All objects created by the manager will still remain valid, until their
    /// appropriate destroy request has been called.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputPowerManagementUnstableV1Protocol
    
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

/// Adjust Power Management Mode For An Output
/// 
/// This object offers requests to set the power management mode of
/// an output.
public final class ZwlrOutputPowerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_power_v1",
            version: 1,
            requests: [
                Message(
                    name: "set_mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "failed",
                    arguments: [],
                ),
            ]
        )
    /// Set An Outputs Power Save Mode
    /// 
    /// Set an output's power save mode to the given mode. The mode change
    /// is effective immediately. If the output does not support the given
    /// mode a failed event is sent.
    /// 
    /// - Parameters:
    ///   - _: the power save mode to set
    public func setMode(_ mode: Mode) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(mode.rawValue),
        ])
    }

    /// Destroy This Power Management
    /// 
    /// Destroys the output power management mode control object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputPowerManagementUnstableV1Protocol
    
    public enum Mode: UInt32 {
        /// Output is turned off.
        case off = 0

        /// Output is turned on, no power saving
        case on = 1
    }

    public enum Error: UInt32 {
        /// nonexistent power save mode
        case invalidMode = 1
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
        /// Report A Power Management Mode Change
        /// 
        /// Report the power management mode change of an output.
        /// The mode event is sent after an output changed its power
        /// management mode. The reason can be a client using set_mode or the
        /// compositor deciding to change an output's mode.
        /// This event is also sent immediately when the object is created
        /// so the client is informed about the current power management mode.
        case mode(mode: Mode)

        /// Object No Longer Valid
        /// 
        /// This event indicates that the output power management mode control
        /// is no longer valid. This can happen for a number of reasons,
        /// including:
        /// - The output doesn't support power management
        /// - Another client already has exclusive power management mode control
        /// for this output
        /// - The output disappeared
        /// Upon receiving this event, the client should destroy this object.
        case failed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.mode(mode: try _parseEnum(into: Mode.self, r.uint()))
            case 1:
                self = Self.failed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let WlrOutputPowerManagementUnstableV1Protocol = Protocol(
        name: "wlr_output_power_management_unstable_v1",
        interfaces: [
            ZwlrOutputPowerManagerV1.interface,
ZwlrOutputPowerV1.interface
        ]
    )

#endif