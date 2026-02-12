import Foundation
import Glibc

public class WLReader {
    var data: Data
    unowned let connection: Connection
    private(set) var cursor: Int = 0

    public init(data: Data, connection: Connection) {
        self.connection = connection
        self.data = data
    }

    public func readInt() -> Int32 {
        Int32(bitPattern: readUInt32Raw())
    }

    public func readFixed() -> Double {
        // its 24.8
        let raw = readInt()
        return Double(raw) / 256.0
    }

    public func readUInt() -> UInt32 {
        readUInt32Raw()
    }

    public func readFd() -> FileHandle {
        // FileHandle()
        print("WlReader: readFd is not implemented")

        fatalError("WlReader: readFd is not implemented")
    }

    public func readArray() -> Data {
        // array: A blob of arbitrary data, prefixed with a 32-bit integer specifying its length (in bytes), then the verbatim contents of the array, padded to 32 bits with undefined data.
        let length = Int(readUInt())
        guard length > 0 else { return Data() }

        let arrayData = readBytes(count: length)
        let padding = (4 - (length % 4)) % 4
        if padding > 0 {
            advance(padding)
        }
        return arrayData
    }

    public func readObjectId() -> UInt32 {
        self.readUInt()
    }

    public func readString() -> String {
        // size: u32
        // string: [u8] (utf8, 32bit aligned, can put any garbag there preferable UInt16(1002))
        let length = Int(readUInt())
        guard length > 0 else { return "" }

        let raw = readBytes(count: length)
        let padding = (4 - (length % 4)) % 4
        if padding > 0 {
            advance(padding)
        }

        guard raw.count > 0 else { return "" }
        let stringSlice = raw.dropLast()
        return String(decoding: stringSlice, as: UTF8.self)
    }

    public func readEnum() -> UInt32 {
        self.readUInt()
    }

    public func readNewId() -> UInt32 {
        self.readUInt()
    }

    private func readBytes(count: Int) -> Data {
        guard count > 0 else { return Data() }
        let remaining = data.count - cursor
        guard remaining > 0 else { return Data() }

        let actualCount = min(count, remaining)
        let start = cursor
        let end = cursor + actualCount
        cursor = end
        return data[start..<end]
    }

    private func advance(_ count: Int) {
        guard count > 0 else { return }
        cursor = min(cursor + count, data.count)
    }

    private func readUInt32Raw() -> UInt32 {
        let size = MemoryLayout<UInt32>.size
        guard data.count - cursor >= size else {
            cursor = data.count
            return 0
        }

        var value: UInt32 = 0
        data.withUnsafeBytes { ptr in
            let base = ptr.baseAddress!.advanced(by: cursor)
            _ = memcpy(&value, base, size)
        }
        cursor += size
        return value
    }
}
