import Foundation
import SwiftWayland

public final class ZwpFullscreenShellModeFeedbackV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_fullscreen_shell_mode_feedback_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public enum Event: WlEventEnum {
        case modeSuccessful
        case modeFailed
        case presentCancelled
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.modeSuccessful
            case 1:
                return Self.modeFailed
            case 2:
                return Self.presentCancelled
            default:
                fatalError("Unknown message")
            }
        }
    }
}
