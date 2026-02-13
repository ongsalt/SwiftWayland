import Foundation
import SwiftWayland

public final class ZwpInputMethodContextV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_input_method_context_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func commitString(serial: UInt32, text: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.uint(serial),
            WaylandData.string(text)
        ])
        connection.send(message: message)
    }
    
    public func preeditString(serial: UInt32, text: String, commit: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.uint(serial),
            WaylandData.string(text),
            WaylandData.string(commit)
        ])
        connection.send(message: message)
    }
    
    public func preeditStyling(index: UInt32, length: UInt32, style: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.uint(index),
            WaylandData.uint(length),
            WaylandData.uint(style)
        ])
        connection.send(message: message)
    }
    
    public func preeditCursor(index: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.int(index)
        ])
        connection.send(message: message)
    }
    
    public func deleteSurroundingText(index: Int32, length: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.int(index),
            WaylandData.uint(length)
        ])
        connection.send(message: message)
    }
    
    public func cursorPosition(index: Int32, anchor: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            WaylandData.int(index),
            WaylandData.int(anchor)
        ])
        connection.send(message: message)
    }
    
    public func modifiersMap(map: Data) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 7, contents: [
            WaylandData.array(map)
        ])
        connection.send(message: message)
    }
    
    public func keysym(serial: UInt32, time: UInt32, sym: UInt32, state: UInt32, modifiers: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            WaylandData.uint(serial),
            WaylandData.uint(time),
            WaylandData.uint(sym),
            WaylandData.uint(state),
            WaylandData.uint(modifiers)
        ])
        connection.send(message: message)
    }
    
    public func grabKeyboard() throws(WaylandProxyError) -> WlKeyboard {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let keyboard = connection.createProxy(type: WlKeyboard.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 9, contents: [
            WaylandData.newId(keyboard.id)
        ])
        connection.send(message: message)
        return keyboard
    }
    
    public func key(serial: UInt32, time: UInt32, key: UInt32, state: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 10, contents: [
            WaylandData.uint(serial),
            WaylandData.uint(time),
            WaylandData.uint(key),
            WaylandData.uint(state)
        ])
        connection.send(message: message)
    }
    
    public func modifiers(serial: UInt32, modsDepressed: UInt32, modsLatched: UInt32, modsLocked: UInt32, group: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 11, contents: [
            WaylandData.uint(serial),
            WaylandData.uint(modsDepressed),
            WaylandData.uint(modsLatched),
            WaylandData.uint(modsLocked),
            WaylandData.uint(group)
        ])
        connection.send(message: message)
    }
    
    public func language(serial: UInt32, language: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 12, contents: [
            WaylandData.uint(serial),
            WaylandData.string(language)
        ])
        connection.send(message: message)
    }
    
    public func textDirection(serial: UInt32, direction: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 13, contents: [
            WaylandData.uint(serial),
            WaylandData.uint(direction)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case surroundingText(text: String, cursor: UInt32, anchor: UInt32)
        case reset
        case contentType(hint: UInt32, purpose: UInt32)
        case invokeAction(button: UInt32, index: UInt32)
        case commitState(serial: UInt32)
        case preferredLanguage(language: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.surroundingText(text: r.readString(), cursor: r.readUInt(), anchor: r.readUInt())
            case 1:
                return Self.reset
            case 2:
                return Self.contentType(hint: r.readUInt(), purpose: r.readUInt())
            case 3:
                return Self.invokeAction(button: r.readUInt(), index: r.readUInt())
            case 4:
                return Self.commitState(serial: r.readUInt())
            case 5:
                return Self.preferredLanguage(language: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
