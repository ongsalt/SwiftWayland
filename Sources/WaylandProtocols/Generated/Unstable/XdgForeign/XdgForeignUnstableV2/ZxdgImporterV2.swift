import Foundation
import SwiftWayland

/// Interface For Importing Surfaces
/// 
/// A global interface used for importing surfaces exported by xdg_exporter.
/// With this interface, a client can create a reference to a surface of
/// another client.
public final class ZxdgImporterV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_importer_v2"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Xdg_Importer Object
    /// 
    /// Notify the compositor that the xdg_importer object will no longer be
    /// used.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Import A Toplevel Surface
    /// 
    /// The import_toplevel request imports a surface from any client given a handle
    /// retrieved by exporting said surface using xdg_exporter.export_toplevel.
    /// When called, a new xdg_imported object will be created. This new object
    /// represents the imported surface, and the importing client can
    /// manipulate its relationship using it. See xdg_imported for details.
    /// 
    /// - Parameters:
    ///   - Handle: the exported surface handle
    public func importToplevel(handle: String) throws(WaylandProxyError) -> ZxdgImportedV2 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZxdgImportedV2.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.string(handle)
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
