import Foundation
import SwiftWayland

public final class WpDrmLeaseV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case leaseFd(leasedFd: FileHandle)
        case finished
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.leaseFd(leasedFd: r.readFd())
            case 1:
                return Self.finished
            default:
                fatalError("Unknown message")
            }
        }
    }
}
