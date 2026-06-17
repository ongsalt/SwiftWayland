import SwiftWaylandCommon

let CALLBACK_TYPE: String = "@escaping (UInt32) -> Void"
let QUEUE_INNER_NAME: String = "_queue"

extension ProtocolDeclaration: Code {
    public func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        for c in self.classes {
            c.generate(gen)
            gen.add()
        }

        gen.add()
        gen.add(
            """
            public let \(self.name.gravedIfNeeded)Protocol = Protocol(
                    name: "\(self.protocol.name)",
                    interfaces: [
                        \(self.classes.map { "\($0.name).interface" }.joined(separator: ",\n"))
                    ]
                )
            """
        )
    }
}

extension ClassDeclaration: Code {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        if let docc = self.description?.docc {
            gen.add(docc: docc)
        }
        gen.add("public final class \(self.name): BaseProxy, Proxy {")
        gen.indent {
            gen.add(
                """
                public var onEvent: ((Event) -> Void)?
                public static let interface: Interface =
                """
            )
            gen.indent {
                gen.walk(node: self.interface)
            }

            for method in self.methods {
                // method.generate(gen)
                gen.walk(node: method)
                gen.add()
            }

            gen.add(
                """

                public static let `protocol`: Protocol = \(self.protocolName.gravedIfNeeded)Protocol

                """
            )

            for e in self.enums {
                gen.walk(node: e)
                gen.add()
            }

            if let d = self.deinit {
                gen.walk(node: d)
                gen.add()
            }

            if self.events.isEmpty {
                gen.add("public typealias Event = NoEvent")
            } else {
                gen.walk(node: self.events)
            }
        }
        gen.add("}")
    }
}

extension MethodDeclaration: Code {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        // Docc
        if let docc = self.description?.docc {
            gen.add(docc: docc)
        }

        // argument docc
        if !self.arguments.isEmpty {
            var lines = ["- Parameters:"]
            for arg in self.arguments {
                if let summary = arg.arg.summary {
                    lines.append("  - \(arg.externalName ?? arg.name): \(summary)")
                }
            }
            gen.add(docc: "")
            gen.add(docc: lines.joined(separator: "\n"))
        }

        // returns docc
        // TODO: multipl return value docc
        if !self.returns.isEmpty {
            if let summary = self.returns[0].arg.summary {
                gen.add(docc: "")
                gen.add(docc: "- Returns: \(summary)")
            }
        }

        // signature
        var functionHeader = ""
        // if self.isDestructor {
        //     functionHeader.append("consuming")
        // }

        functionHeader += "public func \(self.name.gravedIfNeeded)("
        var params = arguments.map { arg in
            var ty = arg.swiftType
            if arg.arg.nullable { ty += "?" }

            let defaultValue =
                if arg.arg.nullable {
                    "nil"
                } else {
                    arg.defaultValue
                }

            let defaultValueString =
                if let defaultValue {
                    " = \(defaultValue)"
                } else {
                    ""
                }

            let externalName =
                if let externalName = arg.externalName {
                    "\(externalName.gravedIfNeeded) "
                } else {
                    ""
                }

            return "\(externalName)\(arg.name.gravedIfNeeded): \(ty)\(defaultValueString)"
        }

        if !returns.isEmpty || !callbacks.isEmpty {
            params.append("queue \(QUEUE_INNER_NAME): EventQueue? = nil")
        }

        functionHeader += params.joined(separator: ", ")

        // TODO: throwing
        functionHeader += ") throws(WaylandProxyError)"

        if !returns.isEmpty {
            let ret =
                switch returns.count {
                case 0: ""
                case 1: returns[0].swiftType
                default:
                    "(\(returns.map {"\($0.name.gravedIfNeeded): \($0.swiftType)"}.joined(separator: ", ")))"
                }
            functionHeader += " -> \(ret)"
        }

        functionHeader.append(" {")
        gen.add(functionHeader)

        gen.indent {
            // State check
            gen.add(
                "guard self.isAlive else { throw WaylandProxyError.destroyed }"
            )

            // Version check
            if let since {
                gen.add(
                    "guard self.version >= \(since) else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: \(since)) }"
                )
            }

            if self.isDestructor {
                gen << "self.markDead()"
            }

            // currently returns.count will not be > 1
            // create any thing involving newId (infer from returns)

            // // create callbacks
            for callbacks in self.callbacks {
                gen.add(
                    """
                    let \(callbacks.name.gravedIfNeeded) = connection.createCallback(fn: \(callbacks.name.gravedIfNeeded), queue: \(QUEUE_INNER_NAME))
                    """
                )
            }

            let sendMethod =
                if self.returns.isEmpty {
                    "send"
                } else {
                    "sendConstructor"
                }

            var args = [
                "self",
                "\(self.requestId)",
            ]
            var letDecl = ""

            if !self.returns.isEmpty {
                let r = self.returns[0]
                args.append("\(r.swiftType).self")
                args.append("version")
                args.append(QUEUE_INNER_NAME)

                letDecl = "let \(r.name) = "
            }

            let argString = args.joined(separator: ", ")

            gen.block("\(letDecl)connection.\(sendMethod)(\(argString), [", endWith: "])") {
                for arg in self.messageArguments {
                    switch arg.arg.type {
                    case .object, .newId:  // newId gonna get ignore anyway
                        let name = arg.name.gravedIfNeeded
                        if !self.returns.isEmpty && name == self.returns[0].name {
                            gen << ".newId,"
                        } else {
                            gen << ".object(\(name)),"
                        }
                    case .uint:
                        let rawValueString = arg.arg.enum != nil ? ".rawValue" : ""
                        gen << ".uint(\(arg.name.gravedIfNeeded)\(rawValueString)),"
                    default:
                        gen << ".\(arg.arg.type)(\(arg.name.gravedIfNeeded)),"
                    }
                }
            }

            // Return
            switch self.returns.count {
            case 0:
                break
            case 1:
                gen.add("return \(self.returns[0].name)")
            default:
                fatalError("Cannot return more than 1 value at: \(self.requestName)")
            // gen.add("return (\(self.returns.map(\.name).joined(separator: ", ")))")
            }
        }
        gen.add("}")

    }
}

