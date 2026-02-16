import Foundation

public struct Message {
    public let objectId: ObjectId
    public let opcode: UInt16
    public let size: UInt16
    public let arguments: Data
    public let fds: [FileHandle]

    public init(
        objectId: ObjectId, opcode: UInt16, size: UInt16, arguments: Data, fds: [FileHandle] = []
    ) {
        self.objectId = objectId
        self.opcode = opcode
        self.size = size
        self.arguments = arguments
        self.fds = fds
    }

    public init(objectId: ObjectId, opcode: UInt16, contents: [WaylandData]) {
        self.objectId = objectId
        self.opcode = opcode

        var fds: [FileHandle] = []
        var data = Data()
        for c in contents {
            c.encode(into: &data, fds: &fds)
        }

        self.arguments = data
        self.size = Self.HEADER_SIZE + UInt16(arguments.count)
        self.fds = fds
    }

    // var argumentSize: UInt16 {
    //     size - Message.HEADER_SIZE
    // }

    public static let HEADER_SIZE: UInt16 = 8

    // init(readAsync socket: Socket) async throws {
    //     let header = try await socket.read(Int(Self.HEADER_SIZE))
    //     objectId = Self.readUInt32(header, offset: 0)
    //     opcode = Self.readUInt16(header, offset: 4)
    //     size = Self.readUInt16(header, offset: 6)

    //     arguments = try await socket.read(Int(size - Self.HEADER_SIZE))
    // }

    init(readBlocking socket: BufferedSocket) throws(BufferedSocketError) {
        guard socket.data.count >= Self.HEADER_SIZE else {
            throw .notEnoughBytes(requested: Int(Self.HEADER_SIZE), left: socket.data.count)
        }

        let header = try socket.read(Self.HEADER_SIZE, consume: false).get()
        objectId = Self.readUInt32(header, offset: 0)
        opcode = Self.readUInt16(header, offset: 4)
        size = Self.readUInt16(header, offset: 6)

        guard socket.data.count >= size else {
            throw .notEnoughBytes(requested: Int(size), left: socket.data.count)
        }

        _ = try socket.read(Self.HEADER_SIZE, consume: true).get()
        arguments = try socket.read(Int(size - Self.HEADER_SIZE)).get()

        self.fds = []  // This must be request later in the event parsing
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
        var objectId = message.objectId
        self.append(Data(bytes: &objectId, count: MemoryLayout<UInt32>.size))
        var opCode = message.opcode
        self.append(Data(bytes: &opCode, count: MemoryLayout<UInt16>.size))
        var size = Message.HEADER_SIZE + UInt16(message.arguments.count)
        self.append(Data(bytes: &size, count: MemoryLayout<UInt16>.size))
        append(message.arguments)
    }
}

extension Message: CustomStringConvertible {
    public var description: String {
        "Message(object: \(objectId), opcode: \(opcode), \(arguments as NSData)) "
    }
}
