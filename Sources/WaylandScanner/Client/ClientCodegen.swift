import SwiftWaylandCommon

let CALLBACK_TYPE: String = "@escaping (UInt32) -> Void"
let QUEUE_INNER_NAME: String = "_queue"

extension ClassDeclaration: Code {
    func generate(_ gen: Generator) {
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
    func generate(_ gen: Generator) {
        // Docc
        if let docc = self.description?.docc {
            gen.add(docc: docc)
        }

        // argument docc
        if !self.arguments.isEmpty {
            var lines = ["- Parameters:"]
            for arg in self.arguments {
                if let summary = arg.summary {
                    lines.append("  - \(arg.externalName ?? arg.name): \(summary)")
                }
            }
            gen.add(docc: "")
            gen.add(docc: lines.joined(separator: "\n"))
        }

        // returns docc
        // TODO: multipl return value docc
        if !self.returns.isEmpty {
            if let summary = self.returns[0].summary {
                gen.add(docc: "")
                gen.add(docc: "- Returns: \(summary)")
            }
        }

        // signature
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
                "guard self.isAlive else { throw WaylandProxyError.destroyed }"
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
                    let \(object.name.gravedIfNeeded) = backend.createProxy(type: \(object.swiftType).self, version: self.version, parent: self, queue: \(QUEUE_INNER_NAME) ?? self.queue)
                    """
                )
            }

            // // create callbacks
            for callbacks in self.callbacks {
                gen.add(
                    """
                    let \(callbacks.name.gravedIfNeeded) = backend.createCallback(fn: \(callbacks.name.gravedIfNeeded), parent: self, queue: \(QUEUE_INNER_NAME) ?? self.queue)
                    """
                )
            }

            gen.add(
                "backend.send(self.id, \(self.requestId), ["
            )
            gen.indent {
                for arg in self.messageArguments {
                    switch arg.waylandType {
                    case .object, .newId:
                        gen.add(
                            ".\(arg.waylandType)(\(arg.name.gravedIfNeeded).id),")
                    case .enum:
                        gen.add(
                            ".\(arg.waylandType)(\(arg.name.gravedIfNeeded).rawValue),"
                        )
                    default:
                        gen.add(".\(arg.waylandType)(\(arg.name.gravedIfNeeded)),")
                    }
                }
            }
            gen.add("], queue: nil)")

            if self.consuming {
                // TODO: read docs about destructor behavior
                // gen.add(
                //     """
                //     self._state = .dropped
                //     backend.removeObject(id: self.id)
                //     """
                // )
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
            gen.add("if self.isAlive {")
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
        gen.add("public enum Event: Decodable {")
        gen.indent {
            for event in self {
                gen.walk(node: event)
                gen.add()
            }

            // decoding function

            gen.add(
                "public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {"
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
        gen.add("}")
    }
}

private func getArgDecodingExpr(_ arg: WaylandArgumentDeclaration) -> String {
    switch arg.waylandType {
    case .int: "r.int()"
    case .uint: "r.uint()"
    case .fixed: "r.fixed()"
    case .string: "r.string()"
    case .fd: "r.fd()"
    case .enum: "r.uint()"
    case .object: "r.object(type: \(arg.swiftType).self)"
    case .newId: "r.newId(type: \(arg.swiftType).self)"
    case .array: "r.array()"
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
