// import SwiftSyntax
import SwiftWaylandCommon

public struct ProtocolDeclaration: Sendable {
    var name: String
    var copyright: String?
    var description: Description?
    var `protocol`: Protocol
    var classes: [ClassDeclaration]
}

public struct ClassDeclaration: Sendable {
    var name: String
    var interface: Interface
    var interfaceName: String { interface.name }
    var interfaceVersion: UInt32 { interface.version } 
    var protocolName: String
    var description: Description? = nil
    var methods: [MethodDeclaration]
    var `deinit`: DeinitDeclaration? = nil
    var enums: [EnumDeclaration] = []
    var events: [EventDeclaration] = []
}

struct MethodDeclaration: Sendable {
    var name: String
    var requestName: String
    var requestId: UInt32
    var isDestructor: Bool
    var since: UInt32?
    var arguments: [ArgumentDeclaration]
    var returns: [ArgumentDeclaration] // TODO: make a type for this
    var callbacks: [CallbackDeclaration]
    var messageArguments: [ArgumentDeclaration]
    var description: Description?
    var `throws`: String?
}

struct CallbackDeclaration: Sendable {
    var name: String
}

struct EventDeclaration: Sendable {
    var name: String
    var description: Description?
    var arguments: [ArgumentDeclaration]
    var isDestructor: Bool = false
}

struct ArgumentDeclaration: Sendable {
    var name: String
    var externalName: String? = nil
    var swiftType: String
    var defaultValue: String? = nil
    var arg: Argument
    // do this have since field
}


struct DeinitDeclaration: Sendable {
    var destructors: [String]
}

struct EnumDeclaration: Sendable {
    var name: String
    var description: Description?
    var bitfield: Bool = false
    // TODO: enum since codegen, (probably not needed tho)
    var since: UInt32?

    var cases: [EnumCaseDeclaration]
}

// this is event enum tho
struct EnumCaseDeclaration: Sendable {
    var name: String
    var value: UInt32
    var summary: String?
}

struct Statement: Sendable {
    var contents: String
}

// enum ArgumentType {
//     case callback, string, u32, i32, fd, fixed
//     case data  // array
//     case `enum`(swiftName: String)
//     // case tuple([ArgumentType])
//     case proxy(swiftName: String?)
//     case newProxy(swiftName: String?)
// }

// extension ArgumentType {
//     var swiftType: String {
//         switch self {
//         case .string: "String"
//         case .callback: "@escaping (UInt32) -> Void"
//         case .i32: "Int32"  // we should just do auto conversion
//         case .u32: "UInt32"
//         case .fixed: "Double"
//         case .fd: "FileHandle"
//         case .data: "Data"  // or should i do UnsafeRawBufferPointer
//         case .enum(let swiftName): swiftName
//         case .proxy(let swiftName): swiftName ?? "any Proxy"
//         case .newProxy(let swiftName): swiftName ?? "any Proxy"  // wl_registry.bind
//         // this will generate invalid code tho

//         // case .tuple(let types):
//         //     switch types.count {
//         //     case 0: Self.void.string
//         //     case 1: types[0].string
//         //     default: "(\(types.map(\.string).joined(separator: " ,")))"
//         //     }
//         }
//     }

//     var waylandData: String {
//         switch self {
//         case .string: "string"
//         case .i32: "int"
//         case .u32: "uint"
//         case .fixed: "fixed"
//         case .fd: "fd"
//         case .data: "array"
//         case .enum: "enum"

//         case .proxy: "object"
//         case .newProxy: "newId"
//         case .callback: "newId"
//         // case .tuple: fatalError("how tf did tuple end up here")
//         }
//     }
// }
