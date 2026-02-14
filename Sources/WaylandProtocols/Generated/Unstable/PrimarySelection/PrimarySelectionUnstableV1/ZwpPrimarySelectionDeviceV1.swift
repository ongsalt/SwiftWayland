import Foundation
import SwiftWayland


public final class ZwpPrimarySelectionDeviceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_primary_selection_device_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Set The Primary Selection
    /// 
    /// Replaces the current selection. The previous owner of the primary
    /// selection will receive a wp_primary_selection_source.cancelled event.
    /// To unset the selection, set the source to NULL.
    /// 
    /// - Parameters:
    ///   - Serial: serial of the event that triggered this request
    public func setSelection(source: ZwpPrimarySelectionSourceV1, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.object(source),
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    /// Destroy The Primary Selection Device
    /// 
    /// Destroy the primary selection device.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// Introduce A New Wp_Primary_Selection_Offer
        /// 
        /// Introduces a new wp_primary_selection_offer object that may be used
        /// to receive the current primary selection. Immediately following this
        /// event, the new wp_primary_selection_offer object will send
        /// wp_primary_selection_offer.offer events to describe the offered mime
        /// types.
        case dataOffer(offer: ZwpPrimarySelectionOfferV1)
        
        /// Advertise A New Primary Selection
        /// 
        /// The wp_primary_selection_device.selection event is sent to notify the
        /// client of a new primary selection. This event is sent after the
        /// wp_primary_selection.data_offer event introducing this object, and after
        /// the offer has announced its mimetypes through
        /// wp_primary_selection_offer.offer.
        /// The data_offer is valid until a new offer or NULL is received
        /// or until the client loses keyboard focus. The client must destroy the
        /// previous selection data_offer, if any, upon receiving this event.
        case selection(id: ZwpPrimarySelectionOfferV1)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.dataOffer(offer: connection.createProxy(type: ZwpPrimarySelectionOfferV1.self, version: version, id: r.readNewId()))
            case 1:
                return Self.selection(id: connection.get(as: ZwpPrimarySelectionOfferV1.self, id: r.readObjectId())!)
            default:
                fatalError("Unknown message")
            }
        }
    }
}
