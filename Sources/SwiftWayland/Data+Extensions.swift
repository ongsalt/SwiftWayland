import Foundation

extension Data {
    mutating func append(u32: UInt32) {
        var c = u32
        self.append(Data(bytes: &c, count: MemoryLayout<UInt32>.size))  
    }

    mutating func append(u16: UInt16) {
        var c = u16
        self.append(Data(bytes: &c, count: MemoryLayout<UInt16>.size))  
    }
}