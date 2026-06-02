import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// User Idle Time Manager
/// 
/// This interface allows to monitor user idle time on a given seat. The interface
/// allows to register timers which trigger after no user activity was registered
/// on the seat for a given interval. It notifies when user activity resumes.
/// This is useful for applications wanting to perform actions when the user is not
/// interacting with the system, e.g. chat applications setting the user as away, power
/// management features to dim screen, etc..
public final class KdeIdle: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_idle",
            version: 1,
            requests: [
                Message(
                    name: "get_idle_timeout",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_idle_timeout",
                        ),
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        ),
                        Argument(
                            name: "timeout",
                            type: .uint,
                        ),
                    ],
                ),
            ],
        )
    /// 
    /// - Parameters:
    ///   - timeout: The idle timeout in msec
    public func getIdleTimeout(seat: WlSeat, timeout: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeIdleTimeout {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeIdleTimeout.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(seat.id),
            .uint(timeout),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: IdleProtocol)
    }
    
    public typealias Event = NoEvent
}

public final class KdeIdleTimeout: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_idle_timeout",
            version: 1,
            requests: [
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "simulate_user_activity",
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "idle",
                    arguments: [],
                ),
                Message(
                    name: "resumed",
                    arguments: [],
                ),
            ]
        )
    /// Release The Timeout Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Simulates User Activity For This Timeout, Behaves Just Like Real User Activity On The Seat
    /// 
    /// 
    public func simulateUserActivity() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: IdleProtocol)
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
        /// Triggered When There Has Not Been Any User Activity In The Requested Idle Time Interval
        /// 
        /// 
        case idle

        /// Triggered On The First User Activity After An Idle Event
        /// 
        /// 
        case resumed

        public init(from r: some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.idle
            case 1:
                self = Self.resumed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let IdleProtocol = Protocol(
        name: "idle",
        interfaces: [
            KdeIdle.interface,
KdeIdleTimeout.interface
        ]
    )

#endif