import Foundation
import SwiftWayland

public final class WpImageDescriptionCreatorParamsV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_image_description_creator_params_v1"
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
    
    public func setTfNamed(tf: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.uint(tf)
        ])
        connection.send(message: message)
    }
    
    public func setTfPower(eexp: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.uint(eexp)
        ])
        connection.send(message: message)
    }
    
    public func setPrimariesNamed(primaries: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.uint(primaries)
        ])
        connection.send(message: message)
    }
    
    public func setPrimaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.int(rX),
            WaylandData.int(rY),
            WaylandData.int(gX),
            WaylandData.int(gY),
            WaylandData.int(bX),
            WaylandData.int(bY),
            WaylandData.int(wX),
            WaylandData.int(wY)
        ])
        connection.send(message: message)
    }
    
    public func setLuminances(minLum: UInt32, maxLum: UInt32, referenceLum: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.uint(minLum),
            WaylandData.uint(maxLum),
            WaylandData.uint(referenceLum)
        ])
        connection.send(message: message)
    }
    
    public func setMasteringDisplayPrimaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            WaylandData.int(rX),
            WaylandData.int(rY),
            WaylandData.int(gX),
            WaylandData.int(gY),
            WaylandData.int(bX),
            WaylandData.int(bY),
            WaylandData.int(wX),
            WaylandData.int(wY)
        ])
        connection.send(message: message)
    }
    
    public func setMasteringLuminance(minLum: UInt32, maxLum: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 7, contents: [
            WaylandData.uint(minLum),
            WaylandData.uint(maxLum)
        ])
        connection.send(message: message)
    }
    
    public func setMaxCll(maxCll: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            WaylandData.uint(maxCll)
        ])
        connection.send(message: message)
    }
    
    public func setMaxFall(maxFall: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 9, contents: [
            WaylandData.uint(maxFall)
        ])
        connection.send(message: message)
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
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
