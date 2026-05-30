import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if STAGING
/// Surface Alpha Modifier Manager
/// 
/// This interface allows a client to set a factor for the alpha values on a
/// surface, which can be used to offload such operations to the compositor,
/// which can in turn for example offload them to KMS.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpAlphaModifierV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_alpha_modifier_v1",
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
                    name: "get_surface",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wp_alpha_modifier_surface_v1"
                    ),
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
    /// Destroy The Alpha Modifier Manager Object
    /// 
    /// Destroy the alpha modifier manager. This doesn't destroy objects
    /// created with the manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Create A New Alpha Modifier Surface Object
    /// 
    /// Create a new alpha modifier surface object associated with the
    /// given wl_surface. If there is already such an object associated with
    /// the wl_surface, the already_constructed error will be raised.
    /// 
    /// - Parameters:
    public func getSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpAlphaModifierSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpAlphaModifierSurfaceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: AlphaModifierV1)
    }
    
    public enum Error: UInt32 {
        /// wl_surface already has a alpha modifier object
        case alreadyConstructed = 0
    }

    public typealias Event = NoEvent
}
/// Alpha Modifier Object For A Surface
/// 
/// This interface allows the client to set a factor for the alpha values on
/// a surface, which can be used to offload such operations to the compositor.
/// The default factor is UINT32_MAX.
/// This object has to be destroyed before the associated wl_surface. Once the
/// wl_surface is destroyed, all request on this object will raise the
/// no_surface error.
public final class WpAlphaModifierSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_alpha_modifier_surface_v1",
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
                    name: "set_multiplier",
                    arguments: [
                    Argument(
                        name: "factor",
                        type: .uint,
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Alpha Modifier Object
    /// 
    /// This destroys the object, and is equivalent to set_multiplier with
    /// a value of UINT32_MAX, with the same double-buffered semantics as
    /// set_multiplier.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Specify The Alpha Multiplier
    /// 
    /// Sets the alpha multiplier for the surface. The alpha multiplier is
    /// double-buffered state, see wl_surface.commit for details.
    /// This factor is applied in the compositor's blending space, as an
    /// additional step after the processing of per-pixel alpha values for the
    /// wl_surface. The exact meaning of the factor is thus undefined, unless
    /// the blending space is specified in a different extension.
    /// This multiplier is applied even if the buffer attached to the
    /// wl_surface doesn't have an alpha channel; in that case an alpha value
    /// of one is used instead.
    /// Zero means completely transparent, UINT32_MAX means completely opaque.
    /// 
    /// - Parameters:
    public func setMultiplier(factor: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(factor),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: AlphaModifierV1)
    }
    
    public enum Error: UInt32 {
        /// wl_surface was destroyed
        case noSurface = 0
    }

    public typealias Event = NoEvent
}

public let AlphaModifierV1 = Protocol(
        name: "alpha_modifier_v1",
        interfaces: [
            WpAlphaModifierV1.interface,
WpAlphaModifierSurfaceV1.interface
        ]
    )

#endif