public final class WlDisplay: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func sync(callback: WlCallback) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(callback.id)
        ])
        connection.queueSend(message: message)
    }
    
    public func getRegistry() -> WlRegistry {
        let registry = connection.createProxy(type: WlRegistry.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(registry.id)
        ])
        connection.queueSend(message: message)
        return registry
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidObject = 0
        case invalidMethod = 1
        case noMemory = 2
        case implementation = 3
    }
    
    public enum Event: WlEventEnum {
        case error(objectId: any WlProxy, code: UInt32, message: String)
        case deleteId(id: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments)
            switch message.opcode {
            case 0:
                return Self.error(objectId: connection.get(id: r.readObjectId())!, code: r.readUInt(), message: r.readString())
            case 1:
                return Self.deleteId(id: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}