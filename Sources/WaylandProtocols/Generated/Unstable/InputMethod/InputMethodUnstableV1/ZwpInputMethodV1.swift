import Foundation
import SwiftWayland

public final class ZwpInputMethodV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_input_method_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public enum Event: WlEventEnum {
        case activate(id: ZwpInputMethodContextV1)
        case deactivate(context: ZwpInputMethodContextV1)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.activate(id: connection.createProxy(type: ZwpInputMethodContextV1.self, id: r.readNewId()))
            case 1:
                return Self.deactivate(context: connection.get(as: ZwpInputMethodContextV1.self, id: r.readObjectId())!)
            default:
                fatalError("Unknown message")
            }
        }
    }
}
