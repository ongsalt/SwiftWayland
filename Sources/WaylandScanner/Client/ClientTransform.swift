// - new_id -> return value
// - generate deint
// - wl_callback -> `@escaping () -> Void`

func transform(interface: Interface) -> ClassDeclaration {
    return ClassDeclaration(
        name: interface.name.camel,
        interfaceName: interface.name,
        description: interface.description,
        methods: interface.requests.enumerated().map { (index, request) in
            let mapped: [ArgumentDeclaration] = request.arguments.map { arg in
                let t: ArgumentType =
                    switch arg.type {
                    case .string: .string
                    case .array: .data
                    case .fd: .fd
                    case .int: .i32
                    case .uint: .u32
                    case .fixed: .fixed
                    case .enum: .enum(swiftName: arg.enum!.camel)
                    case .object: .proxy(swiftName: arg.interface!.camel)
                    case .newId where arg.interface == "wl_callback": .callback
                    case .newId: .newProxy(swiftName: arg.interface?.camel)
                    }

                return ArgumentDeclaration(
                    name: arg.name.lowerCamel,
                    // externalName: arg.name.lowerCamel,
                    type: t
                )
            }

            let isRet: (ArgumentDeclaration) -> Bool = { arg in
                if case .newProxy(let swiftName) = arg.type {
                    return swiftName != "WlCallback"
                }
                return false
            }

            return MethodDeclaration(
                name: request.name.lowerCamel,
                requestName: request.name,
                requestId: UInt(index),
                consuming: request.type == .destructor,
                since: request.since,
                arguments: mapped.filter { !isRet($0) },
                returns: mapped.filter(isRet),
                messageArguments: mapped,
                description: request.description,
                throws: nil
            )
        },
        deinit: interface.requests
            .first { $0.arguments.count == 0 && $0.type == .destructor }
            .map { DeinitDeclaration(selectedMethod: $0.name.lowerCamel) },
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
        events: interface.events.map { event in
            EventDeclaration(
                name: event.name.lowerCamel,
                description: event.description,
                arguments: event.arguments.map { arg in
                    let t: ArgumentType =
                        switch arg.type {
                        case .string: .string
                        case .array: .data
                        case .fd: .fd
                        case .int: .i32
                        case .uint: .u32
                        case .fixed: .fixed
                        case .enum: .enum(swiftName: arg.enum!.camel)
                        case .object: .proxy(swiftName: arg.interface?.camel) // nullable when its wl_display.error
                        case .newId where arg.interface != nil: .newProxy(swiftName: arg.interface!.camel)
                        // TODO: what if its a callback???
                        default: fatalError("Dynamic new_id found in event argument")
                        }

                    return ArgumentDeclaration(
                        name: arg.name.lowerCamel,
                        externalName: arg.name,
                        type: t,
                    )
                }
            )
        }
    )
}
