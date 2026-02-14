import Foundation
import SwiftWayland

/// Buffer Release Explicit Synchronization
/// 
/// This object is instantiated in response to a
/// zwp_linux_surface_synchronization_v1.get_release request.
/// It provides an alternative to wl_buffer.release events, providing a
/// unique release from a single wl_surface.commit request. The release event
/// also supports explicit synchronization, providing a fence FD for the
/// client to synchronize against.
/// Exactly one event, either a fenced_release or an immediate_release, will
/// be emitted for the wl_surface.commit request. The compositor can choose
/// release by release which event it uses.
/// This event does not replace wl_buffer.release events; servers are still
/// required to send those events.
/// Once a buffer release object has delivered a 'fenced_release' or an
/// 'immediate_release' event it is automatically destroyed.
public final class ZwpLinuxBufferReleaseV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_linux_buffer_release_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public enum Event: WlEventEnum {
        /// Release Buffer With Fence
        /// 
        /// Sent when the compositor has finalised its usage of the associated
        /// buffer for the relevant commit, providing a dma_fence which will be
        /// signaled when all operations by the compositor on that buffer for that
        /// commit have finished.
        /// Once the fence has signaled, and assuming the associated buffer is not
        /// pending release from other wl_surface.commit requests, no additional
        /// explicit or implicit synchronization is required to safely reuse or
        /// destroy the buffer.
        /// This event destroys the zwp_linux_buffer_release_v1 object.
        /// 
        /// - Parameters:
        ///   - Fence: fence for last operation on buffer
        case fencedRelease(fence: FileHandle)
        
        /// Release Buffer Immediately
        /// 
        /// Sent when the compositor has finalised its usage of the associated
        /// buffer for the relevant commit, and either performed no operations
        /// using it, or has a guarantee that all its operations on that buffer for
        /// that commit have finished.
        /// Once this event is received, and assuming the associated buffer is not
        /// pending release from other wl_surface.commit requests, no additional
        /// explicit or implicit synchronization is required to safely reuse or
        /// destroy the buffer.
        /// This event destroys the zwp_linux_buffer_release_v1 object.
        case immediateRelease
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
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
