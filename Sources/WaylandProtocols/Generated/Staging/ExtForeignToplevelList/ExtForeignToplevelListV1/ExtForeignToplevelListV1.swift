import Foundation
import SwiftWayland

public final class ExtForeignToplevelListV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_foreign_toplevel_list_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func stop() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    public enum Event: WlEventEnum {
        case toplevel(toplevel: ExtForeignToplevelHandleV1)
        case finished
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.toplevel(toplevel: connection.createProxy(type: ExtForeignToplevelHandleV1.self, id: r.readNewId()))
            case 1:
                return Self.finished
            default:
                fatalError("Unknown message")
            }
        }
    }
}
