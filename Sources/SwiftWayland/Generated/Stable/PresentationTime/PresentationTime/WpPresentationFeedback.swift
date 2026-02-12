import Foundation

public final class WpPresentationFeedback: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public enum Kind: UInt32, WlEnum {
        case vsync = 1
        case hwClock = 2
        case hwCompletion = 4
        case zeroCopy = 8
    }
    
    public enum Event: WlEventEnum {
        case syncOutput(output: WlOutput)
        case presented(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32, refresh: UInt32, seqHi: UInt32, seqLo: UInt32, flags: UInt32)
        case discarded
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.syncOutput(output: connection.get(as: WlOutput.self, id: r.readObjectId())!)
            case 1:
                return Self.presented(tvSecHi: r.readUInt(), tvSecLo: r.readUInt(), tvNsec: r.readUInt(), refresh: r.readUInt(), seqHi: r.readUInt(), seqLo: r.readUInt(), flags: r.readUInt())
            case 2:
                return Self.discarded
            default:
                fatalError("Unknown message")
            }
        }
    }
}
