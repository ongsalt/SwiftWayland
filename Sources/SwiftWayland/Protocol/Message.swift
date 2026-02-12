import Foundation

public struct Message {
    let objectId: ObjectId
    let opcode: UInt16
    let size: UInt16
    let arguments: Data

    init(objectId: ObjectId, opcode: UInt16, size: UInt16, arguments: Data) {
        self.objectId = objectId
        self.opcode = opcode
        self.size = size
        self.arguments = arguments
    }

    init(objectId: ObjectId, opcode: UInt16, buildArguments: (inout Data) -> Void) {
        self.objectId = objectId
        self.opcode = opcode

        var data = Data()
        buildArguments(&data)

        self.arguments = data
        self.size = Self.HEADER_SIZE + UInt16(arguments.count)
    }

    init(objectId: ObjectId, opcode: UInt16, contents: [WaylandData]) {
        self.objectId = objectId
        self.opcode = opcode
        
        var data = Data()
        for c in contents {
            c.encode(into: &data)
        }
    
        self.arguments = data
        self.size = Self.HEADER_SIZE + UInt16(arguments.count)
    }

    // var argumentSize: UInt16 {
    //     size - Message.HEADER_SIZE
    // }

    public static let HEADER_SIZE: UInt16 = 8

    init(readFrom socket: Socket) async throws {
        let header = try await socket.read(Int(Self.HEADER_SIZE))
        objectId = Self.readUInt32(header, offset: 0)
        opcode = Self.readUInt16(header, offset: 4)
        size = Self.readUInt16(header, offset: 6)

        arguments = try await socket.read(Int(size - Self.HEADER_SIZE))
    }

    private static func readUInt32(_ data: Data, offset: Int) -> UInt32 {
        var value: UInt32 = 0
        let end = offset + MemoryLayout<UInt32>.size
        guard end <= data.count else { return 0 }
        _ = withUnsafeMutableBytes(of: &value) { buffer in
            data.copyBytes(to: buffer, from: offset..<end)
        }
        return value
    }

    private static func readUInt16(_ data: Data, offset: Int) -> UInt16 {
        var value: UInt16 = 0
        let end = offset + MemoryLayout<UInt16>.size
        guard end <= data.count else { return 0 }
        _ = withUnsafeMutableBytes(of: &value) { buffer in
            data.copyBytes(to: buffer, from: offset..<end)
        }
        return value
    }
}

extension Data {
    init(_ message: Message) {
        self.init()
        append(u32: message.objectId)
        append(u16: message.opcode)
        append(u16: Message.HEADER_SIZE + UInt16(message.arguments.count))  // size
        append(message.arguments)
    }
}
