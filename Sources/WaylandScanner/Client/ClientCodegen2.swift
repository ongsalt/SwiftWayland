let CALLBACK_TYPE: String = "@escaping (UInt32) -> Void"
let QUEUE_INNER_NAME: String = "_queue"

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
                public static let name: String = "\(self.interfaceName)"
                """
            )
            gen.add("public var onEvent: (Event) -> Void = { _ in }")

            for method in self.methods {
                // method.generate(gen)
                gen.walk(node: method)
                gen.add()
            }

            for e in self.enums {
                gen.walk(node: e)
                gen.add()
            }

            if let d = self.deinit {
                gen.walk(node: d)
                gen.add()
            }

            // wl_display.error might send a deallocated objectId
            // so we must handle this manually
            if !self.events.isEmpty && self.interfaceName != "wl_display" {
                gen.walk(node: self.events)
            }
        }
        gen.add("}")
    }
}

extension MethodDeclaration: Code {
    func generate(_ gen: Generator) {
        if let docc = self.description?.docc {
            gen.add(docc: docc)
        }

        var functionHeader: [String] = ["public"]
        if self.consuming {
            functionHeader.append("consuming")
        }

        functionHeader.append("func")
        if arguments.isEmpty {
            functionHeader.append("\(self.name.gravedIfNeeded)()")
        } else {
            let params = arguments.map { arg in
                var str = "\(arg.name.gravedIfNeeded): \(arg.swiftType)"
                if let externalName = arg.externalName {
                    str = "\(externalName.gravedIfNeeded) \(str)"
                } 
                if let defaultValue = arg.defaultValue {
                    str = "\(str) = \(defaultValue)"
                } 
                return str
            }.joined(separator: ", ")
            functionHeader.append("\(self.name.gravedIfNeeded)(\(params))")
        }

        // TODO: throwing
        functionHeader.append("throws(WaylandProxyError)")

        if !returns.isEmpty {
            let ret =
                switch returns.count {
                case 0: ""
                case 1: returns[0].swiftType
                default:
                    "(\(returns.map {"\($0.name.gravedIfNeeded): \($0.swiftType)"}.joined(separator: ", ")))"
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
                    let \(object.name.gravedIfNeeded) = connection.createProxy(type: \(object.swiftType).self, version: self.version, queue: \(QUEUE_INNER_NAME))
                    """
                )
            }

            // create callbacks
            for callbacks in self.callbacks {
                gen.add(
                    """
                    let \(callbacks.name.gravedIfNeeded) = connection.createCallback(fn: \(callbacks.name.gravedIfNeeded), queue: \(QUEUE_INNER_NAME))
                    """
                )
            }

            gen.add(
                "let message = Message(objectId: self.id, opcode: \(self.requestId), contents: ["
            )
            gen.indent {
                for arg in self.messageArguments {
                    switch arg.waylandType {
                    case .object, .newId:
                        gen.add(
                            "WaylandData.\(arg.waylandType)(\(arg.name.gravedIfNeeded).id),")
                    case .enum:
                        gen.add(
                            "WaylandData.\(arg.waylandType)(\(arg.name.gravedIfNeeded).rawValue),"
                        )
                    default:
                        gen.add("WaylandData.\(arg.waylandType)(\(arg.name.gravedIfNeeded)),")
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

extension EnumDeclaration: Code {
    func generate(_ gen: Generator) {
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
    }
}

extension EnumCaseDeclaration: Code {
    func generate(_ gen: Generator) {
        if let summary = self.summary {
            gen.add(docc: summary)
        }
        gen.add("case \(self.name.gravedIfNeeded) = \(self.value)")
    }
}

extension DeinitDeclaration: Code {
    func generate(_ gen: Generator) {
        gen.add("deinit {")
        gen.indent {
            gen.add("if self._state == WaylandProxyState.alive {")
            gen.indent {
                gen.add("try? self.\(self.selectedMethod.gravedIfNeeded)()")
            }
            gen.add("}")
        }
        gen.add("}")
    }
}

extension Array: Code where Element == EventDeclaration {
    func generate(_ gen: Generator) {
        // luckily there is no enum named `event`
        gen.add("public enum Event: WlEventEnum {")
        gen.indent {
            for event in self {
                gen.walk(node: event)
                gen.add()
            }

            // decoding function

            gen.add(
                "public static func decode(message: Message, connection: Connection, version: UInt32) -> Self {"
            )
            gen.indent {
                let reader = true
                if reader {
                    gen.add(
                        "var r = ArgumentReader(data: message.arguments, fdSource: connection.socket)"
                    )
                }
                gen.add("switch message.opcode {")
                for (index, event) in self.enumerated() {
                    gen.add("case \(index):")
                    gen.indent {
                        var out = "return Self.\(event.name)"
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
                        "fatalError(\"Unknown message: opcode=\\(message.opcode) \\(message.arguments as NSData)\")"
                    )
                }
                gen.add("}")
            }
            gen.add("}")
        }
        gen.add("}")
    }
}

private func getArgDecodingExpr(_ arg: WaylandArgumentDeclaration) -> String {
    switch arg.waylandType {
    case .int: "r.readInt()"
    case .uint: "r.readUInt()"
    case .fixed: "r.readFixed()"
    case .string: "r.readString()"
    case .fd: "r.readFd()"
    case .enum: "r.readEnum()"
    case .object: "connection.get(as: \(arg.swiftType).self, id: r.readObjectId())!"
    case .newId:
        // TODO: queue
        "connection.createProxy(type: \(arg.swiftType).self, version: version, id: r.readNewId())"
    case .array: "r.readArray()"
    }
}

extension EventDeclaration: Code {
    func generate(_ gen: Generator) {
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
