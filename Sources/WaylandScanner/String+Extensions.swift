extension String {
    func snakeToLowerCamel() -> String {
        let parts =
            self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "_", omittingEmptySubsequences: true)

        guard let first = parts.first else { return "" }

        let head = first.lowercased()
        let tail = parts.dropFirst().map { $0.lowercased().capitalized }

        return ([head] + tail).joined()
    }

    func snakeToCamel() -> String {
        let camel = snakeToLowerCamel()
        guard let first = camel.first else { return "" }

        return String(first).uppercased() + camel.dropFirst()
    }

    var lowerCamel: String {
        snakeToLowerCamel()
    }

    var camel: String {
        snakeToCamel()
    }

    func indent(space: Int) -> String {
        self.indent(String(repeating: " ", count: space))
    }

    func indent(_ indentation: String) -> String {
        return
            self
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { indentation + $0 }
            .joined(separator: "\n")
    }

    var comment: String {
        indent("/// ")
    }

    var graved: String {
        "`\(self)`"
    }

    var gravedIfNeeded: String {
        if swiftKeyword.contains(self) || self.first?.isNumber == true {
            self.graved
        } else {
            self
        }
    }

    var trimmed: String {
        self
            .split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: "\n")
    }

    func withoutPrefix(_ prefix: String?) -> String {
        if let prefix {
            String(self.trimmingPrefix(prefix))
        } else {
            self
        }
    }
}

// Copied from SwiftSyntax, its private
// weak keyword is sometime allowed tho
let swiftKeyword: Set<String> = [
    "__consuming",
    "__owned",
    "__setter_access",
    "__shared",
    "_backDeploy",
    "_borrow",
    "_borrowing",
    "_BridgeObject",
    "_Class",
    "_compilerInitialized",
    "_const",
    "_consuming",
    "_documentation",
    "_dynamicReplacement",
    "_effects",
    "_forward",
    "_implements",
    "_linear",
    "_local",
    "_modify",
    "_move",
    "_mutating",
    "_NativeClass",
    "_NativeRefCountedObject",
    "_noMetadata",
    "_opaqueReturnTypeOf",
    "_originallyDefinedIn",
    "_PackageDescription",
    "_read",
    "_RefCountedObject",
    "_specialize",
    "_spi_available",
    "_Trivial",
    "_TrivialAtMost",
    "_TrivialStride",
    "_underlyingVersion",
    "_UnknownLayout",
    "_version",
    "abi",
    "accesses",
    "actor",
    "addressWithNativeOwner",
    "addressWithOwner",
    "any",
    "Any",
    "as",
    "assignment",
    "associatedtype",
    "associativity",
    "async",
    "attached",
    "autoclosure",
    "availability",
    "available",
    "await",
    "backDeployed",
    "before",
    "block",
    "borrow",
    "borrowing",
    "break",
    "canImport",
    "case",
    "catch",
    "class",
    "compiler",
    "consume",
    "copy",
    "consuming",
    "continue",
    "convenience",
    "convention",
    "default",
    "defer",
    "deinit",
    "dependsOn",
    "deprecated",
    "derivative",
    "didSet",
    "differentiable",
    "distributed",
    "do",
    "dynamic",
    "each",
    "else",
    "enum",
    "escaping",
    "exported",
    "extension",
    "fallthrough",
    "false",
    "file",
    "fileprivate",
    "final",
    "for",
    "discard",
    "forward",
    "func",
    "freestanding",
    "get",
    "guard",
    "higherThan",
    "if",
    "import",
    "in",
    "indirect",
    "infix",
    "init",
    "initializes",
    "inout",
    "internal",
    "introduced",
    "is",
    "isolated",
    "kind",
    "lazy",
    "left",
    "let",
    "line",
    "linear",
    "lowerThan",
    "macro",
    "message",
    "metadata",
    "modify",
    "module",
    "mutableAddressWithNativeOwner",
    "mutableAddressWithOwner",
    "mutating",
    "nil",
    "noasync",
    "noDerivative",
    "noescape",
    "none",
    "nonisolated",
    "nonmutating",
    "nonsending",
    "objc",
    "obsoleted",
    "of",
    "open",
    "operator",
    "optional",
    "override",
    "package",
    "postfix",
    "precedencegroup",
    "preconcurrency",
    "prefix",
    "private",
    "Protocol",
    "protocol",
    "public",
    "read",
    "reasync",
    "renamed",
    "repeat",
    "required",
    "rethrows",
    "retroactive",
    "return",
    "reverse",
    "right",
    "safe",
    "scoped",
    "self",
    "sending",
    "Self",
    "Sendable",
    "set",
    "some",
    "spi",
    "spiModule",
    "static",
    "struct",
    "subscript",
    "super",
    "swift",
    "switch",
    "target",
    "then",
    "throw",
    "throws",
    "transpose",
    "true",
    "try",
    "Type",
    "typealias",
    "unavailable",
    "unchecked",
    "unowned",
    "unsafe",
    "unsafeAddress",
    "unsafeMutableAddress",
    "using",
    "var",
    "visibility",
    "weak",
    "where",
    "while",
    "willSet",
    "wrt",
    "yield",
]
