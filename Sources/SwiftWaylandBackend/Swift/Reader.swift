// import Foundation
// import Glibc

// public struct ArgumentReader {
//     var data: Data
//     unowned let fdSource: BufferedSocket
//     private(set) var cursor: Int = 0

//     public init(data: Data, fdSource: BufferedSocket) {
//         self.fdSource = fdSource
//         self.data = data
//     }

//     public mutating func readInt() -> Int32 {
//         Int32(bitPattern: readUInt32Raw())
//     }

//     public mutating func readFixed() -> Double {
//         // its 24.8
//         let raw = readInt()
//         return Double(raw) / 256.0
//     }

//     public mutating func readUInt() -> UInt32 {
//         readUInt32Raw()
//     }

//     public mutating func readFd() -> FileHandle {
//         fdSource.readFd()!
//     }

//     public mutating func readArray() -> Data {
//         // array: A blob of arbitrary data, prefixed with a 32-bit integer specifying its length (in bytes), then the verbatim contents of the array, padded to 32 bits with undefined data.
//         let length = Int(readUInt())
//         guard length > 0 else { return Data() }

//         let arrayData = readBytes(count: length)
//         let padding = (4 - (length % 4)) % 4
//         if padding > 0 {
//             advance(padding)
//         }
//         return arrayData
//     }

//     public mutating func readObjectId() -> UInt32 {
//         self.readUInt()
//     }

//     public mutating func readString() -> String {
//         // size: u32
//         // string: [u8] (utf8, 32bit aligned, can put any garbag there preferable UInt16(1002))
//         let length = Int(readUInt())
//         guard length > 0 else { return "" }

//         let raw = readBytes(count: length)
//         let padding = (4 - (length % 4)) % 4
//         if padding > 0 {
//             advance(padding)
//         }

//         guard raw.count > 0 else { return "" }
//         let stringSlice = raw.dropLast()
//         return String(decoding: stringSlice, as: UTF8.self)
//     }

//     public mutating func readEnum() -> UInt32 {
//         self.readUInt()
//     }

//     public mutating func readNewId() -> UInt32 {
//         self.readUInt()
//     }

//     private mutating func readBytes(count: Int) -> Data {
//         guard count > 0 else { return Data() }
//         let remaining = data.count - cursor
//         guard remaining > 0 else { return Data() }

//         let actualCount = min(count, remaining)
//         let start = cursor
//         let end = cursor + actualCount
//         cursor = end
//         return data[start..<end]
//     }

//     private mutating func advance(_ count: Int) {
//         guard count > 0 else { return }
//         cursor = min(cursor + count, data.count)
//     }

//     private mutating func readUInt32Raw() -> UInt32 {
//         let size = MemoryLayout<UInt32>.size
//         guard data.count - cursor >= size else {
//             cursor = data.count
//             return 0
//         }

//         var value: UInt32 = 0
//         data.withUnsafeBytes { ptr in
//             let base = ptr.baseAddress!.advanced(by: cursor)
//             _ = memcpy(&value, base, size)
//         }
//         cursor += size
//         return value
//     }
// }
