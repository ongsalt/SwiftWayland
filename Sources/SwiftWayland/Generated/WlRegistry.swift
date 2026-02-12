public final class WlRegistry: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func bind(name: UInt32) -> any WlProxy {
        let id = connection.createProxy(type: any WlProxy.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .uint(name),
            .newId(id.id)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Event: WlEventEnum {
        case global(name: UInt32, interface: String, version: UInt32)
        case globalRemove(name: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments)
            switch message.opcode {
            case 0:
                return Self.global(name: r.readUInt(), interface: r.readString(), version: r.readUInt())
            case 1:
                return Self.globalRemove(name: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
