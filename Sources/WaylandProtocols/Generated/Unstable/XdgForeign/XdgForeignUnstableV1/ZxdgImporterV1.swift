import Foundation
import SwiftWayland

public final class ZxdgImporterV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_importer_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func `import`(handle: String) -> ZxdgImportedV1 {
        let id = connection.createProxy(type: ZxdgImportedV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .string(handle)
        ])
        connection.send(message: message)
        return id
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
