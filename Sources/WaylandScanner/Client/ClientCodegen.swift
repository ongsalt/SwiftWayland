import SwiftWaylandCommon

let CALLBACK_TYPE: String = "@escaping (UInt32) -> Void"
let QUEUE_INNER_NAME: String = "_queue"

extension ProtocolDeclaration: Code {
    func generate(_ gen: Generator) {
        for c in self.classes {
            gen.walk(node: c)
        }

        gen.add()
        gen.add(
            """
            public let \(self.name.gravedIfNeeded) = Protocol(
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

            gen.add(
                """

                @_spi(SwiftWaylandPrivate)
                override public class func ensureLoaded() {
                    CRuntimeInfo.shared.addIfNotExists(protocol: \(self.protocolName.gravedIfNeeded))
                }

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
    func generate(_ gen: Generator) {
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
        // if self.consuming {
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

            // create any thing involving newId (infer from returns)
            for object in self.returns {
                // type of return is always newId, so a swift class type
                gen.add(
                    """
                    let \(object.name.gravedIfNeeded) = connection.createProxy(type: \(object.swiftType).self, version: self.version, queue: \(QUEUE_INNER_NAME) ?? self.queue)
                    """
                )
            }

            // // create callbacks
            for callbacks in self.callbacks {
                gen.add(
                    """
                    let \(callbacks.name.gravedIfNeeded) = connection.createCallback(fn: \(callbacks.name.gravedIfNeeded), queue: \(QUEUE_INNER_NAME) ?? self.queue)
                    """
                )
            }

            gen.add(
                "connection.send(self, \(self.requestId), ["
            )
            gen.indent {
                for arg in self.messageArguments {
                    switch arg.arg.type {
                    case .object, .newId:
                        if arg.arg.nullable {
                            gen << ".object(\(arg.name.gravedIfNeeded)?.id ?? 0),"
                        } else {
                            gen << ".object(\(arg.name.gravedIfNeeded).id),"
                        }
                    case .string:
                        if arg.arg.nullable {
                            gen << ".string(\(arg.name.gravedIfNeeded) ?? \"\"),"
                        } else {
                            gen << ".string(\(arg.name.gravedIfNeeded)),"
                        }
                    case .uint:
                        var rawValueString = arg.arg.enum != nil ? ".rawValue" : ""
                        gen.add(
                            ".\(arg.arg.type)(\(arg.name.gravedIfNeeded)\(rawValueString)),"
                        )
                    default:
                        gen.add(".\(arg.arg.type)(\(arg.name.gravedIfNeeded)),")
                    }
                }
            }
            gen.add("])")

            if self.consuming {
                // TODO: read docs about destructor behavior
                // gen.add(
                //     """
                //     self._state = .dropped
                //     connection.removeObject(id: self.id)
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
                    if index == 0 {
                        gen << "static let \(c.name.gravedIfNeeded): \(name) = []"
                    } else {
                        gen << "static let \(c.name.gravedIfNeeded) = \(name)(rawValue: \(c.value))"
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

private func getArgDecodingExpr(_ arg: ArgumentDeclaration) -> String {
    switch arg.arg.type {
    case .int: "r.int()"
    case .uint:
        if let e = arg.arg.enum {
            "try _parseEnum(into: \(parseEnumName(e)).self, r.uint())"
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
