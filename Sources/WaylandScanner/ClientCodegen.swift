import SwiftSyntax

func buildInterfaceClass(interface: Interface) -> String {
    return """
        public final class \(interface.name.camel): WlProxyBase, WlProxy {
        \(buildEventEnum(events: interface.events).indent(space: 4))
        }
        """
}

func buildEnum(enumeration: Enum) -> String {
    ""
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
        "case \(e.name.lowerCamel)(\(buildArgs(e.arguments).args))"
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
    case .int: "readUInt"
    case .uint: "readUInt32"
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
    func buildArgs(_ args: [Argument]) -> String {
        if args.contains(where: { $0.type == .newId }) {
            fatalError("new_id in event is not support")
        }

        return args.map { a in
            "\(a.name.lowerCamel): r.\(getArgDecoding(a))()"
        }.joined(separator: ", ")
    }

    let cases = events.enumerated().map { (index, e) in
        """
        case \(index):
            Self.\(e.name.lowerCamel)()
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
