import Foundation

public final class WpPresentation: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_presentation"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func feedback(surface: WlSurface) -> WpPresentationFeedback {
        let callback = connection.createProxy(type: WpPresentationFeedback.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(surface),
            .newId(callback.id)
        ])
        connection.queueSend(message: message)
        return callback
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidTimestamp = 0
        case invalidFlag = 1
    }
    
    public enum Event: WlEventEnum {
        case clockId(clkId: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.clockId(clkId: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
