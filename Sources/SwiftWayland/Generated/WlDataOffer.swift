public final class WlDataOffer: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func accept(serial: UInt32, mimeType: String) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .uint(serial),
            .string(mimeType)
        ])
        connection.queueSend(message: message)
    }
    
    public func receive(mimeType: String, fd: FileHandle) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .string(mimeType),
            .fd(fd)
        ])
        connection.queueSend(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.queueSend(message: message)
    }
    
    public func finish() {
        let message = Message(objectId: self.id, opcode: 3, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setActions(dndActions: UInt32, preferredAction: UInt32) {
        let message = Message(objectId: self.id, opcode: 4, contents: [
            .uint(dndActions),
            .uint(preferredAction)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidFinish = 0
        case invalidActionMask = 1
        case invalidAction = 2
        case invalidOffer = 3
    }
    
    public enum Event: WlEventEnum {
        case offer(mimeType: String)
        case sourceActions(sourceActions: UInt32)
        case action(dndAction: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments)
            switch message.opcode {
            case 0:
                return Self.offer(mimeType: r.readString())
            case 1:
                return Self.sourceActions(sourceActions: r.readUInt())
            case 2:
                return Self.action(dndAction: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}