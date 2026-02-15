// - new_id -> return value
// - generate deint
// - wl_callback -> `@escaping () -> Void`

func transform(interface: Interface) -> ClassDeclaration {
    return ClassDeclaration(
        name: interface.name.camel,
        interfaceName: interface.name,
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

                    let swiftType: String =
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
                        // case .newId: (arg.interface?.camel) ?? "any WlProxy"
                        }

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
                        swiftType: "__ignored"
                    )
                }

                return MethodDeclaration(
                    name: request.name.lowerCamel,
                    requestName: request.name,
                    requestId: UInt(index),
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
                        value: entry.value,
                        summary: entry.summary
                    )
                },
            )
        },
        events: interface.name == "wl_display"
            ? []
            : interface.events.map { event in
                EventDeclaration(
                    name: event.name.lowerCamel,
                    description: event.description,
                    arguments: event.arguments.map { arg in
                        let swiftType: String =
                            switch arg.type {
                            case .string: "String"
                            case .array: "Data"
                            case .fd: "FileHandle"
                            case .int: "Int32"
                            case .uint: "UInt32"
                            case .fixed: "Double"
                            case .enum: arg.enum!.camel
                            // TODO: fix this
                            case .object: arg.interface?.camel ?? "any WlProxy"  // nullable when its wl_display.error
                            case .newId: arg.interface!.camel
                            }

                        return WaylandArgumentDeclaration(
                            name: arg.name.lowerCamel,
                            waylandType: arg.type,
                            swiftType: swiftType,  // for object/newId
                        )
                    }
                )
            }
    )
}
