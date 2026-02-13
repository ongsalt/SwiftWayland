import Foundation
import SwiftWayland

public final class ZwpTextInputV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_text_input_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func activate(seat: WlSeat, surface: WlSurface) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .object(seat),
            .object(surface)
        ])
        connection.send(message: message)
    }
    
    public func deactivate(seat: WlSeat) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(seat)
        ])
        connection.send(message: message)
    }
    
    public func showInputPanel() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
    }
    
    public func hideInputPanel() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [])
        connection.send(message: message)
    }
    
    public func reset() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [])
        connection.send(message: message)
    }
    
    public func setSurroundingText(text: String, cursor: UInt32, anchor: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            .string(text),
            .uint(cursor),
            .uint(anchor)
        ])
        connection.send(message: message)
    }
    
    public func setContentType(hint: UInt32, purpose: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            .uint(hint),
            .uint(purpose)
        ])
        connection.send(message: message)
    }
    
    public func setCursorRectangle(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 7, contents: [
            .int(x),
            .int(y),
            .int(width),
            .int(height)
        ])
        connection.send(message: message)
    }
    
    public func setPreferredLanguage(language: String) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            .string(language)
        ])
        connection.send(message: message)
    }
    
    public func commitState(serial: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 9, contents: [
            .uint(serial)
        ])
        connection.send(message: message)
    }
    
    public func invokeAction(button: UInt32, index: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 10, contents: [
            .uint(button),
            .uint(index)
        ])
        connection.send(message: message)
    }
    
    public enum ContentHint: UInt32, WlEnum {
        case `none` = 0x0
        case `default` = 0x7
        case password = 0xc0
        case autoCompletion = 0x1
        case autoCorrection = 0x2
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
        case date = 9
        case time = 10
        case datetime = 11
        case terminal = 12
    }
    
    public enum PreeditStyle: UInt32, WlEnum {
        case `default` = 0
        case `none` = 1
        case active = 2
        case inactive = 3
        case highlight = 4
        case underline = 5
        case selection = 6
        case incorrect = 7
    }
    
    public enum TextDirection: UInt32, WlEnum {
        case auto = 0
        case ltr = 1
        case rtl = 2
    }
    
    public enum Event: WlEventEnum {
        case enter(surface: WlSurface)
        case leave
        case modifiersMap(map: Data)
        case inputPanelState(state: UInt32)
        case preeditString(serial: UInt32, text: String, commit: String)
        case preeditStyling(index: UInt32, length: UInt32, style: UInt32)
        case preeditCursor(index: Int32)
        case commitString(serial: UInt32, text: String)
        case cursorPosition(index: Int32, anchor: Int32)
        case deleteSurroundingText(index: Int32, length: UInt32)
        case keysym(serial: UInt32, time: UInt32, sym: UInt32, state: UInt32, modifiers: UInt32)
        case language(serial: UInt32, language: String)
        case textDirection(serial: UInt32, direction: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.enter(surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 1:
                return Self.leave
            case 2:
                return Self.modifiersMap(map: r.readArray())
            case 3:
                return Self.inputPanelState(state: r.readUInt())
            case 4:
                return Self.preeditString(serial: r.readUInt(), text: r.readString(), commit: r.readString())
            case 5:
                return Self.preeditStyling(index: r.readUInt(), length: r.readUInt(), style: r.readUInt())
            case 6:
                return Self.preeditCursor(index: r.readInt())
            case 7:
                return Self.commitString(serial: r.readUInt(), text: r.readString())
            case 8:
                return Self.cursorPosition(index: r.readInt(), anchor: r.readInt())
            case 9:
                return Self.deleteSurroundingText(index: r.readInt(), length: r.readUInt())
            case 10:
                return Self.keysym(serial: r.readUInt(), time: r.readUInt(), sym: r.readUInt(), state: r.readUInt(), modifiers: r.readUInt())
            case 11:
                return Self.language(serial: r.readUInt(), language: r.readString())
            case 12:
                return Self.textDirection(serial: r.readUInt(), direction: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
