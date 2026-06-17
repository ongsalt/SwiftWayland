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
    var enums: [EnumDeclaration] = []
    var events: [EventDeclaration] = []
}

struct MethodDeclaration: Sendable {
    var name: String
    var requestName: String
    var requestId: UInt32
    var isDestructor: Bool
    var since: UInt32?
    // function arguments
    var arguments: [ArgumentDeclaration]
    var returns: [ArgumentDeclaration] // this wont return more than 1 object anyway
    var callbacks: [ArgumentDeclaration]
    // all arguments
    var messageArguments: [ArgumentDeclaration]
    var description: Description?
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
    var arg: Argument
    // do this have since field
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
    var value: String
    var summary: String?
}

struct Statement: Sendable {
    var contents: String
}

