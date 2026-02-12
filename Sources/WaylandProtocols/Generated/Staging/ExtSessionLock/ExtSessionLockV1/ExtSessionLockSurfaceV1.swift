import Foundation
import SwiftWayland

public final class ExtSessionLockSurfaceV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func ackConfigure(serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .uint(serial)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case commitBeforeFirstAck = 0
        case nullBuffer = 1
        case dimensionsMismatch = 2
        case invalidSerial = 3
    }
    
    public enum Event: WlEventEnum {
        case configure(serial: UInt32, width: UInt32, height: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.configure(serial: r.readUInt(), width: r.readUInt(), height: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
