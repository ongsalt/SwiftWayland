import Foundation
import SwiftWayland

public final class WpImageDescriptionCreatorParamsV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func create() -> WpImageDescriptionV1 {
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(imageDescription.id)
        ])
        connection.queueSend(message: message)
        return imageDescription
    }
    
    public func setTfNamed(tf: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .uint(tf)
        ])
        connection.queueSend(message: message)
    }
    
    public func setTfPower(eexp: UInt32) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .uint(eexp)
        ])
        connection.queueSend(message: message)
    }
    
    public func setPrimariesNamed(primaries: UInt32) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .uint(primaries)
        ])
        connection.queueSend(message: message)
    }
    
    public func setPrimaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32) {
        let message = Message(objectId: self.id, opcode: 4, contents: [
            .int(rX),
            .int(rY),
            .int(gX),
            .int(gY),
            .int(bX),
            .int(bY),
            .int(wX),
            .int(wY)
        ])
        connection.queueSend(message: message)
    }
    
    public func setLuminances(minLum: UInt32, maxLum: UInt32, referenceLum: UInt32) {
        let message = Message(objectId: self.id, opcode: 5, contents: [
            .uint(minLum),
            .uint(maxLum),
            .uint(referenceLum)
        ])
        connection.queueSend(message: message)
    }
    
    public func setMasteringDisplayPrimaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32) {
        let message = Message(objectId: self.id, opcode: 6, contents: [
            .int(rX),
            .int(rY),
            .int(gX),
            .int(gY),
            .int(bX),
            .int(bY),
            .int(wX),
            .int(wY)
        ])
        connection.queueSend(message: message)
    }
    
    public func setMasteringLuminance(minLum: UInt32, maxLum: UInt32) {
        let message = Message(objectId: self.id, opcode: 7, contents: [
            .uint(minLum),
            .uint(maxLum)
        ])
        connection.queueSend(message: message)
    }
    
    public func setMaxCll(maxCll: UInt32) {
        let message = Message(objectId: self.id, opcode: 8, contents: [
            .uint(maxCll)
        ])
        connection.queueSend(message: message)
    }
    
    public func setMaxFall(maxFall: UInt32) {
        let message = Message(objectId: self.id, opcode: 9, contents: [
            .uint(maxFall)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case incompleteSet = 0
        case alreadySet = 1
        case unsupportedFeature = 2
        case invalidTf = 3
        case invalidPrimariesNamed = 4
        case invalidLuminance = 5
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
