// import SwiftSyntax

struct ClassDeclaration {
    var name: String
    var interfaceName: String
    var description: Description?
    var methods: MethodDeclaration
    var `deinit`: DeinitDeclaration
}

struct MethodDeclaration {
    var name: String
    var arguments: [ArgumentDeclaration]
    var returnType: SwiftType
    var description: Description?
}

struct ArgumentDeclaration {
    var name: String
    var externalName: String? = nil
    var type: SwiftType
    var `throws`: SwiftType?
    // do this have since field
}

struct DeinitDeclaration {
    var statements: [Statement]
}

struct EnumDeclaration {
    var contents: String
}

struct Statement {
    var contents: String
}

// enum SwiftType {
//     case callback = "@escaping () -> Void"
//     case string = "String"
//     case u32 = "UInt32" // TODO: make its just a UInt?? 
//     case i32 = "Int32" // same
//     case proxy(String)

//     case 
// }

typealias SwiftType = String
