import Foundation
import SwiftWayland

public final class ExtWorkspaceGroupHandleV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_workspace_group_handle_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func createWorkspace(workspace: String) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .string(workspace)
        ])
        connection.send(message: message)
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum GroupCapabilities: UInt32, WlEnum {
        case createWorkspace = 1
    }
    
    public enum Event: WlEventEnum {
        case capabilities(capabilities: UInt32)
        case outputEnter(output: WlOutput)
        case outputLeave(output: WlOutput)
        case workspaceEnter(workspace: ExtWorkspaceHandleV1)
        case workspaceLeave(workspace: ExtWorkspaceHandleV1)
        case removed
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.capabilities(capabilities: r.readUInt())
            case 1:
                return Self.outputEnter(output: connection.get(as: WlOutput.self, id: r.readObjectId())!)
            case 2:
                return Self.outputLeave(output: connection.get(as: WlOutput.self, id: r.readObjectId())!)
            case 3:
                return Self.workspaceEnter(workspace: connection.get(as: ExtWorkspaceHandleV1.self, id: r.readObjectId())!)
            case 4:
                return Self.workspaceLeave(workspace: connection.get(as: ExtWorkspaceHandleV1.self, id: r.readObjectId())!)
            case 5:
                return Self.removed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
