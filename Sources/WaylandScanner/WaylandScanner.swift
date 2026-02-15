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

struct Options {
    var trimPrefix: String?
    var xml: String
}

// TODO: multiple attach macro on same struct
public struct WaylandProtocolMacro: MemberMacro {
    private static func toString(_ s: StringLiteralExprSyntax) -> String {
        s.segments.map {
            switch $0 {
            case .stringSegment(let segment): segment.content.text
            case .expressionSegment: ""  // this should throw mf
            }
        }.joined()
    }
    private static func parseOption(_ list: LabeledExprListSyntax) throws(WaylandProtocolMacroError)
        -> Options
    {
        guard case .stringLiteralExpr(let s) = list.last?.expression.as(ExprSyntaxEnum.self)
        else {
            throw .invalidArguments
        }
        let xml = toString(s)

        let trimPrefix: String? =
            if let f = list.first,
                f.label?.text == "trimPrefix",
                case .stringLiteralExpr(let s) = f.expression.as(ExprSyntaxEnum.self)
            {
                toString(s)
            } else {
                nil
            }

        return Options(
            trimPrefix: trimPrefix,
            xml: xml
        )
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws(WaylandProtocolMacroError) -> [DeclSyntax] {
        guard case .argumentList(let argumentList) = node.arguments
        else {
            throw .invalidArguments
        }

        let options = try parseOption(argumentList)

        return try generateClasses(options: options)
    }
}

func generateClasses(options: Options) throws(WaylandProtocolMacroError) -> [DeclSyntax] {
    let decoder = XMLDecoder()
    let aProtocol = try Result {
        try decoder.decode(Protocol.self, from: options.xml.data(using: .utf8)!)
    }.mapError { _ in WaylandProtocolMacroError.invalidXml }.get()

    let generator = Generator()
    for interface in aProtocol.interfaces {
        let decl = transform(interface: interface, trimPrefix: options.trimPrefix)
        generator.walk(node: decl)
        generator.add()
    }

    return [
        DeclSyntax(stringLiteral: generator.text)
    ]
}
