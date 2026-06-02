import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WLR
/// Inhibits Input Events To Other Clients
/// 
/// Clients can use this interface to prevent input events from being sent to
/// any surfaces but its own, which is useful for example in lock screen
/// software. It is assumed that access to this interface will be locked down
/// to whitelisted clients by the compositor.
/// Note! This protocol is deprecated and not intended for production use.
/// For screen lockers, use the ext-session-lock-v1 protocol.
public final class ZwlrInputInhibitManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_input_inhibit_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "get_inhibitor",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_input_inhibitor_v1",
                        ),
                    ],
                ),
            ],
        )
    /// Inhibit Input To Other Clients
    /// 
    /// Activates the input inhibitor. As long as the inhibitor is active, the
    /// compositor will not send input events to other clients.
    public func getInhibitor(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrInputInhibitorV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwlrInputInhibitorV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrInputInhibitUnstableV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// an input inhibitor is already in use on the compositor
        case alreadyInhibited = 0
    }

    public typealias Event = NoEvent
}

/// Inhibits Input To Other Clients
/// 
/// While this resource exists, input to clients other than the owner of the
/// inhibitor resource will not receive input events. Any client which
/// previously had focus will receive a leave event and will not be given
/// focus again. The client that owns this resource will receive all input
/// events normally. The compositor will also disable all of its own input
/// processing (such as keyboard shortcuts) while the inhibitor is active.
/// The compositor may continue to send input events to selected clients,
/// such as an on-screen keyboard (via the input-method protocol).
public final class ZwlrInputInhibitorV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_input_inhibitor_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
            ],
        )
    /// Destroy The Input Inhibitor Object
    /// 
    /// Destroy the inhibitor and allow other clients to receive input.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrInputInhibitUnstableV1Protocol)
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


public let WlrInputInhibitUnstableV1Protocol = Protocol(
        name: "wlr_input_inhibit_unstable_v1",
        interfaces: [
            ZwlrInputInhibitManagerV1.interface,
ZwlrInputInhibitorV1.interface
        ]
    )

#endif