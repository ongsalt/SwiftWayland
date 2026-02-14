import Foundation
import SwiftWayland

/// Interface For Exporting Surfaces
/// 
/// A global interface used for exporting surfaces that can later be imported
/// using xdg_importer.
public final class ZxdgExporterV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_exporter_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Xdg_Exporter Object
    /// 
    /// Notify the compositor that the xdg_exporter object will no longer be
    /// used.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Export A Surface
    /// 
    /// The export request exports the passed surface so that it can later be
    /// imported via xdg_importer. When called, a new xdg_exported object will
    /// be created and xdg_exported.handle will be sent immediately. See the
    /// corresponding interface and event for details.
    /// A surface may be exported multiple times, and each exported handle may
    /// be used to create an xdg_imported multiple times. Only xdg_surface
    /// surfaces may be exported.
    /// 
    /// - Parameters:
    ///   - Surface: the surface to export
    public func export(surface: WlSurface) throws(WaylandProxyError) -> ZxdgExportedV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZxdgExportedV1.self, version: self.version)
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
