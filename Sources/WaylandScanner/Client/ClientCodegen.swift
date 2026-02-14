// import SwiftSyntax

let CALLBACK_TYPE: String = "@escaping (UInt32) -> Void"

func buildInterfaceClass(interface: Interface, importName: String? = nil) -> String {
    let body: [String] = [
        buildMethods(interface.requests),
        buildEnums(interface.enums),
        buildEventEnum(events: interface.events),
    ].filter { !$0.isEmpty }

    var imports = ["Foundation"]
    if let importName {
        imports.append(importName)
    }

    let importString = imports.map { "import \($0)" }.joined(separator: "\n")

    return """
        \(importString)
        
        \(interface.description?.docc.comment ?? "")
        public final class \(interface.name.camel): WlProxyBase, WlProxy, WlInterface {
            public static let name: String = "\(interface.name)"
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
        out += " throws(WaylandProxyError)"
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

    let arguments = request.arguments.filter { $0.interface != "wl_callback" }
    let callbacks = request.arguments.filter { $0.interface == "wl_callback" }

    for arg in arguments {
        // newId -> return it
        // except wl_callback which we will receive a closure
        let argType: String
        if arg.type == .newId {
            // TODO: There is also a case where there is .newId without any type (i found only wl_registry::bind)
            // we currently write this manually
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
            // }
        } else {
            argType = getSwiftArgType(arg)
        }

        swiftArgs.append((arg.name.lowerCamel, argType))
    }

    for callback in callbacks {
        swiftArgs.append((callback.name.lowerCamel, CALLBACK_TYPE))
    }

    return SwiftFnSignature(returnType: returnType, args: swiftArgs)
}

func buildMethod(_ r: Request, _ reqId: Int) -> String {
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

    // check if object is destroyed
    statements.append(
        """
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        """)

    // version check
    if let availableSince = r.since {
        statements.append(
            """
            guard self.version >= \(availableSince) else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: \(availableSince)) }
            """)
    }

    // create any thing involving newId
    for instance in signature.returnType {
        statements.append(
            """
            let \(instance.name.gravedIfNeeded) = connection.createProxy(type: \(instance.swiftType).self, version: self.version)
            """)
    }

    // Callback
    let callbacks = signature.args.filter { $0.1 == CALLBACK_TYPE }
    for (name, _) in callbacks {
        statements.append(
            """
            let \(name.gravedIfNeeded) = connection.createCallback(fn: \(name.gravedIfNeeded))
            """)
    }

    // then put that into waylandData
    let waylandData = r.arguments.map { a in
        if a.type == .newId {
            "WaylandData.\(a.type)(\(a.name.lowerCamel.gravedIfNeeded).id)"
        } else {
            "WaylandData.\(a.type)(\(a.name.lowerCamel.gravedIfNeeded))"
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
        connection.send(message: message)
        """)

    if r.type == .destructor {
        // TODO: read docs about destructor behavior
        statements.append(
            """
            self._state = .dropped
            connection.removeObject(id: self.id)
            """)
    }

    // Return Expression
    if !signature.returnType.isEmpty {
        let finalTuple = signature.returnType.map { "\($0.name.gravedIfNeeded)" }.joined(
            separator: ", ")
        statements.append("return \(finalTuple)")
    }

    // ok there is a wp_image_description_creator_icc_v1::create which produce new object
    // and there are interface with more than 1 destructor as well, like ext_session_lock_v1
    // we might just call it a consuming instead
    let blockHeader =
        switch r.type {
        case .destructor:
            "public consuming func \(r.name.lowerCamel.gravedIfNeeded)\(signature.withOutBracket)"
        default:
            "public func \(r.name.lowerCamel.gravedIfNeeded)\(signature.withOutBracket)"
        }

    let docc = r.docc.map { "\($0.comment)\n" } ?? ""

    return """
        \(docc)\(blockHeader) {
        \(statements.joined(separator: "\n").indent(space: 4))
        }
        """
}

func buildMethods(_ requests: [Request]) -> String {
    // TODO: transform
    var methods = requests.enumerated().map { (reqId, r) in
        buildMethod(r, reqId)
    }

    // auto run first destructor without any argument
    if let destructor = requests.first(where: { $0.type == .destructor && $0.arguments.count == 0 })
    {
        methods.append(
            """
            deinit {
                try! self.\(destructor.name.lowerCamel.gravedIfNeeded)()
            }
            """)
    }

    return methods.joined(separator: "\n\n")
}

func buildEnums(_ enums: [Enum]) -> String {
    enums.map { buildEnum($0) }.joined(separator: "\n\n")
}

func buildEnum(_ enumm: Enum) -> String {
    let cases = enumm.entries.map { e in
        var lines: [String] = []
        if let docc = e.docc {
            lines.append(docc.comment)
        }
        lines.append("case \(e.name.lowerCamel.gravedIfNeeded) = \(e.value)")
        return lines.joined(separator: "\n")
        // TODO: might keep hex as is
        // "case \(e.name.lowerCamel.gravedIfNeeded) = \(e.intValue.expect("invalid int value \(e)"))"
    }.joined(separator: "\n\n")

    var chunks: [String] = []
    if let docc = enumm.docc {
        chunks.append(docc.comment)
    }
    chunks.append(
        """
        public enum \(enumm.name.camel.gravedIfNeeded): UInt32, WlEnum {
        \(cases.indent(space: 4))
        }
        """
    )

    return chunks.joined(separator: "\n")

}

func buildEventEnumArgs(_ event: Event) -> String {
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
        var lines: [String] = []
        let args = buildEventEnumArgs(e)
        let enumBody = e.arguments.count == 0 ? "" : "(\(args))"
        if let docc = e.docc {
            lines.append(docc.comment)
        }

        lines.append("case \(e.name.lowerCamel.gravedIfNeeded)\(enumBody)")

        return lines.joined(separator: "\n")
    }.joined(separator: "\n\n")

    return """
        public enum Event: WlEventEnum {
        \(cases.indent(space: 4))

        \(buildDecodeFunction(events).indent(space: 4))
        }
        """
}

private func getArgDecodingExpr(_ arg: Argument) -> String {
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
            "connection.createProxy(type: \(interface.camel).self, version: version, id: r.readNewId())"
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

    let readerNeeded = cases.contains("r.read")
    let readerString =
        !readerNeeded ? "" : "var r = ArgumentParser(data: message.arguments, fdSource: fdSource)"
    return """
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            \(readerString)
            switch message.opcode {
        \(cases.indent(space: 4))
            default:
                fatalError("Unknown message")
            }
        }
        """
}
