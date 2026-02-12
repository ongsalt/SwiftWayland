public final class WlShellSurface: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }
    public func pong(serial: UInt32) {
        let message = Message(objectId: id, opcode: 0, contents: [
            WaylandData.uint(`serial`)
        ])
        connection.queueSend(message: message)
    }
    
    public func move(seat: WlSeat, serial: UInt32) {
        let message = Message(objectId: id, opcode: 1, contents: [
            WaylandData.object(`seat`),
            WaylandData.uint(`serial`)
        ])
        connection.queueSend(message: message)
    }
    
    public func resize(seat: WlSeat, serial: UInt32, edges: UInt32) {
        let message = Message(objectId: id, opcode: 2, contents: [
            WaylandData.object(`seat`),
            WaylandData.uint(`serial`),
            WaylandData.uint(`edges`)
        ])
        connection.queueSend(message: message)
    }
    
    public func setToplevel() {
        let message = Message(objectId: id, opcode: 3, contents: [
            
        ])
        connection.queueSend(message: message)
    }
    
    public func setTransient(parent: WlSurface, x: Int32, y: Int32, flags: UInt32) {
        let message = Message(objectId: id, opcode: 4, contents: [
            WaylandData.object(`parent`),
            WaylandData.int(`x`),
            WaylandData.int(`y`),
            WaylandData.uint(`flags`)
        ])
        connection.queueSend(message: message)
    }
    
    public func setFullscreen(method: UInt32, framerate: UInt32, output: WlOutput) {
        let message = Message(objectId: id, opcode: 5, contents: [
            WaylandData.uint(`method`),
            WaylandData.uint(`framerate`),
            WaylandData.object(`output`)
        ])
        connection.queueSend(message: message)
    }
    
    public func setPopup(seat: WlSeat, serial: UInt32, parent: WlSurface, x: Int32, y: Int32, flags: UInt32) {
        let message = Message(objectId: id, opcode: 6, contents: [
            WaylandData.object(`seat`),
            WaylandData.uint(`serial`),
            WaylandData.object(`parent`),
            WaylandData.int(`x`),
            WaylandData.int(`y`),
            WaylandData.uint(`flags`)
        ])
        connection.queueSend(message: message)
    }
    
    public func setMaximized(output: WlOutput) {
        let message = Message(objectId: id, opcode: 7, contents: [
            WaylandData.object(`output`)
        ])
        connection.queueSend(message: message)
    }
    
    public func setTitle(title: String) {
        let message = Message(objectId: id, opcode: 8, contents: [
            WaylandData.string(`title`)
        ])
        connection.queueSend(message: message)
    }
    
    public func setClass(class: String) {
        let message = Message(objectId: id, opcode: 9, contents: [
            WaylandData.string(`class`)
        ])
        connection.queueSend(message: message)
    }

    [enum hereeee]

    public enum Event: WlEventEnum {
        case ping(serial: UInt32)
        case configure(edges: UInt32, width: Int32, height: Int32)
        case popupDone
    
        public static func decode(message: Message) -> Self {
            let r = WLReader(data: message.arguments)
            return switch message.opcode {
            case 0:
                Self.ping(serial: r.readUInt())
            case 1:
                Self.configure(edges: r.readUInt(), width: r.readInt(), height: r.readInt())
            case 2:
                Self.popupDone
            default:
                fatalError("Unknown message")
            }
        }
    }
}