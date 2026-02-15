// import SwiftSyntax

struct ClassDeclaration {
    var name: String
    var interfaceName: String
    var description: Description? = nil
    var methods: [MethodDeclaration]
    var `deinit`: DeinitDeclaration? = nil
    var enums: [EnumDeclaration] = []
    var events: [EventDeclaration] = []
}

struct MethodDeclaration {
    var name: String
    var requestName: String
    var requestId: UInt
    var consuming: Bool
    var since: UInt?
    var arguments: [ArgumentDeclaration]
    var returns: [ArgumentDeclaration] // TODO: make a type for this
    var callbacks: [CallbackDeclaration]
    var messageArguments: [WaylandArgumentDeclaration]
    var description: Description?
    var `throws`: String?
}

struct CallbackDeclaration {
    var name: String
}

struct EventDeclaration {
    var name: String
    var description: Description?
    var arguments: [WaylandArgumentDeclaration]
}

struct ArgumentDeclaration {
    var name: String
    var externalName: String? = nil
    var swiftType: String
    var defaultValue: String?
    // do this have since field
}

struct WaylandArgumentDeclaration {
    var name: String
    var waylandType: Primitive
    var swiftType: String
    // do this have since field
}

struct DeinitDeclaration {
    var selectedMethod: String
}

struct EnumDeclaration {
    var name: String
    var description: Description?
    var bitfield: Bool = false
    // TODO: enum since codegen, (probably not needed tho)
    var since: UInt?

    var cases: [EnumCaseDeclaration]
}

// this is event enum tho
struct EnumCaseDeclaration {
    var name: String
    var value: String
    var summary: String?
}

struct Statement {
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
//         case .proxy(let swiftName): swiftName ?? "any WlProxy"
//         case .newProxy(let swiftName): swiftName ?? "any WlProxy"  // wl_registry.bind
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
