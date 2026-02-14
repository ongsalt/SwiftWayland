import Foundation
import SwiftWayland

/// Input Method
/// 
/// An input method object is responsible for composing text in response to
/// input from hardware or virtual keyboards. There is one input method
/// object per seat. On activate there is a new input method context object
/// created which allows the input method to communicate with the text input.
public final class ZwpInputMethodV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_input_method_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public enum Event: WlEventEnum {
        /// Activate Event
        /// 
        /// A text input was activated. Creates an input method context object
        /// which allows communication with the text input.
        case activate(id: ZwpInputMethodContextV1)
        
        /// Deactivate Event
        /// 
        /// The text input corresponding to the context argument was deactivated.
        /// The input method context should be destroyed after deactivation is
        /// handled.
        case deactivate(context: ZwpInputMethodContextV1)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.activate(id: connection.createProxy(type: ZwpInputMethodContextV1.self, version: version, id: r.readNewId()))
            case 1:
                return Self.deactivate(context: connection.get(as: ZwpInputMethodContextV1.self, id: r.readObjectId())!)
            default:
                fatalError("Unknown message")
            }
        }
    }
}
