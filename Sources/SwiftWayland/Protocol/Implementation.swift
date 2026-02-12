// public final class WlDisplay: WlProxyBase, WlProxy {
//     public var onEvent: (Event) -> Void = { _ in }

//     // objectId -> connection search for that object -> Dispatch<WlDisplay> -> WlDisplay -> translateEvent -> Self.Event
//     //

//     // TODO: make wl_callback a callback
//     // special case of type="new_id" interface="wl_callback"
//     func sync(_ callback: @Sendable () -> Void) {
//         // connection.registerCallback(callback)
//     }

//     func getRegistry() async throws -> WlRegistry {
//         let registry = connection.createProxy(type: WlRegistry.self)
//         // let message = Message(objectId: 1, opcode: 1) { data in
//         //     data.append(u32: registry.id) // newId
//         // }

//         let message = Message(objectId: 1, opcode: 1, contents: [
//             .newId(registry.id)
//         ])

//         // this should not immediately fire, must schedule
//         try await connection.send(message: message)

//         return registry
//     }

//     public enum Event: WlEventEnum {
//         case error(objectId: any WlProxy, code: UInt32, message: String)
//         // Yep, this cant be generated
//         case deleteId(id: any WlProxy)

//         public static func decode(message: Message, connection: Connection) -> Self {
//             let r = WLReader(data: message.arguments, connection: connection)
//             return switch message.opcode {
//             case 0:
//                 Self.error(objectId: connection.get(id: r.readObjectId())!, code: r.readUInt(), message: r.readString())
//             case 1:
//                 Self.deleteId(id: connection.get(id: r.readObjectId())!)
//             default:
//                 fatalError("bad wayland server")
//             }
//         }
//     }

//     public enum Error: UInt32, WlEnum {  // : WaylandEnum
//         case invalidObject
//         case invalidMethod
//         case noMemory
//         case implementation

//         // private static func decode() -> Error {

//         // }

//         // private func encode() {

//         // }
//     }
// }

// public final class WlRegistry: WlProxyBase, WlProxy {
//     public var onEvent: (Event) -> Void = { _ in }

//     // this must be custom code

//     /// Deal with this wisely
//     func bind<T>(name: UInt, type: T.Type) -> T where T: WlProxy {
//         connection.createProxy(type: T.self)
//     }

//     public enum Event: WlEventEnum {
//         case global(name: UInt32, interface: String, version: UInt32)
//         case globalRemove(name: UInt32)

//         public static func decode(message: Message, connection: Connection) -> Self {
//             let r = WLReader(data: message.arguments, connection: connection)
//             return switch message.opcode {
//             case 0:
//                 Self.global(name: r.readUInt(), interface: r.readString(), version: r.readUInt())
//             case 1:
//                 Self.globalRemove(name: r.readUInt())
//             default:
//                 fatalError("bad wayland server")
//             }
//         }

//     }
// }
