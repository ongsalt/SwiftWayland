import SwiftWaylandCommon

// - new_id -> return value
// - generate deint
// - wl_callback -> `@escaping () -> Void`

func remapName(_ name: String, prefixMap: [(from: String, to: String)]) -> String {
    for (from, to) in prefixMap {
        if name.hasPrefix(from + "_") {
            return to + "_" + String(name.dropFirst(from.count + 1))
        }
    }
    return name
}

public func transform(
    interface: Interface,
    trim transformName: Bool,
    protocolName: String,
    prefixMap: [(from: String, to: String)] = []
) -> ClassDeclaration {
    let destructors = interface.requests
        .filter { $0.arguments.count == 0 && $0.type == .destructor }
    
    let name = remapName(interface.name, prefixMap: prefixMap).camel

    let deinitDecl: DeinitDeclaration? =
        if name == "WlDisplay" {
            nil
        } else {
            DeinitDeclaration(destructors: destructors.map(\.name.lowerCamel))
        }

    return ClassDeclaration(
        name: name,
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
                        swiftType: arg.getSwiftType(isEvent: false, prefixMap: prefixMap),
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
                        value: entry.value,
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
                    let swiftType = arg.getSwiftType(isEvent: true, prefixMap: prefixMap)

                    return ArgumentDeclaration(
                        name: arg.name.lowerCamel,
                        swiftType: swiftType,  // for object/newId
                        arg: arg,
                    )
                },
                isDestructor: event.type == .destructor
            )
        }
    )
}

public func transform(
    protocol p: Protocol,
    trim transformName: Bool,
    prefixMap: [(from: String, to: String)] = []
) -> ProtocolDeclaration {
    ProtocolDeclaration(
        name: p.name.camel,
        copyright: p.copyright,
        description: p.description,
        protocol: p,
        classes: p.interfaces.map {
            transform(
                interface: $0, trim: transformName, protocolName: p.name.camel, prefixMap: prefixMap
            )
        }
    )
}

extension Argument {
    func getSwiftType(isEvent: Bool, prefixMap: [(from: String, to: String)] = []) -> String {
        switch self.type {
        case .string:
            return "String"
        case .array:
            return "UnsafeRawBufferPointer"
        case .fd:
            return "FileHandle"
        case .int:
            return "Int32"
        case .uint:
            return if let e = self.enum {
                parseEnumName(e)
            } else {
                "UInt32"
            }
        case .fixed:
            return "Double"

        // TODO: namespace?
        case .enum:
            fatalError("there should not be an enum here")
        case .object:
            // self.interface must not be nil if its an in parameter (shuold be fine tho)
            return self.interface.map { remapName($0, prefixMap: prefixMap).camel } ?? "any Proxy"
        case .newId:
            return remapName(self.interface!, prefixMap: prefixMap).camel  // dynamic newId in wl_registry.bind is excluded
        }
    }
}

func parseEnumName(_ name: String) -> String {
    name.split(separator: ".").map { String($0).camel }.joined(separator: ".")
}
