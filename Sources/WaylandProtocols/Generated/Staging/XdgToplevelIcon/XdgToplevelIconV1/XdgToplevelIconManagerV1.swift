import Foundation
import SwiftWayland

public final class XdgToplevelIconManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_toplevel_icon_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func createIcon() -> XdgToplevelIconV1 {
        let id = connection.createProxy(type: XdgToplevelIconV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func setIcon(toplevel: XdgToplevel, icon: XdgToplevelIconV1) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(toplevel),
            .object(icon)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case iconSize(size: Int32)
        case done
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.iconSize(size: r.readInt())
            case 1:
                return Self.done
            default:
                fatalError("Unknown message")
            }
        }
    }
}
