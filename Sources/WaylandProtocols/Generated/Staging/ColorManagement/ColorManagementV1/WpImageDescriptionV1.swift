import Foundation
import SwiftWayland

public final class WpImageDescriptionV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_image_description_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func getInformation() -> WpImageDescriptionInfoV1 {
        let information = connection.createProxy(type: WpImageDescriptionInfoV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(information.id)
        ])
        connection.send(message: message)
        return information
    }
    
    public enum Error: UInt32, WlEnum {
        case notReady = 0
        case noInformation = 1
    }
    
    public enum Cause: UInt32, WlEnum {
        case lowVersion = 0
        case unsupported = 1
        case operatingSystem = 2
        case noOutput = 3
    }
    
    public enum Event: WlEventEnum {
        case failed(cause: UInt32, msg: String)
        case ready(identity: UInt32)
        case ready2(identityHi: UInt32, identityLo: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.failed(cause: r.readUInt(), msg: r.readString())
            case 1:
                return Self.ready(identity: r.readUInt())
            case 2:
                return Self.ready2(identityHi: r.readUInt(), identityLo: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
