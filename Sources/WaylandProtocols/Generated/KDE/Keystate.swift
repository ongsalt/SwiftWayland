import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Key States
/// 
/// Keeps track of the states of the different keys that have a state attached to it.
public final class KdeKeystate: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_keystate",
            version: 5,
            requests: [
                Message(
                    name: "fetchStates",
                    arguments: [],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                    since: 4
                ),
            ],
            events: [
                Message(
                    name: "stateChanged",
                    arguments: [
                        Argument(
                            name: "key",
                            type: .uint,
                        ),
                        Argument(
                            name: "state",
                            type: .uint,
                        ),
                    ],
                ),
            ]
        )
    public func fetchstates() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KeystateProtocol)
    }
    
    public enum Key: UInt32 {
        case capslock = 0

        case numlock = 1

        case scrolllock = 2

        case alt = 3

        case control = 4

        case shift = 5

        case meta = 6

        case altgr = 7
    }

    public enum State: UInt32 {
        case unlocked = 0

        case latched = 1

        case locked = 2

        case pressed = 3
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
        /// Updates The State For A Said Key
        /// 
        /// 
        case statechanged(key: UInt32, state: UInt32)

        public init(from r: some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.statechanged(key: r.uint(), state: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let KeystateProtocol = Protocol(
        name: "keystate",
        interfaces: [
            KdeKeystate.interface
        ]
    )

#endif