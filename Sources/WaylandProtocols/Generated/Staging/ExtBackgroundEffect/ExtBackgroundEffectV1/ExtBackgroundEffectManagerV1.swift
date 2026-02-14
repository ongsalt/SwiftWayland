import Foundation
import SwiftWayland

/// Background Effect Factory
/// 
/// This protocol provides a way to improve visuals of translucent surfaces
/// by applying effects like blur to the background behind them.
/// The capabilities are send when the global is bound, and every time they
/// change. Note that when the capability goes away, the corresponding effect
/// is no longer applied by the compositor, even if it was set before.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class ExtBackgroundEffectManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_background_effect_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Background Effect Manager
    /// 
    /// Informs the server that the client will no longer be using this
    /// protocol object. Existing objects created by this object are not
    /// affected.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Get A Background Effects Object
    /// 
    /// Instantiate an interface extension for the given wl_surface to add
    /// effects like blur for the background behind it.
    /// If the given wl_surface already has a ext_background_effect_surface_v1
    /// object associated, the background_effect_exists protocol error will be
    /// raised.
    /// 
    /// - Parameters:
    ///   - Surface: the surface
    public func getBackgroundEffect(surface: WlSurface) throws(WaylandProxyError) -> ExtBackgroundEffectSurfaceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ExtBackgroundEffectSurfaceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// The Surface Already Has A Background Effect Object
        case backgroundEffectExists = 0
    }
    
    public enum Capability: UInt32, WlEnum {
        /// The Compositor Supports Applying Blur
        case blur = 1
    }
    
    public enum Event: WlEventEnum {
        /// Capabilities Of The Compositor
        /// 
        /// 
        case capabilities(flags: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.capabilities(flags: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
