import Foundation
import SwiftWayland

/// A Drm Lease
/// 
/// A DRM lease object is used to transfer the DRM file descriptor to the
/// client and manage the lifetime of the lease.
/// Some time after the wp_drm_lease_v1 object is created, the compositor
/// will reply with the lease request's result. If the lease request is
/// granted, the compositor will send a lease_fd event. If the lease request
/// is denied, the compositor will send a finished event without a lease_fd
/// event.
public final class WpDrmLeaseV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_drm_lease_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroys The Lease Object
    /// 
    /// The client should send this to indicate that it no longer wishes to use
    /// this lease. The compositor should use drmModeRevokeLease on the
    /// appropriate file descriptor, if necessary.
    /// Upon destruction, the compositor should advertise the connector for
    /// leasing again by sending the connector event through the
    /// wp_drm_lease_device_v1 interface.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// Shares The Drm File Descriptor
        /// 
        /// This event returns a file descriptor suitable for use with DRM-related
        /// ioctls. The client should use drmModeGetLease to enumerate the DRM
        /// objects which have been leased to them. The compositor guarantees it
        /// will not use the leased DRM objects itself until it sends the finished
        /// event. If the compositor cannot or will not grant a lease for the
        /// requested connectors, it will not send this event, instead sending the
        /// finished event.
        /// The compositor will send this event at most once during this objects
        /// lifetime.
        /// 
        /// - Parameters:
        ///   - LeasedFd: leased DRM file descriptor
        case leaseFd(leasedFd: FileHandle)
        
        /// Sent When The Lease Has Been Revoked
        /// 
        /// The compositor uses this event to either reject a lease request, or if
        /// it previously sent a lease_fd, to notify the client that the lease has
        /// been revoked. If the client requires a new lease, they should destroy
        /// this object and submit a new lease request. The compositor will send
        /// no further events for this object after sending the finish event.
        /// Compositors should revoke the lease when any of the leased resources
        /// become unavailable, namely when a hot-unplug occurs or when the
        /// compositor loses DRM master. Compositors may advertise the connector
        /// for leasing again, if the resource is available, by sending the
        /// connector event through the wp_drm_lease_device_v1 interface.
        case finished
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.leaseFd(leasedFd: r.readFd())
            case 1:
                return Self.finished
            default:
                fatalError("Unknown message")
            }
        }
    }
}
