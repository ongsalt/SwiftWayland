import Foundation

public final class WlCallback: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public enum Event: WlEventEnum {
        case done(callbackData: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.done(callbackData: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
