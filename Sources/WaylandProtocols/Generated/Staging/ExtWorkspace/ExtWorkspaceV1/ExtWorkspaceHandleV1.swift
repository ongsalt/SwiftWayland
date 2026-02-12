import Foundation
import SwiftWayland

public final class ExtWorkspaceHandleV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func activate() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public func deactivate() {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.queueSend(message: message)
    }
    
    public func assign(workspaceGroup: ExtWorkspaceGroupHandleV1) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .object(workspaceGroup)
        ])
        connection.queueSend(message: message)
    }
    
    public func remove() {
        let message = Message(objectId: self.id, opcode: 4, contents: [])
        connection.queueSend(message: message)
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
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
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
