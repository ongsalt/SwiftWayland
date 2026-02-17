import Foundation

public struct Protocol: Codable {
    let name: String
    let copyright: String?
    let description: Description?
    let interfaces: [Interface]

    enum CodingKeys: String, CodingKey {
        case name, copyright, description
        case interfaces = "interface"
    }
}

public struct Interface: Codable {
    let name: String
    let version: UInt
    let description: Description?
    let enums: [Enum]
    let requests: [Request]
    let events: [Event]

    enum CodingKeys: String, CodingKey {
        case name, version, description
        case enums = "enum"
        case requests = "request"
        case events = "event"
    }
}

public struct Description: Codable {
    let summary: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case summary
        case value = ""
    }

    var docc: String {
        """
        \(self.summary.capitalized)

        \(self.value.trimmed)
        """
    }
}


public struct Enum: Codable {
    let name: String
    let entries: [EnumEntry]
    let description: Description?
    let bitfield: Bool = false
    let since: UInt?

    enum CodingKeys: String, CodingKey {
        case name, description, since
        case entries = "entry"
    }
}

public struct EnumEntry: Codable {
    let name: String
    let value: String  // this may be hex
    var intValue: UInt? {
        if value.starts(with: "0x") {
            UInt(value.trimmingPrefix("0x"), radix: 16)
        } else {
            UInt(value)
        }
    }
    let summary: String?
}

public struct Request: Codable {
    let name: String
    let `type`: RequestType?
    let description: Description?
    let since: UInt?

    let arguments: [Argument]

    enum CodingKeys: String, CodingKey {
        case name, type, description, since
        case arguments = "arg"
    }
}

enum RequestType: String, Codable {
    case destructor
}

public struct Argument: Codable {
    let name: String
    let `type`: Primitive
    let interface: String?
    let `enum`: String?
    let summary: String?
}

public enum Primitive: String, Codable {
    case int, uint, fixed, object, string, array, fd, `enum`
    case newId = "new_id"
}

public struct Event: Codable {
    let name: String
    let description: Description?
    let arguments: [Argument]
    let since: UInt?

    enum CodingKeys: String, CodingKey {
        case name, description, since
        case arguments = "arg"
    }
}
