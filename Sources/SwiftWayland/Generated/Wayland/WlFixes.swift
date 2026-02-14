import Foundation

/// Wayland Protocol Fixes
/// 
/// This global fixes problems with other core-protocol interfaces that
/// cannot be fixed in these interfaces themselves.
public final class WlFixes: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_fixes"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroys This Object
    /// 
    /// 
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Destroy A Wl_Registry
    /// 
    /// This request destroys a wl_registry object.
    /// The client should no longer use the wl_registry after making this
    /// request.
    /// The compositor will emit a wl_display.delete_id event with the object ID
    /// of the registry and will no longer emit any events on the registry. The
    /// client should re-use the object ID once it receives the
    /// wl_display.delete_id event.
    /// 
    /// - Parameters:
    ///   - Registry: the registry to destroy
    public func destroyRegistry(registry: WlRegistry) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(registry)
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
