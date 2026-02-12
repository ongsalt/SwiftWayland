import Foundation
import SwiftWayland

public final class WpColorRepresentationSurfaceV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setAlphaMode(alphaMode: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .uint(alphaMode)
        ])
        connection.queueSend(message: message)
    }
    
    public func setCoefficientsAndRange(coefficients: UInt32, range: UInt32) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .uint(coefficients),
            .uint(range)
        ])
        connection.queueSend(message: message)
    }
    
    public func setChromaLocation(chromaLocation: UInt32) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .uint(chromaLocation)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case alphaMode = 1
        case coefficients = 2
        case pixelFormat = 3
        case inert = 4
        case chromaLocation = 5
    }
    
    public enum AlphaMode: UInt32, WlEnum {
        case premultipliedElectrical = 0
        case premultipliedOptical = 1
        case straight = 2
    }
    
    public enum Coefficients: UInt32, WlEnum {
        case identity = 1
        case bt709 = 2
        case fcc = 3
        case bt601 = 4
        case smpte240 = 5
        case bt2020 = 6
        case bt2020Cl = 7
        case ictcp = 8
    }
    
    public enum Range: UInt32, WlEnum {
        case full = 1
        case limited = 2
    }
    
    public enum ChromaLocation: UInt32, WlEnum {
        case type0 = 1
        case type1 = 2
        case type2 = 3
        case type3 = 4
        case type4 = 5
        case type5 = 6
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
