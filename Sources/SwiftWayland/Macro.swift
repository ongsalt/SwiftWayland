@attached(member, names: arbitrary)
public macro WaylandProtocol(_ xml: String) =
        #externalMacro(module: "WaylandScanner", type: "WaylandProtocolMacro")
