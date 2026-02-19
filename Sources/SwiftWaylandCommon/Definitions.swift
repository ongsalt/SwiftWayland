import Foundation

public struct Protocol: Codable {
    public let name: String
    public let copyright: String?
    public let description: Description?
    public let interfaces: [Interface]

    enum CodingKeys: String, CodingKey {
        case name, copyright, description
        case interfaces = "interface"
    }
}

public struct Interface: Codable {
    public let name: String
    public let version: UInt32
    public let description: Description?
    public let enums: [Enum]
    public let requests: [Message]
    public let events: [Event]

    enum CodingKeys: String, CodingKey {
        case name, version, description
        case enums = "enum"
        case requests = "request"
        case events = "event"
    }
}

public struct Description: Codable {
    public let summary: String
    public let value: String

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

public struct Enum: Codable {
    public let name: String
    public let entries: [EnumEntry]
    public let description: Description?
    public let bitfield: Bool = false
    public let since: UInt32?

    enum CodingKeys: String, CodingKey {
        case name, description, since
        case entries = "entry"
    }
}

public struct EnumEntry: Codable {
    public let name: String
    public let value: UInt32  // this may be hex
    public var since: UInt32?
    public let summary: String?
    public let description: Description?

    // TODO: remove this
    public var intValue: UInt32 {
        value
    }
}

public struct Message: Codable {
    public let name: String
    public let `type`: RequestType?
    public let arguments: [Argument]
    public let description: Description?
    public let since: UInt32?

    enum CodingKeys: String, CodingKey {
        case name, type, description, since
        case arguments = "arg"
    }
}

public enum RequestType: String, Codable {
    case destructor
}

public struct Argument: Codable {
    public let name: String
    public let `type`: Primitive
    public let interface: String?
    public let `enum`: String?
    public let summary: String?
    public let description: Description?

    // TODO: codegen: nullable
    public let nullable: Bool = false

    enum CodingKeys: String, CodingKey {
        case name, type, interface, `enum`, summary, description
        case nullable = "allow_null"
    }
}

public enum Primitive: String, Codable {
    case int, uint, fixed, object, string, array, fd, `enum`
    case newId = "new_id"
}

// Todo: remove this
public typealias Event = Message
public typealias Request = Message
