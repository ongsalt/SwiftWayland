import Foundation

public final class WlDataSource: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func offer(mimeType: String) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .string(mimeType)
        ])
        connection.queueSend(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setActions(dndActions: UInt32) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .uint(dndActions)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidActionMask = 0
        case invalidSource = 1
    }
    
    public enum Event: WlEventEnum {
        case `target`(mimeType: String)
        case send(mimeType: String, fd: FileHandle)
        case cancelled
        case dndDropPerformed
        case dndFinished
        case action(dndAction: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.`target`(mimeType: r.readString())
            case 1:
                return Self.send(mimeType: r.readString(), fd: r.readFd())
            case 2:
                return Self.cancelled
            case 3:
                return Self.dndDropPerformed
            case 4:
                return Self.dndFinished
            case 5:
                return Self.action(dndAction: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
