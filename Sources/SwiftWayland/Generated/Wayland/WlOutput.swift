import Foundation

public final class WlOutput: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_output"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func release() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.release()
    }
    
    public enum Subpixel: UInt32, WlEnum {
        case unknown = 0
        case `none` = 1
        case horizontalRgb = 2
        case horizontalBgr = 3
        case verticalRgb = 4
        case verticalBgr = 5
    }
    
    public enum Transform: UInt32, WlEnum {
        case normal = 0
        case `90` = 1
        case `180` = 2
        case `270` = 3
        case flipped = 4
        case flipped90 = 5
        case flipped180 = 6
        case flipped270 = 7
    }
    
    public enum Mode: UInt32, WlEnum {
        case current = 0x1
        case preferred = 0x2
    }
    
    public enum Event: WlEventEnum {
        case geometry(x: Int32, y: Int32, physicalWidth: Int32, physicalHeight: Int32, subpixel: Int32, make: String, model: String, transform: Int32)
        case mode(flags: UInt32, width: Int32, height: Int32, refresh: Int32)
        case done
        case scale(factor: Int32)
        case name(name: String)
        case description(description: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.geometry(x: r.readInt(), y: r.readInt(), physicalWidth: r.readInt(), physicalHeight: r.readInt(), subpixel: r.readInt(), make: r.readString(), model: r.readString(), transform: r.readInt())
            case 1:
                return Self.mode(flags: r.readUInt(), width: r.readInt(), height: r.readInt(), refresh: r.readInt())
            case 2:
                return Self.done
            case 3:
                return Self.scale(factor: r.readInt())
            case 4:
                return Self.name(name: r.readString())
            case 5:
                return Self.description(description: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
