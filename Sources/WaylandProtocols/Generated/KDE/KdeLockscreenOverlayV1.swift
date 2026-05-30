import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Allow Surfaces Over The Lockscreen
/// 
/// Allows a client to request a surface to be visible when the system is locked.
/// This is meant to be used for specific high urgency cases like phone calls or alarms.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class KdeLockscreenOverlayV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_lockscreen_overlay_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "allow",
                    arguments: [
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Tell About Which Surface Could Be Raised Above The Lockscreen
    /// 
    /// Informs the compositor that the surface could be shown when the screen is locked. This request should be called while the surface is unmapped.
    /// 
    /// - Parameters:
    public func allow(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(surface.id),
        ])
    }

    /// Destroy The Kde_Lockscreen_Overlay_V1
    /// 
    /// This won't affect the surface previously marked with the allow request.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdeLockscreenOverlayV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// the client provided an invalid surface state
        case invalidSurfaceState = 0
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

public let KdeLockscreenOverlayV1Protocol = Protocol(
        name: "kde_lockscreen_overlay_v1",
        interfaces: [
            KdeLockscreenOverlayV1.interface
        ]
    )

#endif