import Foundation
import XMLCoder

public struct Protocol: Codable {
    let name: String
    let copyright: String?
    let interfaces: [Interface]

    enum CodingKeys: String, CodingKey {
        case name
        case copyright
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

struct Description: Codable {
    let summary: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case summary
        case value = ""
    }
}

struct Enum: Codable {
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

struct EnumEntry: Codable {
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

struct Request: Codable {
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

struct Argument: Codable {
    let name: String
    let `type`: Primitive
    let interface: String?
    let `enum`: String?
    let summary: String?
}

// https://wayland-book.com/protocol-design/wire-protocol.html
enum Primitive: String, Codable {
    case int, uint, fixed, object, string, array, fd, `enum`
    case newId = "new_id"
}

struct Event: Codable {
    let name: String
    let description: Description?
    let arguments: [Argument]
    let since: UInt?

    enum CodingKeys: String, CodingKey {
        case name, description, since
        case arguments = "arg"
    }
}
