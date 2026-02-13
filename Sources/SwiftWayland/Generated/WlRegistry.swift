import Foundation

public final class WlRegistry: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_registry"
    public var onEvent: (Event) -> Void = { _ in }

    // request `bind` can not (yet) be generated 
    // [WaylandScanner.Argument(name: "name", type: WaylandScanner.Primitive.uint, interface: nil, enum: nil, summary: Optional("unique numeric name of the object")), WaylandScanner.Argument(name: "id", type: WaylandScanner.Primitive.newId, interface: nil, enum: nil, summary: Optional("bounded object"))]
    
    public enum Event: WlEventEnum {
        case global(name: UInt32, interface: String, version: UInt32)
        case globalRemove(name: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.global(name: r.readUInt(), interface: r.readString(), version: r.readUInt())
            case 1:
                return Self.globalRemove(name: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
