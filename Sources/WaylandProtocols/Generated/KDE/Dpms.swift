import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Output Dpms Manager
/// 
/// The Dpms manager allows to get a org_kde_kwin_dpms for a given wl_output.
/// The org_kde_kwin_dpms provides the currently used VESA Display Power Management
/// Signaling state (see https://en.wikipedia.org/wiki/VESA_Display_Power_Management_Signaling ).
/// In addition it allows to request a state change. A compositor is not obliged to honor it
/// and will normally automatically switch back to on state.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class KdeDpmsManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_dpms_manager",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "get",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "org_kde_kwin_dpms"
                    ),
                    Argument(
                        name: "output",
                        type: .object,
                        interface: "wl_output"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Get Org_Kde_Kwin_Dpms For Wl_Output
    /// 
    /// Factory request to get the org_kde_kwin_dpms for a given wl_output.
    /// 
    /// - Parameters:
    public func `get`(output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeDpms {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeDpms.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(output.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: DpmsProtocol)
    }
    
    public typealias Event = NoEvent
}
/// Dpms For A Wl_Output
/// 
/// This interface provides information about the VESA DPMS state for a wl_output.
/// It gets created through the request get on the org_kde_kwin_dpms_manager interface.
/// On creating the resource the server will push whether DPSM is supported for the output,
/// the currently used DPMS state and notifies the client through the done event once all
/// states are pushed. Whenever a state changes the set of changes is committed with the
/// done event.
public final class KdeDpms: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_dpms",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "set",
                    arguments: [
                    Argument(
                        name: "mode",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "supported",
                    arguments: [
                    Argument(
                        name: "supported",
                        type: .uint,
                    ),
                    ],
                ),
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
                    name: "done",
                    arguments: [
                    ],
                ),
                ],
        )
    /// Request Dpms State Change For The Wl_Output
    /// 
    /// Requests that the compositor puts the wl_output into the passed mode. The compositor
    /// is not obliged to change the state. In addition the compositor might leave the mode
    /// whenever it seems suitable. E.g. the compositor might return to On state on user input.
    /// The client should not assume that the mode changed after requesting a new mode.
    /// Instead the client should listen for the mode event.
    /// 
    /// - Parameters:
    ///   - mode: Requested mode
    public func `set`(mode: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(mode),
        ])
    }

    /// Release The Dpms Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: DpmsProtocol)
    }
    
    public enum Mode: UInt32 {
        case on = 0

        case standby = 1

        case suspend = 2

        case off = 3
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
        /// Event Indicating Whether Dpms Is Supported On The Wl_Output
        /// 
        /// This event gets pushed on binding the resource and indicates whether the wl_output
        /// supports DPMS. There are operation modes of a Wayland server where DPMS might not
        /// make sense (e.g. nested compositors).
        case supported(supported: UInt32)

        /// Event Indicating Used Dpms Mode
        /// 
        /// This mode gets pushed on binding the resource and provides the currently used
        /// DPMS mode. It also gets pushed if DPMS is not supported for the wl_output, in that
        /// case the value will be On.
        /// The event is also pushed whenever the state changes.
        case mode(mode: UInt32)

        /// All Changes Are Pushed
        /// 
        /// This event gets pushed on binding the resource once all other states are pushed.
        /// In addition it gets pushed whenever a state changes to tell the client that all
        /// state changes have been pushed.
        case done

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.supported(supported: r.uint())
            case 1:
                self = Self.mode(mode: r.uint())
            case 2:
                self = Self.done
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let DpmsProtocol = Protocol(
        name: "dpms",
        interfaces: [
            KdeDpmsManager.interface,
KdeDpms.interface
        ]
    )

#endif