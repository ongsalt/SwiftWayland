import Foundation
import SwiftWayland

public final class ZwpPrimarySelectionSourceV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func offer(mimeType: String) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .string(mimeType)
        ])
        connection.queueSend(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case send(mimeType: String, fd: FileHandle)
        case cancelled
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.send(mimeType: r.readString(), fd: r.readFd())
            case 1:
                return Self.cancelled
            default:
                fatalError("Unknown message")
            }
        }
    }
}
