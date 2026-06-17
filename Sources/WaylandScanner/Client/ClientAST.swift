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

