// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros
import WaylandScanner

@main
struct WaylandScannerPlugin: CompilerPlugin {
    var providingMacros: [Macro.Type] = [WaylandProtocolMacro.self]
}

public enum WaylandProtocolMacroError: Error {
    case invalidArguments
    case invalidXml
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
        -> (String, Options)
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

        return (
            xml,
            Options(
                trimPrefix: trimPrefix,
            )
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

        let (xml, options) = try parseOption(argumentList)
        let code = try Result {
            try generateClasses(xml, options: options)
        }.mapError { _ in WaylandProtocolMacroError.invalidXml }.get()

        return [
            DeclSyntax(stringLiteral: code)
        ]
    }
}
