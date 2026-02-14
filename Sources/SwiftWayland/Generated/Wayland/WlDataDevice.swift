import Foundation

/// Data Transfer Device
/// 
/// There is one wl_data_device per seat which can be obtained
/// from the global wl_data_device_manager singleton.
/// A wl_data_device provides access to inter-client data transfer
/// mechanisms such as copy-and-paste and drag-and-drop.
public final class WlDataDevice: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_data_device"
    public var onEvent: (Event) -> Void = { _ in }

    /// Start Drag-And-Drop Operation
    /// 
    /// This request asks the compositor to start a drag-and-drop
    /// operation on behalf of the client.
    /// The source argument is the data source that provides the data
    /// for the eventual data transfer. If source is NULL, enter, leave
    /// and motion events are sent only to the client that initiated the
    /// drag and the client is expected to handle the data passing
    /// internally. If source is destroyed, the drag-and-drop session will be
    /// cancelled.
    /// The origin surface is the surface where the drag originates and
    /// the client must have an active implicit grab that matches the
    /// serial.
    /// The icon surface is an optional (can be NULL) surface that
    /// provides an icon to be moved around with the cursor.  Initially,
    /// the top-left corner of the icon surface is placed at the cursor
    /// hotspot, but subsequent wl_surface.offset requests can move the
    /// relative position. Attach requests must be confirmed with
    /// wl_surface.commit as usual. The icon surface is given the role of
    /// a drag-and-drop icon. If the icon surface already has another role,
    /// it raises a protocol error.
    /// The input region is ignored for wl_surfaces with the role of a
    /// drag-and-drop icon.
    /// The given source may not be used in any further set_selection or
    /// start_drag requests. Attempting to reuse a previously-used source
    /// may send a used_source error.
    /// 
    /// - Parameters:
    ///   - Source: data source for the eventual transfer
    ///   - Origin: surface where the drag originates
    ///   - Icon: drag-and-drop icon surface
    ///   - Serial: serial number of the implicit grab on the origin
    public func startDrag(source: WlDataSource, origin: WlSurface, icon: WlSurface, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.object(source),
            WaylandData.object(origin),
            WaylandData.object(icon),
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    /// Copy Data To The Selection
    /// 
    /// This request asks the compositor to set the selection
    /// to the data from the source on behalf of the client.
    /// To unset the selection, set the source to NULL.
    /// The given source may not be used in any further set_selection or
    /// start_drag requests. Attempting to reuse a previously-used source
    /// may send a used_source error.
    /// 
    /// - Parameters:
    ///   - Source: data source for the selection
    ///   - Serial: serial number of the event that triggered this request
    public func setSelection(source: WlDataSource, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(source),
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    /// Destroy Data Device
    /// 
    /// This request destroys the data device.
    /// 
    /// Available since version 2
    public consuming func release() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.release()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Given Wl_Surface Has Another Role
        case role = 0
        
        /// Source Has Already Been Used
        case usedSource = 1
    }
    
    public enum Event: WlEventEnum {
        /// Introduce A New Wl_Data_Offer
        /// 
        /// The data_offer event introduces a new wl_data_offer object,
        /// which will subsequently be used in either the
        /// data_device.enter event (for drag-and-drop) or the
        /// data_device.selection event (for selections).  Immediately
        /// following the data_device.data_offer event, the new data_offer
        /// object will send out data_offer.offer events to describe the
        /// mime types it offers.
        case dataOffer(id: WlDataOffer)
        
        /// Initiate Drag-And-Drop Session
        /// 
        /// This event is sent when an active drag-and-drop pointer enters
        /// a surface owned by the client.  The position of the pointer at
        /// enter time is provided by the x and y arguments, in surface-local
        /// coordinates.
        /// 
        /// - Parameters:
        ///   - Serial: serial number of the enter event
        ///   - Surface: client surface entered
        ///   - X: surface-local x coordinate
        ///   - Y: surface-local y coordinate
        ///   - Id: source data_offer object
        case enter(serial: UInt32, surface: WlSurface, x: Double, y: Double, id: WlDataOffer)
        
        /// End Drag-And-Drop Session
        /// 
        /// This event is sent when the drag-and-drop pointer leaves the
        /// surface and the session ends.  The client must destroy the
        /// wl_data_offer introduced at enter time at this point.
        case leave
        
        /// Drag-And-Drop Session Motion
        /// 
        /// This event is sent when the drag-and-drop pointer moves within
        /// the currently focused surface. The new position of the pointer
        /// is provided by the x and y arguments, in surface-local
        /// coordinates.
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        ///   - X: surface-local x coordinate
        ///   - Y: surface-local y coordinate
        case motion(time: UInt32, x: Double, y: Double)
        
        /// End Drag-And-Drop Session Successfully
        /// 
        /// The event is sent when a drag-and-drop operation is ended
        /// because the implicit grab is removed.
        /// The drag-and-drop destination is expected to honor the last action
        /// received through wl_data_offer.action, if the resulting action is
        /// "copy" or "move", the destination can still perform
        /// wl_data_offer.receive requests, and is expected to end all
        /// transfers with a wl_data_offer.finish request.
        /// If the resulting action is "ask", the action will not be considered
        /// final. The drag-and-drop destination is expected to perform one last
        /// wl_data_offer.set_actions request, or wl_data_offer.destroy in order
        /// to cancel the operation.
        case drop
        
        /// Advertise New Selection
        /// 
        /// The selection event is sent out to notify the client of a new
        /// wl_data_offer for the selection for this device.  The
        /// data_device.data_offer and the data_offer.offer events are
        /// sent out immediately before this event to introduce the data
        /// offer object.  The selection event is sent to a client
        /// immediately before receiving keyboard focus and when a new
        /// selection is set while the client has keyboard focus.  The
        /// data_offer is valid until a new data_offer or NULL is received
        /// or until the client loses keyboard focus.  Switching surface with
        /// keyboard focus within the same client doesn't mean a new selection
        /// will be sent.  The client must destroy the previous selection
        /// data_offer, if any, upon receiving this event.
        /// 
        /// - Parameters:
        ///   - Id: selection data_offer object
        case selection(id: WlDataOffer)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.dataOffer(id: connection.createProxy(type: WlDataOffer.self, version: version, id: r.readNewId()))
            case 1:
                return Self.enter(serial: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!, x: r.readFixed(), y: r.readFixed(), id: connection.get(as: WlDataOffer.self, id: r.readObjectId())!)
            case 2:
                return Self.leave
            case 3:
                return Self.motion(time: r.readUInt(), x: r.readFixed(), y: r.readFixed())
            case 4:
                return Self.drop
            case 5:
                return Self.selection(id: connection.get(as: WlDataOffer.self, id: r.readObjectId())!)
            default:
                fatalError("Unknown message")
            }
        }
    }
}
