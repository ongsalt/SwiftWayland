import Foundation
import SwiftWayland

public final class WpImageDescriptionCreatorIccV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_image_description_creator_icc_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func create() throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(imageDescription.id)
        ])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
        return imageDescription
    }
    
    public func setIccFile(iccProfile: FileHandle, offset: UInt32, length: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.fd(iccProfile),
            WaylandData.uint(offset),
            WaylandData.uint(length)
        ])
        connection.send(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case incompleteSet = 0
        case alreadySet = 1
        case badFd = 2
        case badSize = 3
        case outOfFile = 4
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
