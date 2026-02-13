extension WlRegistry {
    public func bind<T>(name: UInt32, version: UInt32, interface: T.Type) -> T
    where T: WlInterface & WlProxy {
        let obj = connection.createProxy(type: T.self, version: version)
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

// extension WlDisplay {
//     public func sync(callback: @escaping (UInt32) -> Void) throws(WaylandProxyError) {
//         guard self._state == .alive else { throw WaylandProxyError.destroyed }
//         let callback = connection.createCallback(fn: callback)
//         let message = Message(
//             objectId: self.id, opcode: 0,
//             contents: [
//                 .newId(callback.id)
//             ])
//         connection.send(message: message)
//     }
// }
