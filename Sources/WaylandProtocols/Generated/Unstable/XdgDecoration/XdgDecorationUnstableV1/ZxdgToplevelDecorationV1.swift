import Foundation
import SwiftWayland

public final class ZxdgToplevelDecorationV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_toplevel_decoration_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setMode(mode: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .uint(mode)
        ])
        connection.queueSend(message: message)
    }
    
    public func unsetMode() {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case unconfiguredBuffer = 0
        case alreadyConstructed = 1
        case orphaned = 2
        case invalidMode = 3
    }
    
    public enum Mode: UInt32, WlEnum {
        case clientSide = 1
        case serverSide = 2
    }
    
    public enum Event: WlEventEnum {
        case configure(mode: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.configure(mode: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
