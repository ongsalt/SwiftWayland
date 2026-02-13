import Foundation
import SwiftWayland

public final class WpCursorShapeDeviceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_cursor_shape_device_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func setShape(serial: UInt32, shape: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.uint(serial),
            WaylandData.uint(shape)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Shape: UInt32, WlEnum {
        case `default` = 1
        case contextMenu = 2
        case help = 3
        case pointer = 4
        case progress = 5
        case wait = 6
        case cell = 7
        case crosshair = 8
        case text = 9
        case verticalText = 10
        case alias = 11
        case `copy` = 12
        case move = 13
        case noDrop = 14
        case notAllowed = 15
        case grab = 16
        case grabbing = 17
        case eResize = 18
        case nResize = 19
        case neResize = 20
        case nwResize = 21
        case sResize = 22
        case seResize = 23
        case swResize = 24
        case wResize = 25
        case ewResize = 26
        case nsResize = 27
        case neswResize = 28
        case nwseResize = 29
        case colResize = 30
        case rowResize = 31
        case allScroll = 32
        case zoomIn = 33
        case zoomOut = 34
        case dndAsk = 35
        case allResize = 36
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidShape = 1
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
