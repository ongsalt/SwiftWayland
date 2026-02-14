import Foundation
import SwiftWayland

/// System Bell
/// 
/// This global interface enables clients to ring the system bell.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class XdgSystemBellV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_system_bell_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The System Bell Object
    /// 
    /// Notify that the object will no longer be used.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
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
    ///   - Surface: associated surface
    public func ring(surface: WlSurface) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(surface)
        ])
        connection.send(message: message)
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
