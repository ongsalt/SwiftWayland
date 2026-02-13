import Foundation
import SwiftWayland

public final class ExtSessionLockV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_session_lock_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func getLockSurface(surface: WlSurface, output: WlOutput) -> ExtSessionLockSurfaceV1 {
        let id = connection.createProxy(type: ExtSessionLockSurfaceV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface),
            .object(output)
        ])
        connection.send(message: message)
        return id
    }
    
    public func unlockAndDestroy() {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidDestroy = 0
        case invalidUnlock = 1
        case role = 2
        case duplicateOutput = 3
        case alreadyConstructed = 4
    }
    
    public enum Event: WlEventEnum {
        case locked
        case finished
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.locked
            case 1:
                return Self.finished
            default:
                fatalError("Unknown message")
            }
        }
    }
}
