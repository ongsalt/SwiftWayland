import SwiftWaylandCommon

// - new_id -> return value
// - generate deint
// - wl_callback -> `@escaping () -> Void`

// func transform(p: Protocol) -> ProtocolDeclaration {
// TODO: license and other protocol level stuff
// }

public func transform(
    interface: Interface,
    trim transformName: Bool,
    protocolName: String
) -> ClassDeclaration {
    let destructors = interface.requests
        .filter { $0.arguments.count == 0 && $0.type == .destructor }
    let deinitDecl: DeinitDeclaration? =
        if destructors.isEmpty { nil } else {
            DeinitDeclaration(destructors: destructors.map(\.name.lowerCamel))
        }

    return ClassDeclaration(
        name: interface.name.camel,
        interface: interface,
        protocolName: protocolName,
        description: interface.description,
        methods: interface.requests.enumerated()
            .filter { !(interface.name == "wl_registry" && $1.name == "bind") }
            .map { (index, request) in
                var arguments: [ArgumentDeclaration] = []
                var returns: [ArgumentDeclaration] = []
                var callbacks: [CallbackDeclaration] = []

                for (index, arg) in request.arguments.enumerated() {
                    if arg.interface == "wl_callback" {
                        arguments.append(
                            ArgumentDeclaration(
                                name: arg.name.lowerCamel,
                                swiftType: CALLBACK_TYPE,
                                arg: arg,
                            )
                        )
                        callbacks.append(CallbackDeclaration(name: arg.name.lowerCamel))
                        continue
                    }

                    var externalName: String? = nil
                    // setMode(mode:) -> setMode(_:)
                    if index == 0 {
                        let parts = request.name.split(separator: "_")
                        if parts.count >= 2 && parts[0] == "set"
                            && parts[1...].joined(separator: "_") == arg.name
                        {
                            externalName = "_"
                        }
                    }

                    let decl = ArgumentDeclaration(
                        name: arg.name.lowerCamel,
                        externalName: externalName,
                        swiftType: arg.getSwiftType(isEvent: false),
                        arg: arg,
                    )

                    if arg.type == .newId {
                        returns.append(decl)
                    } else {
                        arguments.append(decl)
                    }
                }

                let messageArguments = request.arguments.map { arg in
                    ArgumentDeclaration(
                        name: arg.name.lowerCamel,
                        swiftType: "__ignored",
                        arg: arg,
                    )
                }

                return MethodDeclaration(
                    name: request.name.lowerCamel,
                    requestName: request.name,
                    requestId: UInt32(index),
                    isDestructor: request.type == .destructor,
                    since: request.since,
                    arguments: arguments,
                    returns: returns,
                    callbacks: callbacks,
                    messageArguments: messageArguments,
                    description: request.description,
                    throws: nil,
                )
            },
        deinit: deinitDecl,
        enums: interface.enums.map { e in
            EnumDeclaration(
                name: e.name.camel,
                description: e.description,
                bitfield: e.bitfield,
                since: e.since,
                cases: e.entries.map { entry in
                    EnumCaseDeclaration(
                        name: entry.name.lowerCamel,
                        value: entry.intValue,
                        summary: entry.summary
                    )
                },
            )
        },
        // interface.name == "wl_display" ? []
        events: interface.events.map { event in
            EventDeclaration(
                name: event.name.lowerCamel,
                description: event.description,
                arguments: event.arguments.map { arg in
                    let swiftType = arg.getSwiftType(isEvent: true)

                    return ArgumentDeclaration(
                        name: arg.name.lowerCamel,
                        swiftType: swiftType,  // for object/newId
                        arg: arg,
                    )
                }
            )
        }
    )
}

public func transform(
    protocol p: Protocol,
    trim transformName: Bool
) -> ProtocolDeclaration {
    ProtocolDeclaration(
        name: p.name.camel,
        copyright: p.copyright,
        description: p.description,
        protocol: p,
        classes: p.interfaces.map {
            transform(interface: $0, trim: transformName, protocolName: p.name.camel)
        }
    )
}

extension Argument {
    func getSwiftType(isEvent: Bool) -> String {
        switch self.type {
        case .string:
            return "String"
        case .array:
            return "Data"
        case .fd:
            return "FileHandle"
        case .int:
            return "Int32"
        case .uint:
            if let e = self.enum {
                return parseEnumName(e)
            }
            return "UInt32"
        case .fixed:
            return "Double"

        // TODO: namespace?
        case .enum:
            fatalError("there should not be an enum here")
        case .object:
            if isEvent {
                return self.interface?.camel ?? "any Proxy"
            } else {
                return self.interface!.camel
            }
        case .newId:
            return self.interface!.camel  // dynamic newId in wl_registry.bind is excluded
        }

    }
}

func parseEnumName(_ name: String) -> String {
    name.split(separator: ".").map { String($0).camel }.joined(separator: ".")
}
