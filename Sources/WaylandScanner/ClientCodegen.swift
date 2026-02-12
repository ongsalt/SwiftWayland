import SwiftSyntax

func buildInterfaceClass(interface: Interface) -> String {
    return """
        public final class \(interface.name.camel): WlProxyBase, WlProxy {
            var onEvent: (Event) -> Void = { _ in }
        \(buildMethods(interface.requests).indent(space: 4))

        \(buildEnums(interface.enums).indent(space: 4))

        \(buildEventEnum(events: interface.events).indent(space: 4))
        }
        """
}

func buildMethods(_ requests: [Request]) -> String {
    // TODO: transform

    requests.enumerated().map { (reqId, r) in
        let (ret, args) = buildArgs(r.arguments)
        let retString = ret != nil ? "-> \(ret!) " : ""

        return """
            public func \(r.name.lowerCamel)(\(args)) \(retString){
            \(reqId)
            }
            """
    }.joined(separator: "\n\n")
}

func buildEnums(_ enums: [Enum]) -> String {
    "[enum hereeee]"
}

func buildArgs(_ args: [Argument]) -> (returnType: String?, args: String) {
    let returnType = args.first { $0.type == .newId }.map { getArgType($0) }
    let newIdCount = args.count { $0.type == .newId }
    if newIdCount > 1 {
        fatalError("new_id > 1 is not support")
    }
    let list =
        args
        .filter { $0.type != .newId }
        .map { a in
            "\(a.name.lowerCamel): \(getArgType(a))"
        }
        .joined(separator: ", ")

    return (returnType, list)
}

func getArgType(_ arg: Argument) -> String {
    switch arg.type {
    case .int: "Int32"
    case .uint: "UInt32"
    case .fixed: "Double"
    case .string: "String"

    case .fd: "FileHandle"

    case .enum: arg.enum.expect("Invalid xml: enum must not be nil").camel  // TODO: show context or smth
    case .object: arg.interface.expect("Invalid xml: interface must not be nil").camel

    case .newId: fatalError("Impossible (newId)")
    case .array: fatalError("Not implemented (array)")
    }
}

func buildEventEnum(events: [Event]) -> String {
    let cases = events.map { e in
        let args = buildArgs(e.arguments).args
        let enumBody = e.arguments.count == 0 ? "" : "(\(args))"

        return "case \(e.name.lowerCamel)\(enumBody)"
    }.joined(separator: "\n")

    return """
        public enum Event: WlEventEnum {
        \(cases.indent(space: 4))

        \(buildDecodeFunction(events).indent(space: 4))
        }
        """
}

func getArgDecoding(_ arg: Argument) -> String {
    switch arg.type {
    case .int: "readInt"
    case .uint: "readUInt"
    case .fixed: "readFixed"
    case .string: "readString"

    case .fd: fatalError("fd event param is not implemented")

    case .enum: arg.enum.expect("Invalid xml: enum must not be nil").camel  // TODO: show context or smth
    case .object: arg.interface.expect("Invalid xml: interface must not be nil").camel

    case .newId: fatalError("Impossible (newId)")
    case .array: fatalError("Not implemented (array)")
    }
}

func buildDecodeFunction(_ events: [Event]) -> String {
    func buildCallingArgs(_ args: [Argument]) -> String {
        if args.contains(where: { $0.type == .newId }) {
            fatalError("new_id in event is not support")
        }

        return args.map { a in
            "\(a.name.lowerCamel): r.\(getArgDecoding(a))()"
        }.joined(separator: ", ")
    }

    let cases = events.enumerated().map { (index, e) in
        let args = buildCallingArgs(e.arguments)
        let enumBody = e.arguments.count == 0 ? "" : "(\(args))"

        return """
            case \(index):
                Self.\(e.name.lowerCamel)\(enumBody)
            """
    }.joined(separator: "\n")

    return """
        static func decode(message: Message) -> Self {
            let r = WLReader(data: message.arguments)
            return switch message.opcode {
        \(cases.indent(space: 4))
            default:
                fatalError("Unknown message")
            }
        }
        """
}
