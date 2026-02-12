public final class WlShellSurface: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func pong(serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .uint(serial)
        ])
        connection.queueSend(message: message)
    }
    
    public func move(seat: WlSeat, serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(seat),
            .uint(serial)
        ])
        connection.queueSend(message: message)
    }
    
    public func resize(seat: WlSeat, serial: UInt32, edges: UInt32) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(seat),
            .uint(serial),
            .uint(edges)
        ])
        connection.queueSend(message: message)
    }
    
    public func setToplevel() {
        let message = Message(objectId: self.id, opcode: 3, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setTransient(parent: WlSurface, x: Int32, y: Int32, flags: UInt32) {
        let message = Message(objectId: self.id, opcode: 4, contents: [
            .object(parent),
            .int(x),
            .int(y),
            .uint(flags)
        ])
        connection.queueSend(message: message)
    }
    
    public func setFullscreen(method: UInt32, framerate: UInt32, output: WlOutput) {
        let message = Message(objectId: self.id, opcode: 5, contents: [
            .uint(method),
            .uint(framerate),
            .object(output)
        ])
        connection.queueSend(message: message)
    }
    
    public func setPopup(seat: WlSeat, serial: UInt32, parent: WlSurface, x: Int32, y: Int32, flags: UInt32) {
        let message = Message(objectId: self.id, opcode: 6, contents: [
            .object(seat),
            .uint(serial),
            .object(parent),
            .int(x),
            .int(y),
            .uint(flags)
        ])
        connection.queueSend(message: message)
    }
    
    public func setMaximized(output: WlOutput) {
        let message = Message(objectId: self.id, opcode: 7, contents: [
            .object(output)
        ])
        connection.queueSend(message: message)
    }
    
    public func setTitle(title: String) {
        let message = Message(objectId: self.id, opcode: 8, contents: [
            .string(title)
        ])
        connection.queueSend(message: message)
    }
    
    public func setClass(class: String) {
        let message = Message(objectId: self.id, opcode: 9, contents: [
            .string(class)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Resize: UInt32, WlEnum {
        case none = 0
        case top = 1
        case bottom = 2
        case left = 4
        case topLeft = 5
        case bottomLeft = 6
        case right = 8
        case topRight = 9
        case bottomRight = 10
    }
    
    public enum Transient: UInt32, WlEnum {
        case inactive = 1
    }
    
    public enum FullscreenMethod: UInt32, WlEnum {
        case default = 0
        case scale = 1
        case driver = 2
        case fill = 3
    }
    
    public enum Event: WlEventEnum {
        case ping(serial: UInt32)
        case configure(edges: UInt32, width: Int32, height: Int32)
        case popupDone
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments)
            switch message.opcode {
            case 0:
                return Self.ping(serial: r.readUInt())
            case 1:
                return Self.configure(edges: r.readUInt(), width: r.readInt(), height: r.readInt())
            case 2:
                return Self.popupDone
            default:
                fatalError("Unknown message")
            }
        }
    }
}
