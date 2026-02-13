import Foundation
import SwiftWayland

public final class ExtDataControlOfferV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_data_control_offer_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func receive(mimeType: String, fd: FileHandle) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .string(mimeType),
            .fd(fd)
        ])
        connection.queueSend(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case offer(mimeType: String)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.offer(mimeType: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
