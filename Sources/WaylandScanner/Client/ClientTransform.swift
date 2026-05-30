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

                for arg in request.arguments {
                    if arg.interface == "wl_callback" {
                        arguments.append(
                            ArgumentDeclaration(
                                name: arg.name.lowerCamel,
                                swiftType: CALLBACK_TYPE,
                                summary: arg.summary
                            )
                        )
                        callbacks.append(CallbackDeclaration(name: arg.name.lowerCamel))
                        continue
                    }

                    let baseType: String =
                        switch arg.type {
                        case .string: "String"
                        case .array: "Data"
                        case .fd: "FileHandle"
                        case .int: "Int32"
                        case .uint: "UInt32"
                        case .fixed: "Double"
                        case .enum: arg.enum!.camel
                        case .object: arg.interface!.camel
                        case .newId: arg.interface!.camel  // dynamic newId in wl_registry.bind is excluded
                        // TODO: bare proxy maybe
                        // case .newId: (arg.interface?.camel) ?? "any Proxy"
                        }
                    let swiftType = arg.nullable ? "\(baseType)?" : baseType

                    let decl = ArgumentDeclaration(
                        name: arg.name.lowerCamel,
                        swiftType: swiftType,
                        summary: arg.summary
                    )

                    if arg.type == .newId {
                        returns.append(decl)
                    } else {
                        arguments.append(decl)
                    }
                }

                // setFoo(foo:) → setFoo(_:): suppress external label when method == "set" + argName
                if arguments.count == 1 {
                    let methodLower = request.name.lowercased().replacingOccurrences(of: "_", with: "")
                    let argLower = arguments[0].name.lowercased()
                    if methodLower == "set" + argLower {
                        arguments[0].externalName = "_"
                    }
                }

                if !returns.isEmpty || !callbacks.isEmpty {
                    // which queue to create those object
                    arguments.append(
                        ArgumentDeclaration(
                            name: QUEUE_INNER_NAME,
                            externalName: "queue",
                            swiftType: "EventQueue?",
                            defaultValue: "nil",
                            summary: "queue to associated with created objects"
                        ))
                }

                let messageArguments = request.arguments.map { arg in
                    WaylandArgumentDeclaration(
                        name: arg.name.lowerCamel,
                        waylandType: arg.type,
                        swiftType: "__ignored",
                        nullable: arg.nullable
                    )
                }

                return MethodDeclaration(
                    name: request.name.lowerCamel,
                    requestName: request.name,
                    requestId: UInt32(index),
                    consuming: request.type == .destructor,
                    since: request.since,
                    arguments: arguments,
                    returns: returns,
                    callbacks: callbacks,
                    messageArguments: messageArguments,
                    description: request.description,
                    throws: nil,
                )
            },
        // deinit: interface.requests
        //     .first { $0.arguments.count == 0 && $0.type == .destructor }
        //     .map { DeinitDeclaration(selectedMethod: $0.name.lowerCamel) },
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
        events:
            interface.events.map { event in
                EventDeclaration(
                    name: event.name.lowerCamel,
                    description: event.description,
                    arguments: event.arguments.map { arg in
                        let baseType: String =
                            switch arg.type {
                            case .string: "String"
                            case .array: "Data"
                            case .fd: "FileHandle"
                            case .int: "Int32"
                            case .uint: "UInt32"
                            case .fixed: "Double"
                            case .enum: arg.enum!.camel
                            case .object: arg.interface?.camel ?? "any Proxy"
                            case .newId: arg.interface!.camel
                            }
                        let swiftType = arg.nullable ? "\(baseType)?" : baseType

                        return WaylandArgumentDeclaration(
                            name: arg.name.lowerCamel,
                            waylandType: arg.type,
                            swiftType: swiftType,
                            nullable: arg.nullable
                        )
                    },
                    isDestructor: event.type == .destructor
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
        classes: p.interfaces.map { transform(interface: $0, trim: transformName, protocolName: p.name.camel) }
    )
}
