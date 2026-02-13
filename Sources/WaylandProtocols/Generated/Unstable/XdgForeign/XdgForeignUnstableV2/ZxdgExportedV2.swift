import Foundation
import SwiftWayland

public final class ZxdgExportedV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_exported_v2"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case handle(handle: String)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.handle(handle: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
