import Foundation
import SwiftWayland

public final class ZwpPointerConstraintsV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_pointer_constraints_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func lockPointer(surface: WlSurface, pointer: WlPointer, region: WlRegion, lifetime: UInt32) throws(WaylandProxyError)  -> ZwpLockedPointerV1 {
        let id = connection.createProxy(type: ZwpLockedPointerV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface),
            .object(pointer),
            .object(region),
            .uint(lifetime)
        ])
        connection.send(message: message)
        return id
    }
    
    public func confinePointer(surface: WlSurface, pointer: WlPointer, region: WlRegion, lifetime: UInt32) throws(WaylandProxyError)  -> ZwpConfinedPointerV1 {
        let id = connection.createProxy(type: ZwpConfinedPointerV1.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id),
            .object(surface),
            .object(pointer),
            .object(region),
            .uint(lifetime)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case alreadyConstrained = 1
    }
    
    public enum Lifetime: UInt32, WlEnum {
        case oneshot = 1
        case persistent = 2
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
