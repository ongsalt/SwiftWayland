import Foundation
import SwiftWayland

public final class WpImageDescriptionInfoV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public enum Event: WlEventEnum {
        case done
        case iccFile(icc: FileHandle, iccSize: UInt32)
        case primaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32)
        case primariesNamed(primaries: UInt32)
        case tfPower(eexp: UInt32)
        case tfNamed(tf: UInt32)
        case luminances(minLum: UInt32, maxLum: UInt32, referenceLum: UInt32)
        case targetPrimaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32)
        case targetLuminance(minLum: UInt32, maxLum: UInt32)
        case targetMaxCll(maxCll: UInt32)
        case targetMaxFall(maxFall: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.done
            case 1:
                return Self.iccFile(icc: r.readFd(), iccSize: r.readUInt())
            case 2:
                return Self.primaries(rX: r.readInt(), rY: r.readInt(), gX: r.readInt(), gY: r.readInt(), bX: r.readInt(), bY: r.readInt(), wX: r.readInt(), wY: r.readInt())
            case 3:
                return Self.primariesNamed(primaries: r.readUInt())
            case 4:
                return Self.tfPower(eexp: r.readUInt())
            case 5:
                return Self.tfNamed(tf: r.readUInt())
            case 6:
                return Self.luminances(minLum: r.readUInt(), maxLum: r.readUInt(), referenceLum: r.readUInt())
            case 7:
                return Self.targetPrimaries(rX: r.readInt(), rY: r.readInt(), gX: r.readInt(), gY: r.readInt(), bX: r.readInt(), bY: r.readInt(), wX: r.readInt(), wY: r.readInt())
            case 8:
                return Self.targetLuminance(minLum: r.readUInt(), maxLum: r.readUInt())
            case 9:
                return Self.targetMaxCll(maxCll: r.readUInt())
            case 10:
                return Self.targetMaxFall(maxFall: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
