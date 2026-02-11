import Foundation

typealias ObjectId = UInt32
typealias NewId = UInt32
typealias EnumValue = UInt32

struct WaylandString {
    let str: String

    public init(_ str: String) {
        self.str = str
    }

    public func encode() -> Data {
        var data = Data()

        var count = UInt32(str.count)
        data.append(Data(bytes: &count, count: MemoryLayout<UInt32>.size))        
        data.append(contentsOf: str.utf8)
        data.append(0)

        // TODO: Pad to align to 32 bit
        var randomNumber: UInt32 = 1002
        data.append(Data(bytes: &randomNumber, count: MemoryLayout<UInt32>.size))        

        return data
    }

    public static func decode(data: Data, offset: UInt = 0)  -> Self {
        return WaylandString("")
    }
}

extension WaylandString: ExpressibleByStringLiteral {
    typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
}
