import Foundation
import SwiftWayland

/// Alpha Modifier Object For A Surface
/// 
/// This interface allows the client to set a factor for the alpha values on
/// a surface, which can be used to offload such operations to the compositor.
/// The default factor is UINT32_MAX.
/// This object has to be destroyed before the associated wl_surface. Once the
/// wl_surface is destroyed, all request on this object will raise the
/// no_surface error.
public final class WpAlphaModifierSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_alpha_modifier_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Alpha Modifier Object
    /// 
    /// This destroys the object, and is equivalent to set_multiplier with
    /// a value of UINT32_MAX, with the same double-buffered semantics as
    /// set_multiplier.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
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
    public func setMultiplier(factor: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.uint(factor)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Wl_Surface Was Destroyed
        case noSurface = 0
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
