import Foundation
import SwiftWayland

public final class ZwpTextInputV3: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_text_input_v3"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func enable() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    public func disable() {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
    }
    
    public func setSurroundingText(text: String, cursor: Int32, anchor: Int32) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .string(text),
            .int(cursor),
            .int(anchor)
        ])
        connection.send(message: message)
    }
    
    public func setTextChangeCause(cause: UInt32) {
        let message = Message(objectId: self.id, opcode: 4, contents: [
            .uint(cause)
        ])
        connection.send(message: message)
    }
    
    public func setContentType(hint: UInt32, purpose: UInt32) {
        let message = Message(objectId: self.id, opcode: 5, contents: [
            .uint(hint),
            .uint(purpose)
        ])
        connection.send(message: message)
    }
    
    public func setCursorRectangle(x: Int32, y: Int32, width: Int32, height: Int32) {
        let message = Message(objectId: self.id, opcode: 6, contents: [
            .int(x),
            .int(y),
            .int(width),
            .int(height)
        ])
        connection.send(message: message)
    }
    
    public func commit() {
        let message = Message(objectId: self.id, opcode: 7, contents: [])
        connection.send(message: message)
    }
    
    public enum ChangeCause: UInt32, WlEnum {
        case inputMethod = 0
        case other = 1
    }
    
    public enum ContentHint: UInt32, WlEnum {
        case `none` = 0x0
        case completion = 0x1
        case spellcheck = 0x2
        case autoCapitalization = 0x4
        case lowercase = 0x8
        case uppercase = 0x10
        case titlecase = 0x20
        case hiddenText = 0x40
        case sensitiveData = 0x80
        case latin = 0x100
        case multiline = 0x200
    }
    
    public enum ContentPurpose: UInt32, WlEnum {
        case normal = 0
        case alpha = 1
        case digits = 2
        case number = 3
        case phone = 4
        case url = 5
        case email = 6
        case name = 7
        case password = 8
        case pin = 9
        case date = 10
        case time = 11
        case datetime = 12
        case terminal = 13
    }
    
    public enum Event: WlEventEnum {
        case enter(surface: WlSurface)
        case leave(surface: WlSurface)
        case preeditString(text: String, cursorBegin: Int32, cursorEnd: Int32)
        case commitString(text: String)
        case deleteSurroundingText(beforeLength: UInt32, afterLength: UInt32)
        case done(serial: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.enter(surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 1:
                return Self.leave(surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 2:
                return Self.preeditString(text: r.readString(), cursorBegin: r.readInt(), cursorEnd: r.readInt())
            case 3:
                return Self.commitString(text: r.readString())
            case 4:
                return Self.deleteSurroundingText(beforeLength: r.readUInt(), afterLength: r.readUInt())
            case 5:
                return Self.done(serial: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
