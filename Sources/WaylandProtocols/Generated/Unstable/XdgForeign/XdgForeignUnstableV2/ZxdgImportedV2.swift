import Foundation
import SwiftWayland

/// An Imported Surface Handle
/// 
/// An xdg_imported object represents an imported reference to surface exported
/// by some client. A client can use this interface to manipulate
/// relationships between its own surfaces and the imported surface.
public final class ZxdgImportedV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_imported_v2"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Xdg_Imported Object
    /// 
    /// Notify the compositor that it will no longer use the xdg_imported
    /// object. Any relationship that may have been set up will at this point
    /// be invalidated.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set As The Parent Of Some Surface
    /// 
    /// Set the imported surface as the parent of some surface of the client.
    /// The passed surface must be an xdg_toplevel equivalent, otherwise an
    /// invalid_surface protocol error is sent. Calling this function sets up
    /// a surface to surface relation with the same stacking and positioning
    /// semantics as xdg_toplevel.set_parent.
    /// 
    /// - Parameters:
    ///   - Surface: the child surface
    public func setParentOf(surface: WlSurface) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(surface)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Error Values
    /// 
    /// These errors can be emitted in response to invalid xdg_imported
    /// requests.
    public enum Error: UInt32, WlEnum {
        /// Surface Is Not An Xdg_Toplevel
        case invalidSurface = 0
    }
    
    public enum Event: WlEventEnum {
        /// The Imported Surface Handle Has Been Destroyed
        /// 
        /// The imported surface handle has been destroyed and any relationship set
        /// up has been invalidated. This may happen for various reasons, for
        /// example if the exported surface or the exported surface handle has been
        /// destroyed, if the handle used for importing was invalid.
        case destroyed
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.destroyed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
