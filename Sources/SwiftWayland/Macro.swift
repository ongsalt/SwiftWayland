@attached(member, names: arbitrary)
public macro WaylandProtocol(trimPrefix: String? = nil, _ xml: String) =
        #externalMacro(module: "WaylandScannerMacro", type: "WaylandProtocolMacro")
