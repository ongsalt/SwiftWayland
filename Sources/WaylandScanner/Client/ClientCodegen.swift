import SwiftWaylandCommon

let CALLBACK_TYPE: String = "@escaping (UInt32) -> Void"
let QUEUE_INNER_NAME: String = "_queue"

extension ProtocolDeclaration: Code {
    func generate(_ gen: Generator) {
        for c in self.classes {
            gen.walk(node: c)
        }

        // Initilaization code
        gen.add()
        // this shit is either lazy or get treeshake away 
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
            gen.add("public var onEvent: ((Event) -> Void)?")
            if !self.events.isEmpty {
                gen.add("public let events: AsyncStream<Event>")
                gen.add("private let _eventsContinuation: AsyncStream<Event>.Continuation")
            }
            gen.add("public static let interface: Interface =")
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

            if !self.events.isEmpty {
                gen.add()
                gen.add("public required init(id: UInt32, version: UInt32, queue: EventQueue, raw: OpaquePointer, connection: Connection) {")
                gen.indent {
                    gen.add("let (stream, continuation) = AsyncStream<Event>.makeStream()")
                    gen.add("self.events = stream")
                    gen.add("self._eventsContinuation = continuation")
                    gen.add("super.init(id: id, version: version, queue: queue, raw: raw, connection: connection)")
                    gen.add("self._emitEvent = { [continuation] any in")
                    gen.indent {
                        gen.add("guard let event = any as? Event else { return }")
                        gen.add("continuation.yield(event)")
                    }
                    gen.add("}")
                    gen.add("self._finishStream = { continuation.finish() }")
                    let destructorOpcodes = self.events.enumerated()
                        .filter { $1.isDestructor }
                        .map { String($0.offset) }
                    if !destructorOpcodes.isEmpty {
                        gen.add("self._destructorOpcodes = [\(destructorOpcodes.joined(separator: ", "))]")
                    }
                }
                gen.add("}")
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
                    switch arg.waylandType {
                    case .object, .newId:
                        if arg.nullable {
                            gen.add(".nullableObject(\(arg.name.gravedIfNeeded)?.id),")
                        } else {
                            gen.add(".object(\(arg.name.gravedIfNeeded).id),")
                        }
                    case .string:
                        if arg.nullable {
                            gen.add(".nullableString(\(arg.name.gravedIfNeeded)),")
                        } else {
                            gen.add(".string(\(arg.name.gravedIfNeeded)),")
                        }
                    case .enum:
                        gen.add(
                            ".\(arg.waylandType)(\(arg.name.gravedIfNeeded).rawValue),"
                        )
                    default:
                        gen.add(".\(arg.waylandType)(\(arg.name.gravedIfNeeded)),")
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
        if bitfield {
            gen.add("public struct \(self.name.gravedIfNeeded): OptionSet, Sendable {")
            gen.indent {
                gen.add("public let rawValue: UInt32")
                gen.add("public init(rawValue: UInt32) { self.rawValue = rawValue }")
                gen.add()
                for c in self.cases {
                    if let summary = c.summary { gen.add(docc: summary) }
                    gen.add("public static let \(c.name.gravedIfNeeded) = Self(rawValue: \(c.value))")
                }
            }
            gen.add("}")
        } else {
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
        gen.add("public enum Event: Decodable, @unchecked Sendable {")
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
    case .int: return "r.int()"
    case .uint: return "r.uint()"
    case .fixed: return "r.fixed()"
    case .string: return arg.nullable ? "r.optionalString()" : "r.string()"
    case .fd: return "r.fd()"
    case .enum: return "r.uint()"
    case .object:
        if arg.nullable {
            let baseType = arg.swiftType.hasSuffix("?") ? String(arg.swiftType.dropLast()) : arg.swiftType
            return baseType == "any Proxy" ? "r.optionalObject()" : "r.optionalObject(type: \(baseType).self)"
        } else {
            return arg.swiftType == "any Proxy" ? "r.object()" : "r.object(type: \(arg.swiftType).self)"
        }
    case .newId: return "r.newId(type: \(arg.swiftType).self)"
    case .array: return "r.array()"
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
