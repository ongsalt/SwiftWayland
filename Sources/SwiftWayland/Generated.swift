// public final class WlShellSurface: WlProxyBase, WlProxy {
//     public func pong(serial: UInt32) {
//         let msg = Message(objectId: id, opcode: UInt16) { data in

//         }
//         connection.queueSend(message: msg)
//     }
    
//     public func move(seat: WlSeat, serial: UInt32) {
    
//     }
    
//     public func resize(seat: WlSeat, serial: UInt32, edges: UInt32) {
    
//     }
    
//     public func setToplevel() {
    
//     }
    
//     public func setTransient(parent: WlSurface, x: Int32, y: Int32, flags: UInt32) {
    
//     }
    
//     public func setFullscreen(method: UInt32, framerate: UInt32, output: WlOutput) {
    
//     }
    
//     public func setPopup(seat: WlSeat, serial: UInt32, parent: WlSurface, x: Int32, y: Int32, flags: UInt32) {
    
//     }
    
//     public func setMaximized(output: WlOutput) {
    
//     }
    
//     public func setTitle(title: String) {
    
//     }
    
//     public func setClass(class: String) {
    
//     }

//     public enum Event: WlEventEnum {
//         case ping(serial: UInt32)
//         case configure(edges: UInt32, width: Int32, height: Int32)
//         case popupDone
    
//         static func decode(message: Message) -> Self {
//             let r = WLReader(data: message.arguments)
//             return switch message.opcode {
//             case 0:
//                 Self.ping(serial: r.readUInt())
//             case 1:
//                 Self.configure(edges: r.readUInt(), width: r.readInt(), height: r.readInt())
//             case 2:
//                 Self.popupDone
        
//             default:
//                 fatalError("Unknown message")
//             }
//         }
//     }
// }