extension EnumDeclaration: Code {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        if !self.bitfield {
            gen.add("public enum \(self.name.gravedIfNeeded): UInt32 {")
            gen.indent {
                for (index, c) in self.cases.enumerated() {
                    gen.walk(node: c)
                    if index != self.cases.count - 1 {
                        gen.add()
                    }
                }
            }
            gen.add("}")
        } else {
            // OptionSet
            let name = self.name.gravedIfNeeded
            gen.block("public struct \(name): OptionSet, @unchecked Sendable {", endWith: "}") {
                gen << "public let rawValue: UInt32"
                gen.block("public init(rawValue: UInt32) {", endWith: "}") {
                    gen << "self.rawValue = rawValue"
                }
                gen.add()
                for (index, c) in self.cases.enumerated() {
                    if let summary = c.summary {
                        gen.add(docc: summary)
                    }
                    if index == 0 && c.value == 0 {
                        gen << "public static let \(c.name.gravedIfNeeded): \(name) = []"
                    } else {
                        gen
                            << "public static let \(c.name.gravedIfNeeded) = \(name)(rawValue: \(c.value))"
                    }
                    if index != self.cases.count - 1 {
                        gen.add()
                    }
                }
            }
        }
    }
}

extension EnumCaseDeclaration: Code {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        if let summary = self.summary {
            gen.add(docc: summary)
        }
        gen.add("case \(self.name.gravedIfNeeded) = \(self.value)")
    }
}

extension DeinitDeclaration: Code {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        gen << "var destructor: Destructor? = .\(destructors[0])"
        gen.add()

        gen.block("enum Destructor {", endWith: "}") {
            for m in destructors {
                gen << "case \(m)"
            }
        }
        gen.add()
        gen.block("deinit {", endWith: "}") {
            gen.block("if self.isAlive {", endWith: "}") {
                gen.block("switch self.destructor {", endWith: "}") {
                    for m in destructors {
                        gen << "case .\(m): try? self.\(m.gravedIfNeeded)()"
                    }
                    gen << "case nil: break"
                }
            }
        }
    }
}

extension Array: Code where Element == EventDeclaration {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        gen.block("public enum Event: MessageProtocol {") {
            for event in self {
                gen.walk(node: event)
                gen.add()
            }

            let destructors = self.filter { e in e.isDestructor }
            if !destructors.isEmpty {
                gen.block("public var isDestructor: Bool {") {
                    if destructors.count == self.count {
                        // every event is destructor
                        gen << "true"
                    } else {
                        gen.block("switch self {") {
                            let cases = destructors.map { ".\($0.name)" }.joined(separator: ", ")
                            gen << "case \(cases):"
                            gen.indent {
                                gen << "true"
                            }
                            gen << "default:"
                            gen.indent {
                                gen << "false"
                            }
                        }
                    }
                }
                gen.add()
            }

            // decoding function

            gen.add(
                "public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {"
            )
            gen.indent {
                gen.add("switch opcode {")
                for (index, event) in self.enumerated() {
                    gen.add("case \(index):")
                    gen.indent {
                        var out = "self = Self.\(event.name)"
                        if !event.arguments.isEmpty {
                            out +=
                                "(\(event.arguments.map { "\($0.name): \(getArgDecodingExpr($0))" }.joined(separator: ", ") ))"
                        }
                        gen.add(out)
                    }
                }
                gen.add("default:")
                gen.indent {
                    gen.add(
                        "fatalError(\"Unknown message: opcode=\\(opcode)\")"
                    )
                }
                gen.add("}")
            }
            gen.add("}")
        }
    }
}

private func getArgDecodingExpr(_ arg: ArgumentDeclaration) -> String {
    switch arg.arg.type {
    case .int: "r.int()"
    case .uint:
        if let e = arg.arg.enum {
            "try r.`enum`(\(parseEnumName(e)).self)"
        } else {
            "r.uint()"
        }
    case .fixed: "r.fixed()"
    case .string: "r.string()"
    case .fd: "r.fd()"
    case .enum: "r.uint()"
    case .object:
        if arg.swiftType == "any Proxy" {
            "r.object()"
        } else {
            "r.object(type: \(arg.swiftType).self)"
        }
    case .newId: "r.newId(type: \(arg.swiftType).self)"
    case .array: "r.array()"
    }
}

extension EventDeclaration: Code {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        if let description = self.description {
            gen.add(docc: description.docc)
        }

        var out = "case \(self.name)"
        if !self.arguments.isEmpty {
            out +=
                "(\(self.arguments.map {"\($0.name.gravedIfNeeded): \($0.swiftType)"}.joined(separator: ", ")))"
        }

        gen.add(out)
    }
}
