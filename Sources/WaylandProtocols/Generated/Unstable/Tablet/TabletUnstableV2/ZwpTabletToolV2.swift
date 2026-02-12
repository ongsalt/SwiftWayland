import Foundation
import SwiftWayland

public final class ZwpTabletToolV2: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func setCursor(serial: UInt32, surface: WlSurface, hotspotX: Int32, hotspotY: Int32) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .uint(serial),
            .object(surface),
            .int(hotspotX),
            .int(hotspotY)
        ])
        connection.queueSend(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum `Type`: UInt32, WlEnum {
        case pen = 320
        case eraser = 321
        case brush = 322
        case pencil = 323
        case airbrush = 324
        case finger = 325
        case mouse = 326
        case lens = 327
    }
    
    public enum Capability: UInt32, WlEnum {
        case tilt = 1
        case pressure = 2
        case distance = 3
        case rotation = 4
        case slider = 5
        case wheel = 6
    }
    
    public enum ButtonState: UInt32, WlEnum {
        case released = 0
        case pressed = 1
    }
    
    public enum Error: UInt32, WlEnum {
        case role = 0
    }
    
    public enum Event: WlEventEnum {
        case type(toolType: UInt32)
        case hardwareSerial(hardwareSerialHi: UInt32, hardwareSerialLo: UInt32)
        case hardwareIdWacom(hardwareIdHi: UInt32, hardwareIdLo: UInt32)
        case capability(capability: UInt32)
        case done
        case removed
        case proximityIn(serial: UInt32, tablet: ZwpTabletV2, surface: WlSurface)
        case proximityOut
        case down(serial: UInt32)
        case up
        case motion(x: Double, y: Double)
        case pressure(pressure: UInt32)
        case distance(distance: UInt32)
        case tilt(tiltX: Double, tiltY: Double)
        case rotation(degrees: Double)
        case slider(position: Int32)
        case wheel(degrees: Double, clicks: Int32)
        case button(serial: UInt32, button: UInt32, state: UInt32)
        case frame(time: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.type(toolType: r.readUInt())
            case 1:
                return Self.hardwareSerial(hardwareSerialHi: r.readUInt(), hardwareSerialLo: r.readUInt())
            case 2:
                return Self.hardwareIdWacom(hardwareIdHi: r.readUInt(), hardwareIdLo: r.readUInt())
            case 3:
                return Self.capability(capability: r.readUInt())
            case 4:
                return Self.done
            case 5:
                return Self.removed
            case 6:
                return Self.proximityIn(serial: r.readUInt(), tablet: connection.get(as: ZwpTabletV2.self, id: r.readObjectId())!, surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 7:
                return Self.proximityOut
            case 8:
                return Self.down(serial: r.readUInt())
            case 9:
                return Self.up
            case 10:
                return Self.motion(x: r.readFixed(), y: r.readFixed())
            case 11:
                return Self.pressure(pressure: r.readUInt())
            case 12:
                return Self.distance(distance: r.readUInt())
            case 13:
                return Self.tilt(tiltX: r.readFixed(), tiltY: r.readFixed())
            case 14:
                return Self.rotation(degrees: r.readFixed())
            case 15:
                return Self.slider(position: r.readInt())
            case 16:
                return Self.wheel(degrees: r.readFixed(), clicks: r.readInt())
            case 17:
                return Self.button(serial: r.readUInt(), button: r.readUInt(), state: r.readUInt())
            case 18:
                return Self.frame(time: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
