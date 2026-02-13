import Foundation
import SwiftWayland

public final class WpColorManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getOutput(output: WlOutput) throws(WaylandProxyError) -> WpColorManagementOutputV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpColorManagementOutputV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(output)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getSurface(surface: WlSurface) throws(WaylandProxyError) -> WpColorManagementSurfaceV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpColorManagementSurfaceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getSurfaceFeedback(surface: WlSurface) throws(WaylandProxyError) -> WpColorManagementSurfaceFeedbackV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpColorManagementSurfaceFeedbackV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    public func createIccCreator() throws(WaylandProxyError) -> WpImageDescriptionCreatorIccV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let obj = connection.createProxy(type: WpImageDescriptionCreatorIccV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 4, contents: [
            .newId(obj.id)
        ])
        connection.send(message: message)
        return obj
    }
    
    public func createParametricCreator() throws(WaylandProxyError) -> WpImageDescriptionCreatorParamsV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let obj = connection.createProxy(type: WpImageDescriptionCreatorParamsV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 5, contents: [
            .newId(obj.id)
        ])
        connection.send(message: message)
        return obj
    }
    
    public func createWindowsScrgb() throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 6, contents: [
            .newId(imageDescription.id)
        ])
        connection.send(message: message)
        return imageDescription
    }
    
    public func getImageDescription(reference: WpImageDescriptionReferenceV1) throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 7, contents: [
            .newId(imageDescription.id),
            .object(reference)
        ])
        connection.send(message: message)
        return imageDescription
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case unsupportedFeature = 0
        case surfaceExists = 1
    }
    
    public enum RenderIntent: UInt32, WlEnum {
        case perceptual = 0
        case relative = 1
        case saturation = 2
        case absolute = 3
        case relativeBpc = 4
        case absoluteNoAdaptation = 5
    }
    
    public enum Feature: UInt32, WlEnum {
        case iccV2V4 = 0
        case parametric = 1
        case setPrimaries = 2
        case setTfPower = 3
        case setLuminances = 4
        case setMasteringDisplayPrimaries = 5
        case extendedTargetVolume = 6
        case windowsScrgb = 7
    }
    
    public enum Primaries: UInt32, WlEnum {
        case srgb = 1
        case palM = 2
        case pal = 3
        case ntsc = 4
        case genericFilm = 5
        case bt2020 = 6
        case cie1931Xyz = 7
        case dciP3 = 8
        case displayP3 = 9
        case adobeRgb = 10
    }
    
    public enum TransferFunction: UInt32, WlEnum {
        case bt1886 = 1
        case gamma22 = 2
        case gamma28 = 3
        case st240 = 4
        case extLinear = 5
        case log100 = 6
        case log316 = 7
        case xvycc = 8
        case srgb = 9
        case extSrgb = 10
        case st2084Pq = 11
        case st428 = 12
        case hlg = 13
        case compoundPower24 = 14
    }
    
    public enum Event: WlEventEnum {
        case supportedIntent(renderIntent: UInt32)
        case supportedFeature(feature: UInt32)
        case supportedTfNamed(tf: UInt32)
        case supportedPrimariesNamed(primaries: UInt32)
        case done
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.supportedIntent(renderIntent: r.readUInt())
            case 1:
                return Self.supportedFeature(feature: r.readUInt())
            case 2:
                return Self.supportedTfNamed(tf: r.readUInt())
            case 3:
                return Self.supportedPrimariesNamed(primaries: r.readUInt())
            case 4:
                return Self.done
            default:
                fatalError("Unknown message")
            }
        }
    }
}
