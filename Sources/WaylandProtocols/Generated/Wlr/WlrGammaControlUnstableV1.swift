import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WLR
/// Manager To Create Per-Output Gamma Controls
/// 
/// This interface is a manager that allows creating per-output gamma
/// controls.
public final class ZwlrGammaControlManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_gamma_control_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "get_gamma_control",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_gamma_control_v1",
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
    /// Get A Gamma Control For An Output
    /// 
    /// Create a gamma control that can be used to adjust gamma tables for the
    /// provided output.
    /// 
    /// - Parameters:
    public func getGammaControl(output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrGammaControlV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwlrGammaControlV1.self, version: self.version, queue: _queue ?? self.queue)
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

    
    public static let `protocol`: Protocol = WlrGammaControlUnstableV1Protocol
    
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

/// Adjust Gamma Tables For An Output
/// 
/// This interface allows a client to adjust gamma tables for a particular
/// output.
/// The client will receive the gamma size, and will then be able to set gamma
/// tables. At any time the compositor can send a failed event indicating that
/// this object is no longer valid.
/// There can only be at most one gamma control object per output, which
/// has exclusive access to this particular output. When the gamma control
/// object is destroyed, the gamma table is restored to its original value.
public final class ZwlrGammaControlV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_gamma_control_v1",
            version: 1,
            requests: [
                Message(
                    name: "set_gamma",
                    arguments: [
                        Argument(
                            name: "fd",
                            type: .fd,
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
                    name: "gamma_size",
                    arguments: [
                        Argument(
                            name: "size",
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
    /// Set The Gamma Table
    /// 
    /// Set the gamma table. The file descriptor can be memory-mapped to provide
    /// the raw gamma table, which contains successive gamma ramps for the red,
    /// green and blue channels. Each gamma ramp is an array of 16-byte unsigned
    /// integers which has the same length as the gamma size.
    /// The file descriptor data must have the same length as three times the
    /// gamma size.
    /// 
    /// - Parameters:
    ///   - fd: gamma table file descriptor
    public func setGamma(fd: FileHandle) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .fd(fd),
        ])
    }

    /// Destroy This Control
    /// 
    /// Destroys the gamma control object. If the object is still valid, this
    /// restores the original gamma tables.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrGammaControlUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// invalid gamma tables
        case invalidGamma = 1
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
        /// Size Of Gamma Ramps
        /// 
        /// Advertise the size of each gamma ramp.
        /// This event is sent immediately when the gamma control object is created.
        case gammaSize(size: UInt32)

        /// Object No Longer Valid
        /// 
        /// This event indicates that the gamma control is no longer valid. This
        /// can happen for a number of reasons, including:
        /// - The output doesn't support gamma tables
        /// - Setting the gamma tables failed
        /// - Another client already has exclusive gamma control for this output
        /// - The compositor has transferred gamma control to another client
        /// Upon receiving this event, the client should destroy this object.
        case failed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.gammaSize(size: r.uint())
            case 1:
                self = Self.failed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let WlrGammaControlUnstableV1Protocol = Protocol(
        name: "wlr_gamma_control_unstable_v1",
        interfaces: [
            ZwlrGammaControlManagerV1.interface,
ZwlrGammaControlV1.interface
        ]
    )

#endif