import Foundation
import SwiftWayland

public final class ExtWorkspaceHandleV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_workspace_handle_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func activate() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    public func deactivate() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
    }
    
    public func assign(workspaceGroup: ExtWorkspaceGroupHandleV1) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .object(workspaceGroup)
        ])
        connection.send(message: message)
    }
    
    public func remove() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 4, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum State: UInt32, WlEnum {
        case active = 1
        case urgent = 2
        case hidden = 4
    }
    
    public enum WorkspaceCapabilities: UInt32, WlEnum {
        case activate = 1
        case deactivate = 2
        case remove = 4
        case assign = 8
    }
    
    public enum Event: WlEventEnum {
        case id(id: String)
        case name(name: String)
        case coordinates(coordinates: Data)
        case state(state: UInt32)
        case capabilities(capabilities: UInt32)
        case removed
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.id(id: r.readString())
            case 1:
                return Self.name(name: r.readString())
            case 2:
                return Self.coordinates(coordinates: r.readArray())
            case 3:
                return Self.state(state: r.readUInt())
            case 4:
                return Self.capabilities(capabilities: r.readUInt())
            case 5:
                return Self.removed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
