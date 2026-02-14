import Foundation

/// Callback Object
/// 
/// Clients can handle the 'done' event to get notified when
/// the related request is done.
/// Note, because wl_callback objects are created from multiple independent
/// factory interfaces, the wl_callback interface is frozen at version 1.
public final class WlCallback: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_callback"
    public var onEvent: (Event) -> Void = { _ in }

    public enum Event: WlEventEnum {
        /// Done Event
        /// 
        /// Notify the client when the related request is done.
        /// 
        /// - Parameters:
        ///   - CallbackData: request-specific data for the callback
        case done(callbackData: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
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
