import Foundation
import SwiftWayland

public final class ZwpLinuxBufferReleaseV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public enum Event: WlEventEnum {
        case fencedRelease(fence: FileHandle)
        case immediateRelease
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.fencedRelease(fence: r.readFd())
            case 1:
                return Self.immediateRelease
            default:
                fatalError("Unknown message")
            }
        }
    }
}
