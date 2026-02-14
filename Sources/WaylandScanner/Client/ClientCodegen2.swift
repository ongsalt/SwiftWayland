class Generator {
    // let useAsync: Bool = false
    var stack: [any Code] = []
    var indentation: Int = 4
    var indentLevel: Int = 0
    let imports: [String] = []

    var text: String = ""

    func add(raw string: String) {
        text += string
    }

    func add(_ string: String) {
        text += string.indent(space: indentLevel) + "\n"
    }

    func add() {
        text += "\n"
    }

    func add(docc str: String) {
        add("\(str)".indent("/// "))
    }

    func add(comment str: String) {
        add("\(str)".indent("// "))
    }

    func indent(_ block: () -> Void) {
        self.indentLevel += indentation
        block()
        self.indentLevel -= indentation
    }

    func walk(node: some Code) {
        stack.append(node)
        node.generate(self)
        _ = stack.popLast()
    }
}

protocol Code {
    func generate(_ generator: Generator)
}

extension ClassDeclaration: Code {
    func generate(_ gen: Generator) {
        gen.add("import Foundation")
        for name in gen.imports {
            gen.add("import \(name)")
        }
        gen.add()

        if let docc = self.description?.docc {
            gen.add(docc: docc)
        }
        gen.add("public final class \(self.name): WlProxyBase, WlProxy, WlInterface {")
        gen.indent {
            gen.add(
                """
                public static let name: String = "\(self.name)"
                """
            )
            gen.add("public var onEvent: (Event) -> Void = { _ in }")

            for method in self.methods {
                // method.generate(gen)
                gen.walk(node: method)
                gen.add()
            }

            // self.events.generate(gen)
        }
        gen.add("}")
    }
}

extension MethodDeclaration: Code {
    func generate(_ gen: Generator) {
        if let docc = self.description?.docc {
            gen.add(docc: docc)
        }

        if self.returns.contains(where: { $0.type.swiftType == "any WlProxy" }) {
            gen.add(comment: "request `\(name)` can not be generated as it use dynamic new_id argument")
            return
        }

        var functionHeader: [String] = ["public"]
        if self.consuming {
            functionHeader.append("consuming")
        } else {
        }

        functionHeader.append("func")
        functionHeader.append(self.name.gravedIfNeeded)
        if arguments.isEmpty {
            functionHeader.append("()")
        } else {
            let params = arguments.map { arg in
                if let externalName = arg.externalName {
                    "\(externalName.gravedIfNeeded) \(arg.name.gravedIfNeeded): \(arg.type.swiftType)"
                } else {
                    "\(arg.name.gravedIfNeeded): \(arg.type.swiftType)"
                }
            }.joined(separator: ", ")
            functionHeader.append("(\(params))")
        }

        // TODO: throwing
        functionHeader.append("throws(WaylandProxyError)")

        if !returns.isEmpty {
            let ret =
                switch returns.count {
                case 0: ""
                case 1: returns[0].type.swiftType
                default:
                    "(\(returns.map {"\($0.name.gravedIfNeeded): \($0.type.swiftType)"}.joined(separator: ", ")))"
                }
            functionHeader.append("->")
            functionHeader.append(ret)
        }

        functionHeader.append("{")
        gen.add(functionHeader.joined(separator: " "))
        gen.indent {
            // State check
            gen.add(
                "guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }"
            )

            // Version check
            if let since {
                gen.add(
                    "guard self.version >= \(since) else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: \(since)) }"
                )
            }

            // create any thing involving newId (infer from returns)
            for object in self.returns {
                // type of return is always newId, so a swift class type
                gen.add(
                    """
                    let \(object.name.gravedIfNeeded) = connection.createProxy(type: \(object.type.swiftType).self, version: self.version)
                    """
                )
            }

            // Callback
            for arg in self.arguments {
                if case .callback = arg.type {
                    gen.add(
                        """
                        let \(arg.name.gravedIfNeeded) = connection.createCallback(fn: \(arg.name.gravedIfNeeded))
                        """
                    )
                }
            }

            gen.add(
                "let message = Message(objectId: self.id, opcode: \(self.requestId), contents: [")
            gen.indent {
                for arg in self.messageArguments {
                    switch arg.type {
                    case .callback, .newProxy:
                        gen.add(
                            "WaylandData.\(arg.type.waylandData)(\(arg.name.gravedIfNeeded).id),")
                    default:
                        gen.add("WaylandData.\(arg.type.waylandData)(\(arg.name.gravedIfNeeded)),")
                    }
                }
            }
            gen.add("])")
            gen.add("connection.send(message: message)")

            if self.consuming {
                // TODO: read docs about destructor behavior
                gen.add(
                    """
                    self._state = .dropped
                    connection.removeObject(id: self.id)
                    """
                )
            }

            // Return
            switch self.returns.count {
            case 0:
                break
            case 1:
                gen.add("return \(self.returns[0].name)")
            default:
                gen.add("return (\(self.returns.map(\.name).joined(separator: ", ")))")
            }
        }
        gen.add("}")

    }
}

extension Array: Code where Element == EventDeclaration {
    func generate(_ gen: Generator) {

    }
}
