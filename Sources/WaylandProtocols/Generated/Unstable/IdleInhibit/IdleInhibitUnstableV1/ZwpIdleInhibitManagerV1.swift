import Foundation
import SwiftWayland

/// Control Behavior When Display Idles
/// 
/// This interface permits inhibiting the idle behavior such as screen
/// blanking, locking, and screensaving.  The client binds the idle manager
/// globally, then creates idle-inhibitor objects for each surface.
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZwpIdleInhibitManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_idle_inhibit_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Idle Inhibitor Object
    /// 
    /// Destroy the inhibit manager.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A New Inhibitor Object
    /// 
    /// Create a new inhibitor object associated with the given surface.
    /// 
    /// - Parameters:
    ///   - Surface: the surface that inhibits the idle behavior
    public func createInhibitor(surface: WlSurface) throws(WaylandProxyError) -> ZwpIdleInhibitorV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpIdleInhibitorV1.self, version: self.version)
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
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
