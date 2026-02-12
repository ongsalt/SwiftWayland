import Foundation

// TODO: fd is on msg_conrol tho
enum WaylandPrimitive {
    case int, uint, fixed, object, string, array, fd, `enum`, newId
}

public typealias ObjectId = UInt32
public typealias NewId = UInt32
public typealias EnumValue = UInt32

// use for encoding
public enum WaylandData {
    case int(Int32)
    case uint(UInt32)
    case fixed(Double)
    case object(any WlProxy)
    case string(String)
    case array(Data)
    case fd(FileHandle) 
    case `enum`(any WlEnum)
    case newId(ObjectId)

    func encode(into data: inout Data) {
        switch self {
        case .int(let value):
            var v = value
            withUnsafeBytes(of: &v) { data.append(contentsOf: $0) }
            
        case .uint(let value):
            var v = value
            withUnsafeBytes(of: &v) { data.append(contentsOf: $0) }
            
        case .fixed(let value):
            // 24.8 fixed point format
            var v = Int32(value * 256.0)
            withUnsafeBytes(of: &v) { data.append(contentsOf: $0) }
            
        case .object(let object):
            var v = object.id
            withUnsafeBytes(of: &v) { data.append(contentsOf: $0) }
            
        case .string(let string):
            // length (including null terminator) + utf8 bytes + null + padding to 32-bit
            let utf8 = Array(string.utf8) + [0]  // null terminated
            var length = UInt32(utf8.count)
            withUnsafeBytes(of: &length) { data.append(contentsOf: $0) }
            data.append(contentsOf: utf8)
            let padding = (4 - (utf8.count % 4)) % 4
            if padding > 0 {
                data.append(contentsOf: [UInt8](repeating: 0, count: padding))
            }
            
        case .array(let arrayData):
            // length + raw bytes + padding to 32-bit
            var length = UInt32(arrayData.count)
            withUnsafeBytes(of: &length) { data.append(contentsOf: $0) }
            data.append(arrayData)
            let padding = (4 - (arrayData.count % 4)) % 4
            if padding > 0 {
                data.append(contentsOf: [UInt8](repeating: 0, count: padding))
            }
            
        case .fd:
            // File descriptors are passed via ancillary data (msg_control), not in main data
            break
            
        case .enum(let enumValue):
            // TODO: some is bitfield
            if let rawValue = enumValue as? any RawRepresentable {
                var v = (rawValue.rawValue as? UInt32) ?? 0
                withUnsafeBytes(of: &v) { data.append(contentsOf: $0) }
            }
            
        case .newId(let objectId):
            var v = objectId
            withUnsafeBytes(of: &v) { data.append(contentsOf: $0) }
        }
    }
}
