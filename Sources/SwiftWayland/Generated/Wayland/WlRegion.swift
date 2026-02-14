import Foundation

/// Region Interface
/// 
/// A region object describes an area.
/// Region objects are used to describe the opaque and input
/// regions of a surface.
public final class WlRegion: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_region"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy Region
    /// 
    /// Destroy the region.  This will invalidate the object ID.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Add Rectangle To Region
    /// 
    /// Add the specified rectangle to the region.
    /// 
    /// - Parameters:
    ///   - X: region-local x coordinate
    ///   - Y: region-local y coordinate
    ///   - Width: rectangle width
    ///   - Height: rectangle height
    public func add(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.int(x),
            WaylandData.int(y),
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    /// Subtract Rectangle From Region
    /// 
    /// Subtract the specified rectangle from the region.
    /// 
    /// - Parameters:
    ///   - X: region-local x coordinate
    ///   - Y: region-local y coordinate
    ///   - Width: rectangle width
    ///   - Height: rectangle height
    public func subtract(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.int(x),
            WaylandData.int(y),
            WaylandData.int(width),
            WaylandData.int(height)
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
