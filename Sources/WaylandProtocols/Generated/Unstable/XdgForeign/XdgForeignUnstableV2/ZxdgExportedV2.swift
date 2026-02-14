import Foundation
import SwiftWayland

/// An Exported Surface Handle
/// 
/// An xdg_exported object represents an exported reference to a surface. The
/// exported surface may be referenced as long as the xdg_exported object not
/// destroyed. Destroying the xdg_exported invalidates any relationship the
/// importer may have established using xdg_imported.
public final class ZxdgExportedV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_exported_v2"
    public var onEvent: (Event) -> Void = { _ in }

    /// Unexport The Exported Surface
    /// 
    /// Revoke the previously exported surface. This invalidates any
    /// relationship the importer may have set up using the xdg_imported created
    /// given the handle sent via xdg_exported.handle.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// The Exported Surface Handle
        /// 
        /// The handle event contains the unique handle of this exported surface
        /// reference. It may be shared with any client, which then can use it to
        /// import the surface by calling xdg_importer.import_toplevel. A handle
        /// may be used to import the surface multiple times.
        /// 
        /// - Parameters:
        ///   - Handle: the exported surface handle
        case handle(handle: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.handle(handle: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
