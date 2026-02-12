public final class WlShmPool: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func createBuffer(offset: Int32, width: Int32, height: Int32, stride: Int32, format: UInt32) -> WlBuffer {
        let id = connection.createProxy(type: WlBuffer.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id),
            .int(offset),
            .int(width),
            .int(height),
            .int(stride),
            .uint(format)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public func resize(size: Int32) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .int(size)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments)
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
