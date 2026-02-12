// public final class WlCallback: WlProxyBase, WlProxy {
//     public var onEvent: (Event) -> Void = { _ in }

//     public required init(connection: Connection, id: ObjectId) {
//         super.init(connection: connection, id: id)
//         self.onEvent = { _ in
//             self.callback?()
//         }
//     }

//     public var callback: (() -> Void)? = nil

//     public enum Event: WlEventEnum {
//         case `done`(callbackData: UInt32)

//         public static func decode(message: Message, connection: Connection) -> Self {
//             let r = WLReader(data: message.arguments)
//             switch message.opcode {
//             case 0:
//                 return Self.`done`(callbackData: r.readUInt())
//             default:
//                 fatalError("Unknown message")
//             }
//         }
//     }
// }

extension WlRegistry {
    func bind<T>(name: UInt32, type: T.Type) -> T where T: WlProxy {
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
