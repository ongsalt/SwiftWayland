import SwiftWaylandCommon

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
        gen.block("public final class \(self.name): BaseProxy, Proxy {") {
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
                e.generate(gen)
                gen.add()
            }

            if self.events.isEmpty {
                gen.add("public typealias Event = NoEvent")
            } else {
                gen.walk(node: self.events)
            }
        }
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

        let outNode: ArgumentDeclaration? =
            if !self.returns.isEmpty {
                self.returns[0]
            } else if !self.callbacks.isEmpty {
                self.callbacks[0]
            } else {
                nil
            }

        // returns docc
        // TODO: multipl return value docc
        if let outNode {
            if let summary = outNode.arg.summary {
                gen.add(docc: "")
                gen.add(docc: "- Returns: \(summary)")
            }
        }

        // signature
        // if self.isDestructor {
        //     functionHeader.append("consuming")
        // }

        var params = arguments.map { arg in
            let defaultValue = TypeConversion.defaultValue(of: arg.arg)

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

            let ty = TypeConversion.swiftType(of: arg.arg, escaping: true)
            return
                "\(externalName)\(arg.name.gravedIfNeeded): \(ty)\(defaultValueString)"
        }

        if outNode != nil {
            params.append("queue \(QUEUE_INNER_NAME): EventQueue? = nil")
        }

        let returnType: String? =
            switch returns.count {
            case 0: nil
            case 1: TypeConversion.swiftType(of: returns[0].arg)
            default:
                "(\(returns.map {"\($0.name.gravedIfNeeded): \(TypeConversion.swiftType(of: $0.arg))"}.joined(separator: ", ")))"
            }

        let returnString =
            if let returnType {
                " -> \(returnType)"
            } else {
                ""
            }

        let args = params.joined(separator: ", ")
        gen.block(
            "public func \(name.gravedIfNeeded)(\(args)) throws(WaylandProxyError)\(returnString) {"
        ) {
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

            // currently returns.count will not be > 1
            // create any thing involving newId (infer from returns)

            if !self.returns.isEmpty {
                gen << "let \(self.returns[0].name.gravedIfNeeded) = "
            } else if !self.callbacks.isEmpty {
                gen << "let _\(self.callbacks[0].name) = "
            }

            let callStatement =
                if outNode != nil {
                    "connection.sendConstructor"
                } else {
                    "connection.send"
                }

            var args = [
                "self",
                "\(self.requestId)",
            ]

            if let outNode {
                let ty = TypeConversion.swiftType(of: outNode.arg, forceOptional: false)
                args.append("\(ty).self")
                // if !self.returns.isEmpty {
                    args.append("version")
                // }
                args.append(QUEUE_INNER_NAME)
            }

            let argString = args.joined(separator: ", ")

            let conversions = self.messageArguments.map {
                TypeConversion.swiftToArg(swiftName: $0.name.gravedIfNeeded, argument: $0.arg)
            }

            gen.closures(of: conversions.lazy.compactMap(\.wrapping)) {
                gen.block("\(callStatement)(\(argString), [", endWith: "])") {
                    for (expr, _) in conversions {
                        gen << "\(expr),"
                    }
                }
            }

            for callback in self.callbacks {
                gen
                    << "_\(callback.name).register(\(callback.name.gravedIfNeeded))"
            }

            if self.isDestructor {
                gen << "connection.destroy(self)"
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
    }
}

extension Generator {
    func closures(of closures: some Sequence<Closure>, body: () -> Void) {
        var ends: [String] = []
        for c in closures {
            self << c.begin
            self.indentLevel += self.indentation
            ends.append(c.end)
        }

        body()

        for e in ends {
            self.indentLevel -= self.indentation
            self << e
        }
    }
}

extension EnumDeclaration: Code {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        if !self.bitfield {
            gen.block("public enum \(self.name.gravedIfNeeded): UInt32 {") {
                for (index, c) in self.cases.enumerated() {
                    gen.walk(node: c)
                    if index != self.cases.count - 1 {
                        gen.add()
                    }
                }
            }
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
                    if index == 0 && c.value == "0" {
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

extension Array: Code where Element == EventDeclaration {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        gen.block("public enum Event: MessageProtocol {") {
            for event in self {
                event.generate(gen)
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
                                "(\(event.arguments.map { "\($0.name): \(TypeConversion.wireToSwift(argument: $0.arg))" }.joined(separator: ", ") ))"
                        }
                        gen.add(out)
                    }
                }
                gen.add("default:")
                gen.indent {
                    gen << "throw DecodingError.badMessage(opcode: opcode)"
                }
                gen.add("}")
            }
            gen.add("}")
        }
    }
}

extension EventDeclaration: Code {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        if let description = self.description {
            gen.add(docc: description.docc)
        }

        var out = "case \(self.name)"
        if !self.arguments.isEmpty {
            let args = self.arguments.map { a in
                let forceOptional: Bool? = if a.arg.type == .object { true } else { nil }
                let ty = TypeConversion.swiftType(of: a.arg, forceOptional: forceOptional)
                return "\(a.name.gravedIfNeeded): \(ty)"
            }
            out += "(\(args.joined(separator: ", ")))"
        }

        gen.add(out)
    }
}
