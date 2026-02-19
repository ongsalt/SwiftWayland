import Foundation

public struct Protocol: Codable, Sendable {
    public let name: String
    public let copyright: String?
    public let description: Description?
    public let interfaces: [Interface]

    public init(
        name: String, copyright: String? = nil, description: Description? = nil,
        interfaces: [Interface]
    ) {
        self.name = name
        self.copyright = copyright
        self.description = description
        self.interfaces = interfaces
    }

    enum CodingKeys: String, CodingKey {
        case name, copyright, description
        case interfaces = "interface"
    }
}

public struct Interface: Codable, Sendable {
    public let name: String
    public let version: UInt32
    public let description: Description?
    public let enums: [Enum]
    public let requests: [Message]
    public let events: [Event]

    public init(
        name: String, version: UInt32, description: Description? = nil, enums: [Enum],
        requests: [Message], events: [Event]
    ) {
        self.name = name
        self.version = version
        self.description = description
        self.enums = enums
        self.requests = requests
        self.events = events
    }

    enum CodingKeys: String, CodingKey {
        case name, version, description
        case enums = "enum"
        case requests = "request"
        case events = "event"
    }
}

public struct Description: Codable, Sendable {
    public let summary: String
    public let value: String

    public init(summary: String, value: String) {
        self.summary = summary
        self.value = value
    }

    enum CodingKeys: String, CodingKey {
        case summary
        case value = ""
    }

    public var docc: String {
        """
        \(self.summary.capitalized)

        \(self.value.trimmed)
        """
    }
}

public struct Enum: Codable, Sendable {
    public let name: String
    public let entries: [EnumEntry]
    public let description: Description?
    public let bitfield: Bool = false
    public let since: UInt32?

    public init(
        name: String, entries: [EnumEntry], description: Description? = nil, since: UInt32? = nil
    ) {
        self.name = name
        self.entries = entries
        self.description = description
        self.since = since
    }

    enum CodingKeys: String, CodingKey {
        case name, description, since
        case entries = "entry"
    }
}

public struct EnumEntry: Codable, Sendable {
    public let name: String
    public let value: UInt32  // this may be hex
    public var since: UInt32?
    public let summary: String?
    public let description: Description?

    public init(
        name: String, value: UInt32, since: UInt32? = nil, summary: String? = nil,
        description: Description? = nil
    ) {
        self.name = name
        self.value = value
        self.since = since
        self.summary = summary
        self.description = description
    }

    // TODO: remove this
    public var intValue: UInt32 {
        value
    }
}

public struct Message: Codable, Sendable {
    public let name: String
    public let `type`: RequestType?
    public let arguments: [Argument]
    public let description: Description?
    public let since: UInt32?

    public init(
        name: String, `type`: RequestType? = nil, arguments: [Argument],
        description: Description? = nil, since: UInt32? = nil
    ) {
        self.name = name
        self.`type` = `type`
        self.arguments = arguments
        self.description = description
        self.since = since
    }

    enum CodingKeys: String, CodingKey {
        case name, type, description, since
        case arguments = "arg"
    }
}

public enum RequestType: String, Codable, Sendable {
    case destructor
}

public struct Argument: Codable, Sendable {
    public let name: String
    public let `type`: Primitive
    public let interface: String?
    public let `enum`: String?
    public let summary: String?
    public let description: Description?

    public init(
        name: String, `type`: Primitive, interface: String? = nil, `enum`: String? = nil,
        summary: String? = nil, description: Description? = nil
    ) {
        self.name = name
        self.`type` = `type`
        self.interface = interface
        self.`enum` = `enum`
        self.summary = summary
        self.description = description
    }

    // TODO: codegen: nullable
    public let nullable: Bool = false

    enum CodingKeys: String, CodingKey {
        case name, type, interface, `enum`, summary, description
        case nullable = "allow_null"
    }
}

public enum Primitive: String, Codable, Sendable {
    case int, uint, fixed, object, string, array, fd, `enum`
    case newId = "new_id"
}

// Todo: remove this
public typealias Event = Message
public typealias Request = Message
