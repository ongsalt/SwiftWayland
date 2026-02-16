import Foundation

extension WlRegistry {
    public func bind<T>(name: UInt32, version: UInt32, interface: T.Type, queue: EventQueue) -> T
    where T: Interface & WlProxy {
        let obj = connection.createProxy(type: T.self, version: version, queue: queue)
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

extension WlDisplay {
    public enum Event: WlEventEnum {
        /// Fatal Error Event
        ///
        /// The error event is sent out when a fatal (non-recoverable)
        /// error has occurred.  The object_id argument is the object
        /// where the error occurred, most often in response to a request
        /// to that object.  The code identifies the error and is defined
        /// by the object interface.  As such, each interface defines its
        /// own set of error codes.  The message is a brief description
        /// of the error, for (debugging) convenience.
        case error(objectId: ObjectId, code: UInt32, `message`: String)

        /// Acknowledge Object Id Deletion
        ///
        /// This event is used internally by the object ID management
        /// logic. When a client deletes an object that it had created,
        /// the server will send this event to acknowledge that it has
        /// seen the delete request. When the client receives this event,
        /// it will know that it can safely reuse the object ID.
        case deleteId(id: UInt32)

        public static func decode(message: Message, connection: Connection, version: UInt32) -> Self
        {
            var r = ArgumentReader(data: message.arguments, fdSource: connection.socket)
            switch message.opcode {
            case 0:
                return Self.error(
                    objectId: r.readObjectId(), code: r.readUInt(),
                    message: r.readString())
            case 1:
                return Self.deleteId(id: r.readUInt())
            default:
                fatalError(
                    "Unknown message: opcode=\(message.opcode) \(message.arguments as NSData)")
            }
        }
    }

}
