import Foundation
import SwiftWayland

public final class WpFractionalScaleV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_fractional_scale_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case preferredScale(scale: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.preferredScale(scale: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
