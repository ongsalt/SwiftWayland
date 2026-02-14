import Foundation
import SwiftWayland

/// A Leasable Drm Connector
/// 
/// Represents a DRM connector which is available for lease. These objects are
/// created via wp_drm_lease_device_v1.connector events, and should be passed
/// to lease requests via wp_drm_lease_request_v1.request_connector.
/// Immediately after the wp_drm_lease_connector_v1 object is created the
/// compositor will send a name, a description, a connector_id and a done
/// event. When the description is updated the compositor will send a
/// description event followed by a done event.
public final class WpDrmLeaseConnectorV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_drm_lease_connector_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy Connector
    /// 
    /// The client may send this request to indicate that it will not use this
    /// connector. Clients are encouraged to send this after receiving the
    /// "withdrawn" event so that the server can release the resources
    /// associated with this connector offer. Neither existing lease requests
    /// nor leases will be affected.
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
        /// Name
        /// 
        /// The compositor sends this event once the connector is created to
        /// indicate the name of this connector. This will not change for the
        /// duration of the Wayland session, but is not guaranteed to be consistent
        /// between sessions.
        /// If the compositor supports wl_output version 4 and this connector
        /// corresponds to a wl_output, the compositor should use the same name as
        /// for the wl_output.
        /// 
        /// - Parameters:
        ///   - Name: connector name
        case name(name: String)
        
        /// Description
        /// 
        /// The compositor sends this event once the connector is created to provide
        /// a human-readable description for this connector, which may be presented
        /// to the user. The compositor may send this event multiple times over the
        /// lifetime of this object to reflect changes in the description.
        /// 
        /// - Parameters:
        ///   - Description: connector description
        case description(description: String)
        
        /// Connector_Id
        /// 
        /// The compositor sends this event once the connector is created to
        /// indicate the DRM object ID which represents the underlying connector
        /// that is being offered. Note that the final lease may include additional
        /// object IDs, such as CRTCs and planes.
        /// 
        /// - Parameters:
        ///   - ConnectorId: DRM connector ID
        case connectorId(connectorId: UInt32)
        
        /// All Properties Have Been Sent
        /// 
        /// This event is sent after all properties of a connector have been sent.
        /// This allows changes to the properties to be seen as atomic even if they
        /// happen via multiple events.
        case done
        
        /// Lease Offer Withdrawn
        /// 
        /// Sent to indicate that the compositor will no longer honor requests for
        /// DRM leases which include this connector. The client may still issue a
        /// lease request including this connector, but the compositor will send
        /// wp_drm_lease_v1.finished without issuing a lease fd. Compositors are
        /// encouraged to send this event when they lose access to connector, for
        /// example when the connector is hot-unplugged, when the connector gets
        /// leased to a client or when the compositor loses DRM master.
        /// If a client holds a lease for the connector, the status of the lease
        /// remains the same. The client should destroy the object after receiving
        /// this event.
        case withdrawn
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.name(name: r.readString())
            case 1:
                return Self.description(description: r.readString())
            case 2:
                return Self.connectorId(connectorId: r.readUInt())
            case 3:
                return Self.done
            case 4:
                return Self.withdrawn
            default:
                fatalError("Unknown message")
            }
        }
    }
}
