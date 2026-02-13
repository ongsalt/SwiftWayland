import Foundation

public final class WlCallback: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_callback"
    public var onEvent: (Event) -> Void = { _ in }

    public enum Event: WlEventEnum {
        case done(callbackData: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.done(callbackData: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
