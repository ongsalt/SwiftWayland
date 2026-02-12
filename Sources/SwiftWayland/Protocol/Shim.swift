extension WlRegistry {
    public func bind<T>(name: UInt32, version: UInt32, interfaceName: String, type: T.Type) -> T
    where T: WlProxy {
        let obj = connection.createProxy(type: T.self)
        let message = Message(
            objectId: self.id, opcode: 0,
            contents: [
                .uint(name),
                .newIdDynamic(interfaceName: interfaceName, version: version, id: obj.id),
            ])
        connection.queueSend(message: message)

        return obj
    }
}
