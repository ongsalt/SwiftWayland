import Foundation
import SwiftWayland

public final class ExtWorkspaceManagerV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func commit() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func stop() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case workspaceGroup(workspaceGroup: ExtWorkspaceGroupHandleV1)
        case workspace(workspace: ExtWorkspaceHandleV1)
        case done
        case finished
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.workspaceGroup(workspaceGroup: connection.createProxy(type: ExtWorkspaceGroupHandleV1.self, id: r.readNewId()))
            case 1:
                return Self.workspace(workspace: connection.createProxy(type: ExtWorkspaceHandleV1.self, id: r.readNewId()))
            case 2:
                return Self.done
            case 3:
                return Self.finished
            default:
                fatalError("Unknown message")
            }
        }
    }
}
