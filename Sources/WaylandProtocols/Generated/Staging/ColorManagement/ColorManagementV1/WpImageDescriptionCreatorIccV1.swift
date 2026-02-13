import Foundation
import SwiftWayland

public final class WpImageDescriptionCreatorIccV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_image_description_creator_icc_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func create() -> WpImageDescriptionV1 {
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(imageDescription.id)
        ])
        connection.send(message: message)
        return imageDescription
    }
    
    public func setIccFile(iccProfile: FileHandle, offset: UInt32, length: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .fd(iccProfile),
            .uint(offset),
            .uint(length)
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
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
