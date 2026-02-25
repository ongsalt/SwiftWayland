// import CWayland
// import SwiftWaylandCommon

// class Display: Proxy {
//     var version: UInt32 = 1
//     var interface: Interface {
//         Self.interface
//     }
//     var onEvent: ((NoEvent) -> Void)?
//     var raw: any RawProxy

//     static var interface: Interface {
//         Interface(
//             name: "wl_display",
//             version: 1,
//             enums: [],
//             requests: [
//                 Message(
//                     name: "sync",
//                     arguments: [
//                         // TODO:
//                     ]
//                 ),
//                 Message(
//                     name: "get_registry",
//                     arguments: [
//                         Argument(name: "registry", type: .newId, interface: "wl_registry")
//                     ]
//                 ),
//             ],
//             events: []
//         )
//     }

//     required init(raw: any RawProxy) {
//         self.raw = raw
//     }
// }

// class Registry: Proxy {
//     var version: UInt32 = 1
//     var interface: Interface { Self.interface }
//     var onEvent: ((Event) -> Void)?
//     var raw: any RawProxy

//     required init(raw: any RawProxy) {
//         self.raw = raw
//     }

//     static let interface: Interface = Interface(
//         name: "wl_registry",
//         version: 1,
//         enums: [],
//         requests: [],
//         events: [
//             Message(
//                 name: "global",
//                 arguments: [
//                     Argument(name: "name", type: .uint),
//                     Argument(name: "interface", type: .string),
//                     Argument(name: "version", type: .uint),
//                 ]
//             ),
//             Message(
//                 name: "global_remove",
//                 arguments: [
//                     Argument(name: "name", type: .uint)
//                 ]
//             ),

//         ]
//     )

//     enum Event: Decodable {
//         case global(name: UInt32, interface: String, version: UInt32)
//         case globalRemove(name: UInt32)

//         init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
//             if opcode == 0 {
//                 self = .global(name: r.uint(), interface: r.string(), version: r.uint())
//             } else {
//                 self = .globalRemove(name: r.uint())
//             }
//         }
//     }
// }

// let coreProtocol = Protocol(
//     name: "wayland",
//     interfaces: [Registry.interface, Display.interface]
// )
