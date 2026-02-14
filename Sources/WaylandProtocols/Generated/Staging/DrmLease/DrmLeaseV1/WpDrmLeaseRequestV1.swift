import Foundation
import SwiftWayland

/// Drm Lease Request
/// 
/// A client that wishes to lease DRM resources will attach the list of
/// connectors advertised with wp_drm_lease_device_v1.connector that they
/// wish to lease, then use wp_drm_lease_request_v1.submit to submit the
/// request.
public final class WpDrmLeaseRequestV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_drm_lease_request_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Request A Connector For This Lease
    /// 
    /// Indicates that the client would like to lease the given connector.
    /// This is only used as a suggestion, the compositor may choose to
    /// include any resources in the lease it issues, or change the set of
    /// leased resources at any time. Compositors are however encouraged to
    /// include the requested connector and other resources necessary
    /// to drive the connected output in the lease.
    /// Requesting a connector that was created from a different lease device
    /// than this lease request raises the wrong_device error. Requesting a
    /// connector twice will raise the duplicate_connector error.
    public func requestConnector(connector: WpDrmLeaseConnectorV1) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.object(connector)
        ])
        connection.send(message: message)
    }
    
    /// Submit The Lease Request
    /// 
    /// Submits the lease request and creates a new wp_drm_lease_v1 object.
    /// After calling submit the compositor will immediately destroy this
    /// object, issuing any more requests will cause a wl_display error.
    /// The compositor doesn't make any guarantees about the events of the
    /// lease object, clients cannot expect an immediate response.
    /// Not requesting any connectors before submitting the lease request
    /// will raise the empty_lease error.
    public consuming func submit() throws(WaylandProxyError) -> WpDrmLeaseV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpDrmLeaseV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        /// Requested A Connector From A Different Lease Device
        case wrongDevice = 0
        
        /// Requested A Connector Twice
        case duplicateConnector = 1
        
        /// Requested A Lease Without Requesting A Connector
        case emptyLease = 2
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
