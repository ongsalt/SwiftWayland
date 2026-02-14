import Foundation
import SwiftWayland

/// Manage A Data Device For A Seat
/// 
/// This interface allows a client to manage a seat's selection.
/// When the seat is destroyed, this object becomes inert.
public final class ExtDataControlDeviceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_data_control_device_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Copy Data To The Selection
    /// 
    /// This request asks the compositor to set the selection to the data from
    /// the source on behalf of the client.
    /// The given source may not be used in any further set_selection or
    /// set_primary_selection requests. Attempting to use a previously used
    /// source triggers the used_source protocol error.
    /// To unset the selection, set the source to NULL.
    public func setSelection(source: ExtDataControlSourceV1) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.object(source)
        ])
        connection.send(message: message)
    }
    
    /// Destroy This Data Device
    /// 
    /// Destroys the data device object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Copy Data To The Primary Selection
    /// 
    /// This request asks the compositor to set the primary selection to the
    /// data from the source on behalf of the client.
    /// The given source may not be used in any further set_selection or
    /// set_primary_selection requests. Attempting to use a previously used
    /// source triggers the used_source protocol error.
    /// To unset the primary selection, set the source to NULL.
    /// The compositor will ignore this request if it does not support primary
    /// selection.
    public func setPrimarySelection(source: ExtDataControlSourceV1) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.object(source)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Source Given To Set_Selection Or Set_Primary_Selection Was Already Used Before
        case usedSource = 1
    }
    
    public enum Event: WlEventEnum {
        /// Introduce A New Ext_Data_Control_Offer
        /// 
        /// The data_offer event introduces a new ext_data_control_offer object,
        /// which will subsequently be used in either the
        /// ext_data_control_device.selection event (for the regular clipboard
        /// selections) or the ext_data_control_device.primary_selection event (for
        /// the primary clipboard selections). Immediately following the
        /// ext_data_control_device.data_offer event, the new data_offer object
        /// will send out ext_data_control_offer.offer events to describe the MIME
        /// types it offers.
        case dataOffer(id: ExtDataControlOfferV1)
        
        /// Advertise New Selection
        /// 
        /// The selection event is sent out to notify the client of a new
        /// ext_data_control_offer for the selection for this device. The
        /// ext_data_control_device.data_offer and the ext_data_control_offer.offer
        /// events are sent out immediately before this event to introduce the data
        /// offer object. The selection event is sent to a client when a new
        /// selection is set. The ext_data_control_offer is valid until a new
        /// ext_data_control_offer or NULL is received. The client must destroy the
        /// previous selection ext_data_control_offer, if any, upon receiving this
        /// event. Regardless, the previous selection will be ignored once a new
        /// selection ext_data_control_offer is received.
        /// The first selection event is sent upon binding the
        /// ext_data_control_device object.
        case selection(id: ExtDataControlOfferV1)
        
        /// This Data Control Is No Longer Valid
        /// 
        /// This data control object is no longer valid and should be destroyed by
        /// the client.
        case finished
        
        /// Advertise New Primary Selection
        /// 
        /// The primary_selection event is sent out to notify the client of a new
        /// ext_data_control_offer for the primary selection for this device. The
        /// ext_data_control_device.data_offer and the ext_data_control_offer.offer
        /// events are sent out immediately before this event to introduce the data
        /// offer object. The primary_selection event is sent to a client when a
        /// new primary selection is set. The ext_data_control_offer is valid until
        /// a new ext_data_control_offer or NULL is received. The client must
        /// destroy the previous primary selection ext_data_control_offer, if any,
        /// upon receiving this event. Regardless, the previous primary selection
        /// will be ignored once a new primary selection ext_data_control_offer is
        /// received.
        /// If the compositor supports primary selection, the first
        /// primary_selection event is sent upon binding the
        /// ext_data_control_device object.
        case primarySelection(id: ExtDataControlOfferV1)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.dataOffer(id: connection.createProxy(type: ExtDataControlOfferV1.self, version: version, id: r.readNewId()))
            case 1:
                return Self.selection(id: connection.get(as: ExtDataControlOfferV1.self, id: r.readObjectId())!)
            case 2:
                return Self.finished
            case 3:
                return Self.primarySelection(id: connection.get(as: ExtDataControlOfferV1.self, id: r.readObjectId())!)
            default:
                fatalError("Unknown message")
            }
        }
    }
}
