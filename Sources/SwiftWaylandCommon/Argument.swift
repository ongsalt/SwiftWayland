import Foundation

// TODO: naming is hard, this is outgoing only anyway
// user wont interact with this directly anyway
public enum Arg {
    case int(Int32)
    case uint(UInt32)
    case fixed(Double)
    case string(String)
    case array(Data)
    case fd(FileHandle)  // this need to live until we send it
    case `enum`(UInt32)
    case object(UInt32)
    case newId(UInt32)
    case nullableObject(UInt32?)
    case nullableString(String?)
}

private func put(_ string: String, into data: inout Data) {
    let utf8 = Array(string.utf8) + [0]  // null terminated
    var length = UInt32(utf8.count)
    withUnsafeBytes(of: &length) { data.append(contentsOf: $0) }
    data.append(contentsOf: utf8)
    let padding = (4 - (utf8.count % 4)) % 4
    if padding > 0 {
        data.append(contentsOf: [UInt8](repeating: 0, count: padding))
    }
}
