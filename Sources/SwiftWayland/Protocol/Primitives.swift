import Foundation

class WLDecoder {

}

// TODO: fd is on msg_conrol tho
enum WaylandPrimitive {
    case int, uint, fixed, object, string, array, fd, `enum`, newId

    var decoder: WLDecoder {
        WLDecoder()
    }
}

public typealias ObjectId = UInt32
public typealias NewId = UInt32
public typealias EnumValue = UInt32
