import Foundation
import SwiftWayland

/// Used To Lock The Session
/// 
/// This interface is used to request that the session be locked.
public final class ExtSessionLockManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_session_lock_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Session Lock Manager Object
    /// 
    /// This informs the compositor that the session lock manager object will
    /// no longer be used. Existing objects created through this interface
    /// remain valid.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Attempt To Lock The Session
    /// 
    /// This request creates a session lock and asks the compositor to lock the
    /// session. The compositor will send either the ext_session_lock_v1.locked
    /// or ext_session_lock_v1.finished event on the created object in
    /// response to this request.
    public func lock() throws(WaylandProxyError) -> ExtSessionLockV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ExtSessionLockV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id)
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
