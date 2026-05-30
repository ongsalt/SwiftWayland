import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if XDG
/// System Bell
/// 
/// This global interface enables clients to ring the system bell.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class XdgSystemBellV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_system_bell_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "ring",
                    arguments: [
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The System Bell Object
    /// 
    /// Notify that the object will no longer be used.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Ring The System Bell
    /// 
    /// This requests rings the system bell on behalf of a client. How ringing
    /// the bell is implemented is up to the compositor. It may be an audible
    /// sound, a visual feedback of some kind, or any other thing including
    /// nothing.
    /// The passed surface should correspond to a toplevel like surface role,
    /// or be null, meaning the client doesn't have a particular toplevel it
    /// wants to associate the bell ringing with. See the xdg-shell protocol
    /// extension for a toplevel like surface role.
    /// 
    /// - Parameters:
    ///   - surface: associated surface
    public func ring(surface: WlSurface? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface?.id ?? 0),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgSystemBellV1)
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

public let XdgSystemBellV1 = Protocol(
        name: "xdg_system_bell_v1",
        interfaces: [
            XdgSystemBellV1.interface
        ]
    )

#endif