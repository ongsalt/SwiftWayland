// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros
import XMLCoder

@main
struct MyProjectMacros: CompilerPlugin {
    var providingMacros: [Macro.Type] = [WaylandProtocolMacro.self]
}

public enum WaylandProtocolMacroError: Error {
    case invalidArguments
    case invalidXml
}


// TODO: parse options like trimPrefix: "wl" or "xdg"
// 
public struct WaylandProtocolMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws(WaylandProtocolMacroError) -> [DeclSyntax] {
        guard case .argumentList(let list) = node.arguments,
            case .stringLiteralExpr(let s) = list.first?.expression.as(ExprSyntaxEnum.self)
        else {
            throw .invalidArguments
        }

        let rawText = s.segments.map {
            switch $0 {
            case .stringSegment(let segment): segment.content.text
            case .expressionSegment: ""  // this should throw mf
            }
        }
        .joined()

        let decoder = XMLDecoder()
        let aProtocol = try Result {
            try decoder.decode(Protocol.self, from: rawText.data(using: .utf8)!)
        }.mapError { _ in WaylandProtocolMacroError.invalidXml }.get()

        let generator = Generator()
        for interface in aProtocol.interfaces {
            let decl = transform(interface: interface)
            generator.walk(node: decl)
            generator.add()
        }

        let out = generator.text
        let a = DeclSyntax(stringLiteral: out)

        return [a]
    }
}
