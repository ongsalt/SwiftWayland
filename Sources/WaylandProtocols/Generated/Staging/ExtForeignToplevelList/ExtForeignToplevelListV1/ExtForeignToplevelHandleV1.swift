import Foundation
import SwiftWayland

public final class ExtForeignToplevelHandleV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_foreign_toplevel_handle_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case closed
        case done
        case title(title: String)
        case appId(appId: String)
        case identifier(identifier: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.closed
            case 1:
                return Self.done
            case 2:
                return Self.title(title: r.readString())
            case 3:
                return Self.appId(appId: r.readString())
            case 4:
                return Self.identifier(identifier: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
