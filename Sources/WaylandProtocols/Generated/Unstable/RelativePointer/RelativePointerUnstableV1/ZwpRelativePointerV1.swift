import Foundation
import SwiftWayland

public final class ZwpRelativePointerV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case relativeMotion(utimeHi: UInt32, utimeLo: UInt32, dx: Double, dy: Double, dxUnaccel: Double, dyUnaccel: Double)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.relativeMotion(utimeHi: r.readUInt(), utimeLo: r.readUInt(), dx: r.readFixed(), dy: r.readFixed(), dxUnaccel: r.readFixed(), dyUnaccel: r.readFixed())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
