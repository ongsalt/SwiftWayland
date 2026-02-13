extension WlRegistry {
    public func bind<T>(name: UInt32, version: UInt32, interface: T.Type) -> T where T: WlInterface & WlProxy {
        let obj = connection.createProxy(type: T.self)
        (obj as? WlProxyBase)?.version = UInt(version)
        
        let message = Message(
            objectId: self.id, opcode: 0,
            contents: [
                .uint(name),
                .newIdDynamic(interfaceName: interface.name, version: version, id: obj.id),
            ])
        connection.send(message: message)

        return obj
    }
}
