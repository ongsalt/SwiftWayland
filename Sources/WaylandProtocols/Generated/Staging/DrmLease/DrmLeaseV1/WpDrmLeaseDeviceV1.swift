import Foundation
import SwiftWayland

/// Lease Device
/// 
/// This protocol is used by Wayland compositors which act as Direct
/// Rendering Manager (DRM) masters to lease DRM resources to Wayland
/// clients.
/// The compositor will advertise one wp_drm_lease_device_v1 global for each
/// DRM node. Some time after a client binds to the wp_drm_lease_device_v1
/// global, the compositor will send a drm_fd event followed by zero, one or
/// more connector events. After all currently available connectors have been
/// sent, the compositor will send a wp_drm_lease_device_v1.done event.
/// When the list of connectors available for lease changes the compositor
/// will send wp_drm_lease_device_v1.connector events for added connectors and
/// wp_drm_lease_connector_v1.withdrawn events for removed connectors,
/// followed by a wp_drm_lease_device_v1.done event.
/// The compositor will indicate when a device is gone by removing the global
/// via a wl_registry.global_remove event. Upon receiving this event, the
/// client should destroy any matching wp_drm_lease_device_v1 object.
/// To destroy a wp_drm_lease_device_v1 object, the client must first issue
/// a release request. Upon receiving this request, the compositor will
/// immediately send a released event and destroy the object. The client must
/// continue to process and discard drm_fd and connector events until it
/// receives the released event. Upon receiving the released event, the
/// client can safely cleanup any client-side resources.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpDrmLeaseDeviceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_drm_lease_device_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create A Lease Request Object
    /// 
    /// Creates a lease request object.
    /// See the documentation for wp_drm_lease_request_v1 for details.
    public func createLeaseRequest() throws(WaylandProxyError) -> WpDrmLeaseRequestV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpDrmLeaseRequestV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Release This Object
    /// 
    /// Indicates the client no longer wishes to use this object. In response
    /// the compositor will immediately send the released event and destroy
    /// this object. It can however not guarantee that the client won't receive
    /// connector events before the released event. The client must not send any
    /// requests after this one, doing so will raise a wl_display error.
    /// Existing connectors, lease request and leases will not be affected.
    public func release() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    public enum Event: WlEventEnum {
        /// Open A Non-Master Fd For This Drm Node
        /// 
        /// The compositor will send this event when the wp_drm_lease_device_v1
        /// global is bound, although there are no guarantees as to how long this
        /// takes - the compositor might need to wait until regaining DRM master.
        /// The included fd is a non-master DRM file descriptor opened for this
        /// device and the compositor must not authenticate it.
        /// The purpose of this event is to give the client the ability to
        /// query DRM and discover information which may help them pick the
        /// appropriate DRM device or select the appropriate connectors therein.
        /// 
        /// - Parameters:
        ///   - Fd: DRM file descriptor
        case drmFd(fd: FileHandle)
        
        /// Advertise Connectors Available For Leases
        /// 
        /// The compositor will use this event to advertise connectors available for
        /// lease by clients. This object may be passed into a lease request to
        /// indicate the client would like to lease that connector, see
        /// wp_drm_lease_request_v1.request_connector for details. While the
        /// compositor will make a best effort to not send disconnected connectors,
        /// no guarantees can be made.
        /// The compositor must send the drm_fd event before sending connectors.
        /// After the drm_fd event it will send all available connectors but may
        /// send additional connectors at any time.
        case connector(id: WpDrmLeaseConnectorV1)
        
        /// Signals Grouping Of Connectors
        /// 
        /// The compositor will send this event to indicate that it has sent all
        /// currently available connectors after the client binds to the global or
        /// when it updates the connector list, for example on hotplug, drm master
        /// change or when a leased connector becomes available again. It will
        /// similarly send this event to group wp_drm_lease_connector_v1.withdrawn
        /// events of connectors of this device.
        case done
        
        /// The Compositor Has Finished Using The Device
        /// 
        /// This event is sent in response to the release request and indicates
        /// that the compositor is done sending connector events.
        /// The compositor will destroy this object immediately after sending the
        /// event and it will become invalid. The client should release any
        /// resources associated with this device after receiving this event.
        case released
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.drmFd(fd: r.readFd())
            case 1:
                return Self.connector(id: connection.createProxy(type: WpDrmLeaseConnectorV1.self, version: version, id: r.readNewId()))
            case 2:
                return Self.done
            case 3:
                return Self.released
            default:
                fatalError("Unknown message")
            }
        }
    }
}
