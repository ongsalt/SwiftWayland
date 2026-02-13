import Foundation
import SwiftWayland

public final class ZxdgImportedV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_imported_v2"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func setParentOf(surface: WlSurface) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(surface)
        ])
        connection.send(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidSurface = 0
    }
    
    public enum Event: WlEventEnum {
        case destroyed
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.destroyed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
