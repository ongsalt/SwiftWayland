import Foundation
import SwiftWayland

public final class ExtWorkspaceManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_workspace_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func commit() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func stop() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    public enum Event: WlEventEnum {
        case workspaceGroup(workspaceGroup: ExtWorkspaceGroupHandleV1)
        case workspace(workspace: ExtWorkspaceHandleV1)
        case done
        case finished
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.workspaceGroup(workspaceGroup: connection.createProxy(type: ExtWorkspaceGroupHandleV1.self, version: version, id: r.readNewId()))
            case 1:
                return Self.workspace(workspace: connection.createProxy(type: ExtWorkspaceHandleV1.self, version: version, id: r.readNewId()))
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
