import Foundation

public final class ZwpLinuxDmabufV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func createParams() -> ZwpLinuxBufferParamsV1 {
        let paramsId = connection.createProxy(type: ZwpLinuxBufferParamsV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(paramsId.id)
        ])
        connection.queueSend(message: message)
        return paramsId
    }
    
    public func getDefaultFeedback() -> ZwpLinuxDmabufFeedbackV1 {
        let id = connection.createProxy(type: ZwpLinuxDmabufFeedbackV1.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func getSurfaceFeedback(surface: WlSurface) -> ZwpLinuxDmabufFeedbackV1 {
        let id = connection.createProxy(type: ZwpLinuxDmabufFeedbackV1.self)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Event: WlEventEnum {
        case format(format: UInt32)
        case modifier(format: UInt32, modifierHi: UInt32, modifierLo: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.format(format: r.readUInt())
            case 1:
                return Self.modifier(format: r.readUInt(), modifierHi: r.readUInt(), modifierLo: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
