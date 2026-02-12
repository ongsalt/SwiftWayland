// import SwiftSyntax

func buildInterfaceClass(interface: Interface) -> String {
    let body: [String] = [
        buildMethods(interface.requests),
        buildEnums(interface.enums),
        buildEventEnum(events: interface.events),
    ].filter { !$0.isEmpty }

    return """
        import Foundation

        public final class \(interface.name.camel): WlProxyBase, WlProxy {
            public var onEvent: (Event) -> Void = { _ in }

        \(body.joined(separator: "\n\n").indent(space: 4))
        }

        """
}

struct SwiftFnSignature {
    struct ReturnType {
        let swiftType: String
        let name: String
    }
    let returnType: [ReturnType]
    let args: [(String, String)]

    var argString: String {
        var out = "("
        out += args.map { "\($0.0.gravedIfNeeded): \($0.1)" }.joined(separator: ", ")
        out += ")"

        return out
    }

    var withOutBracket: String {
        var out = ""
        out += argString
        if returnType.count > 0 {
            out += " -> \(returnTypeString)"
        }

        return out
    }

    var returnTypeString: String {
        switch returnType.count {
        case 0: ""
        case 1: returnType[0].swiftType
        default:
            "(\(returnType.map {"\($0.name.lowerCamel): \($0.swiftType)"}.joined(separator: ", ")))"
        }
    }
}

func makeSwiftFnSignature(_ request: Request) -> SwiftFnSignature? {
    // we return tuple when multiple newIds is founded
    var returnType: [SwiftFnSignature.ReturnType] = []
    var swiftArgs: [(String, String)] = []

    for arg in request.arguments {
        // newId -> return it
        // except wl_callback which we will receive a closure
        let argType: String
        if arg.type == .newId {
            // TODO: There is also a case where there is .newId without any type
            if arg.interface == "wl_callback" {
                // argType = "() -> Void"
                // or just leave it as is and process it later
                argType = "WlCallback"
            } else {
                if let interface = arg.interface {
                    returnType.append(
                        SwiftFnSignature.ReturnType(
                            swiftType: interface.camel,
                            name: arg.name.lowerCamel)
                    )
                } else {
                    return nil
                }
                continue
            }
        } else {
            argType = getSwiftArgType(arg)
        }

        swiftArgs.append((arg.name.lowerCamel, argType))
    }

    return SwiftFnSignature(returnType: returnType, args: swiftArgs)
}

func buildMethods(_ requests: [Request]) -> String {
    // TODO: transform
    requests.enumerated().map { (reqId, r) in
        // TODO: just return multiple value for multiple newId
        guard let signature = makeSwiftFnSignature(r) else {
            // its newId arg without a type
            // found in wl_registry::bind
            // im gonna skip this
            // well, we can, but it took too long

            return """
            // request `\(r.name)` can not (yet) be generated 
            // \(r.arguments)
            """
        }
        var statements: [String] = []

        // create any thing involving newId
        for instance in signature.returnType {
            statements.append(
                """
                let \(instance.name.gravedIfNeeded) = connection.createProxy(type: \(instance.swiftType).self)
                """)
        }
        // then put that into waylandData

        let waylandData = r.arguments.map { a in
            if a.type == .newId {
                ".\(a.type)(\(a.name.lowerCamel.gravedIfNeeded).id)"
            } else {
                ".\(a.type)(\(a.name.lowerCamel.gravedIfNeeded))"
            }
            // "WaylandData.\(a.type)(`\(a.name.lowerCamel)`)"
        }.joined(separator: ",\n")

        // Message sending
        let contentString =
            if waylandData.isEmpty {
                "[]"
            } else {
                """
                [
                \(waylandData.indent(space: 4))
                ]
                """
            }
        statements.append(
            """
            let message = Message(objectId: self.id, opcode: \(reqId), contents: \(contentString))
            connection.queueSend(message: message)
            """)

        // Return Expression
        if !signature.returnType.isEmpty {
            let finalTuple = signature.returnType.map { "\($0.name.lowerCamel)" }.joined(
                separator: ", ")
            statements.append("return \(finalTuple)")
        }

        return """
            public func \(r.name.lowerCamel)\(signature.withOutBracket) {
            \(statements.joined(separator: "\n").indent(space: 4))
            }
            """
    }.joined(separator: "\n\n")
}

