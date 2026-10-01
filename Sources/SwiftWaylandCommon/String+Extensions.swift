extension String {
    private func trimmingWhitespace() -> Substring {
        guard let first = firstIndex(where: { !$0.isWhitespace }) else {
            return self[endIndex...]
        }

        let last = lastIndex(where: { !$0.isWhitespace })!
        return self[first...last]
    }

    private func uppercasingFirst() -> String {
        guard let first else { return self }
        return first.uppercased() + dropFirst()
    }

    public func snakeToLowerCamel() -> String {
        let parts = trimmingWhitespace()
            .split(separator: "_", omittingEmptySubsequences: true)

        guard let first = parts.first else { return "" }

        let head = first.lowercased()
        let tail = parts.dropFirst().map {
            $0.lowercased().uppercasingFirst()
        }

        return head + tail.joined()
    }

    public func snakeToCamel() -> String {
        let prefix = starts(with: "_") ? "_" : ""

        let camel = snakeToLowerCamel()
        guard let first = camel.first else { return "" }

        return prefix + first.uppercased() + camel.dropFirst()
    }

    public func camelToSnake() -> String {
        replacing(/([a-z0-9])([A-Z])/) { match in
            "\(match.1)_\(match.2)"
        }
        .lowercased()
    }

    public var snake: String {
        camelToSnake()
    }

    public var lowerCamel: String {
        snakeToLowerCamel()
    }

    public var camel: String {
        snakeToCamel()
    }

    public func indent(space: Int) -> String {
        indent(String(repeating: " ", count: space))
    }

    public func indent(_ indentation: String) -> String {
        split(separator: "\n", omittingEmptySubsequences: false)
            .map { indentation + $0 }
            .joined(separator: "\n")
    }

    public var comment: String {
        indent("/// ")
    }

    public var graved: String {
        "`\(self)`"
    }

    public var gravedIfNeeded: String {
        if swiftKeyword.contains(self) || first?.isNumber == true {
            graved
        } else {
            self
        }
    }

    public var trimmed: String {
        split(separator: "\n")
            .map { String($0).trimmingWhitespace() }
            .joined(separator: "\n")
    }

    public func withoutPrefix(_ prefix: String?) -> String {
        if let prefix {
            String(trimmingPrefix(prefix))
        } else {
            self
        }
    }

    public func trimmingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    public func trim(_ prefix: String?, _ suffix: String?) -> String {
        String(
            trimmingSuffix(suffix ?? "")
                .trimmingPrefix(prefix ?? "")
        )
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
