import Foundation
import SwiftWayland

/// Background Effects For A Surface
/// 
/// The background effect object provides a way to specify a region behind
/// a surface that should have background effects like blur applied.
/// If the wl_surface associated with the ext_background_effect_surface_v1
/// object has been destroyed, this object becomes inert.
public final class ExtBackgroundEffectSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_background_effect_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Release The Blur Object
    /// 
    /// Informs the server that the client will no longer be using this protocol
    /// object. The effect regions will be removed on the next commit.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set Blur Region
    /// 
    /// This request sets the region of the surface that will have its
    /// background blurred.
    /// The blur region is specified in the surface-local coordinates, and
    /// clipped by the compositor to the surface size.
    /// The initial value for the blur region is empty. Setting the pending
    /// blur region has copy semantics, and the wl_region object can be
    /// destroyed immediately. A NULL wl_region removes the effect.
    /// The blur region is double-buffered state, and will be applied on
    /// the next wl_surface.commit.
    /// The blur algorithm is subject to compositor policies.
    /// If the associated surface has been destroyed, the surface_destroyed
    /// error will be raised.
    /// 
    /// - Parameters:
    ///   - Region: blur region of the surface
    public func setBlurRegion(region: WlRegion) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(region)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// The Associated Surface Has Been Destroyed
        case surfaceDestroyed = 0
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
