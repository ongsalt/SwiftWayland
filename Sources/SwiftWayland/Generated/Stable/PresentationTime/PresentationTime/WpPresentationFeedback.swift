import Foundation

public final class WpPresentationFeedback: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_presentation_feedback"
    public var onEvent: (Event) -> Void = { _ in }

    public enum Kind: UInt32, WlEnum {
        case vsync = 0x1
        case hwClock = 0x2
        case hwCompletion = 0x4
        case zeroCopy = 0x8
    }
    
    public enum Event: WlEventEnum {
        case syncOutput(output: WlOutput)
        case presented(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32, refresh: UInt32, seqHi: UInt32, seqLo: UInt32, flags: UInt32)
        case discarded
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
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
