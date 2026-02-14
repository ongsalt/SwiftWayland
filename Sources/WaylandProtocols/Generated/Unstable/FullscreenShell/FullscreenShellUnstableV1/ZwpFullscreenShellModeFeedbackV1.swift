import Foundation
import SwiftWayland


public final class ZwpFullscreenShellModeFeedbackV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_fullscreen_shell_mode_feedback_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public enum Event: WlEventEnum {
        /// Mode Switch Succeeded
        /// 
        /// This event indicates that the attempted mode switch operation was
        /// successful.  A surface of the size requested in the mode switch
        /// will fill the output without scaling.
        /// Upon receiving this event, the client should destroy the
        /// wl_fullscreen_shell_mode_feedback object.
        case modeSuccessful
        
        /// Mode Switch Failed
        /// 
        /// This event indicates that the attempted mode switch operation
        /// failed.  This may be because the requested output mode is not
        /// possible or it may mean that the compositor does not want to allow it.
        /// Upon receiving this event, the client should destroy the
        /// wl_fullscreen_shell_mode_feedback object.
        case modeFailed
        
        /// Mode Switch Cancelled
        /// 
        /// This event indicates that the attempted mode switch operation was
        /// cancelled.  Most likely this is because the client requested a
        /// second mode switch before the first one completed.
        /// Upon receiving this event, the client should destroy the
        /// wl_fullscreen_shell_mode_feedback object.
        case presentCancelled
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
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
