
extension WlRegistry {
    public func bind<T>(name: UInt32, type: T.Type) -> T where T: WlProxy {
        let obj = connection.createProxy(type: T.self)
        let message = Message(
            objectId: self.id, opcode: 0,
            contents: [
                .uint(name),
                .newId(obj.id),
            ])
        connection.queueSend(message: message)

        return obj
    }
}