func buildEnums(_ enums: [Enum]) -> String {
    enums.map { buildEnum($0) }.joined(separator: "\n\n")
}

func buildEnum(_ enumm: Enum) -> String {
    let cases = enumm.entries.map { e in
        return
            "case \(e.name.lowerCamel.gravedIfNeeded) = \(e.intValue.expect("invalid int value \(e)"))"
    }.joined(separator: "\n")

    return """
        public enum \(enumm.name.camel): UInt32, WlEnum {
        \(cases.indent(space: 4))
        }
        """

}

func buildEnumArgs(_ event: Event) -> String {
    event.arguments
        .map { a in
            "\(a.name.lowerCamel): \(getSwiftArgType(a))"
        }
        .joined(separator: ", ")
}

func getSwiftArgType(_ arg: Argument) -> String {
    switch arg.type {
    case .int: "Int32"
    case .uint: "UInt32"
    case .fixed: "Double"
    case .string: "String"

    case .fd: "FileHandle"

    case .enum: arg.enum.expect("Invalid xml: enum must not be nil").camel  // TODO: show context or smth
    // case .object: arg.interface.expect("Invalid xml: interface must not be nil: \(arg)").camel
    case .object: arg.interface?.camel ?? "any WlProxy"

    // case .newId: fatalError("Impossible (newId)")
    case .newId: arg.interface?.camel ?? "any WlProxy"
    case .array: "Data"
    }
}

func buildEventEnum(events: [Event]) -> String {
    let cases = events.map { e in
        let args = buildEnumArgs(e)
        let enumBody = e.arguments.count == 0 ? "" : "(\(args))"

        return "case \(e.name.lowerCamel.gravedIfNeeded)\(enumBody)"
    }.joined(separator: "\n")

    return """
        public enum Event: WlEventEnum {
        \(cases.indent(space: 4))

        \(buildDecodeFunction(events).indent(space: 4))
        }
        """
}

func getArgDecodingExpr(_ arg: Argument) -> String {
    switch arg.type {
    case .int: "r.readInt()"
    case .uint: "r.readUInt()"
    case .fixed: "r.readFixed()"
    case .string: "r.readString()"

    case .fd: "r.readFd()"

    case .enum: "r.readEnum()"
    // case .object: "r.readObjectId()"
    case .object:
        if let interface = arg.interface {
            "connection.get(as: \(interface.camel).self, id: r.readObjectId())!"
        } else {
            "connection.get(id: r.readObjectId())!"
        }

    // case .newId: fatalError("Impossible (newId)")
    case .newId:
        if let interface = arg.interface {
            "connection.createProxy(type: \(interface.camel).self, id: r.readNewId())"
        } else {
            fatalError("wtf, how can you have newId without a type: \(arg)")
        }

    case .array: "r.readArray()"
    }
}

func buildDecodeFunction(_ events: [Event]) -> String {
    func buildCallingArgs(_ args: [Argument]) -> String {
        if args.contains(where: { $0.type == .newId }) {
            // fatalError("new_id in event is not support")
        }

        return args.map { a in
            "\(a.name.lowerCamel): \(getArgDecodingExpr(a))"
        }.joined(separator: ", ")
    }

    let cases = events.enumerated().map { (index, e) in
        let args = buildCallingArgs(e.arguments)
        let enumBody = e.arguments.count == 0 ? "" : "(\(args))"

        return """
            case \(index):
                return Self.\(e.name.lowerCamel.gravedIfNeeded)\(enumBody)
            """
    }.joined(separator: "\n")

    return """
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
        \(cases.indent(space: 4))
            default:
                fatalError("Unknown message")
            }
        }
        """
}
