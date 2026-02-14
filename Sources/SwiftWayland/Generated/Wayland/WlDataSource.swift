import Foundation

/// Offer To Transfer Data
/// 
/// The wl_data_source object is the source side of a wl_data_offer.
/// It is created by the source client in a data transfer and
/// provides a way to describe the offered data and a way to respond
/// to requests to transfer the data.
public final class WlDataSource: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_data_source"
    public var onEvent: (Event) -> Void = { _ in }

    /// Add An Offered Mime Type
    /// 
    /// This request adds a mime type to the set of mime types
    /// advertised to targets.  Can be called several times to offer
    /// multiple types.
    /// 
    /// - Parameters:
    ///   - MimeType: mime type offered by the data source
    public func offer(mimeType: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.string(mimeType)
        ])
        connection.send(message: message)
    }
    
    /// Destroy The Data Source
    /// 
    /// Destroy the data source.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set The Available Drag-And-Drop Actions
    /// 
    /// Sets the actions that the source side client supports for this
    /// operation. This request may trigger wl_data_source.action and
    /// wl_data_offer.action events if the compositor needs to change the
    /// selected action.
    /// The dnd_actions argument must contain only values expressed in the
    /// wl_data_device_manager.dnd_actions enum, otherwise it will result
    /// in a protocol error.
    /// This request must be made once only, and can only be made on sources
    /// used in drag-and-drop, so it must be performed before
    /// wl_data_device.start_drag. Attempting to use the source other than
    /// for drag-and-drop will raise a protocol error.
    /// 
    /// - Parameters:
    ///   - DndActions: actions supported by the data source
    /// 
    /// Available since version 3
    public func setActions(dndActions: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.uint(dndActions)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Action Mask Contains Invalid Values
        case invalidActionMask = 0
        
        /// Source Doesn't Accept This Request
        case invalidSource = 1
    }
    
    public enum Event: WlEventEnum {
        /// A Target Accepts An Offered Mime Type
        /// 
        /// Sent when a target accepts pointer_focus or motion events.  If
        /// a target does not accept any of the offered types, type is NULL.
        /// Used for feedback during drag-and-drop.
        /// 
        /// - Parameters:
        ///   - MimeType: mime type accepted by the target
        case `target`(mimeType: String)
        
        /// Send The Data
        /// 
        /// Request for data from the client.  Send the data as the
        /// specified mime type over the passed file descriptor, then
        /// close it.
        /// 
        /// - Parameters:
        ///   - MimeType: mime type for the data
        ///   - Fd: file descriptor for the data
        case send(mimeType: String, fd: FileHandle)
        
        /// Selection Was Cancelled
        /// 
        /// This data source is no longer valid. There are several reasons why
        /// this could happen:
        /// - The data source has been replaced by another data source.
        /// - The drag-and-drop operation was performed, but the drop destination
        /// did not accept any of the mime types offered through
        /// wl_data_source.target.
        /// - The drag-and-drop operation was performed, but the drop destination
        /// did not select any of the actions present in the mask offered through
        /// wl_data_source.action.
        /// - The drag-and-drop operation was performed but didn't happen over a
        /// surface.
        /// - The compositor cancelled the drag-and-drop operation (e.g. compositor
        /// dependent timeouts to avoid stale drag-and-drop transfers).
        /// The client should clean up and destroy this data source.
        /// For objects of version 2 or older, wl_data_source.cancelled will
        /// only be emitted if the data source was replaced by another data
        /// source.
        case cancelled
        
        /// The Drag-And-Drop Operation Physically Finished
        /// 
        /// The user performed the drop action. This event does not indicate
        /// acceptance, wl_data_source.cancelled may still be emitted afterwards
        /// if the drop destination does not accept any mime type.
        /// However, this event might however not be received if the compositor
        /// cancelled the drag-and-drop operation before this event could happen.
        /// Note that the data_source may still be used in the future and should
        /// not be destroyed here.
        /// 
        /// Available since version 3
        case dndDropPerformed
        
        /// The Drag-And-Drop Operation Concluded
        /// 
        /// The drop destination finished interoperating with this data
        /// source, so the client is now free to destroy this data source and
        /// free all associated data.
        /// If the action used to perform the operation was "move", the
        /// source can now delete the transferred data.
        /// 
        /// Available since version 3
        case dndFinished
        
        /// Notify The Selected Action
        /// 
        /// This event indicates the action selected by the compositor after
        /// matching the source/destination side actions. Only one action (or
        /// none) will be offered here.
        /// This event can be emitted multiple times during the drag-and-drop
        /// operation, mainly in response to destination side changes through
        /// wl_data_offer.set_actions, and as the data device enters/leaves
        /// surfaces.
        /// It is only possible to receive this event after
        /// wl_data_source.dnd_drop_performed if the drag-and-drop operation
        /// ended in an "ask" action, in which case the final wl_data_source.action
        /// event will happen immediately before wl_data_source.dnd_finished.
        /// Compositors may also change the selected action on the fly, mainly
        /// in response to keyboard modifier changes during the drag-and-drop
        /// operation.
        /// The most recent action received is always the valid one. The chosen
        /// action may change alongside negotiation (e.g. an "ask" action can turn
        /// into a "move" operation), so the effects of the final action must
        /// always be applied in wl_data_offer.dnd_finished.
        /// Clients can trigger cursor surface changes from this point, so
        /// they reflect the current action.
        /// 
        /// - Parameters:
        ///   - DndAction: action selected by the compositor
        /// 
        /// Available since version 3
        case action(dndAction: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.`target`(mimeType: r.readString())
            case 1:
                return Self.send(mimeType: r.readString(), fd: r.readFd())
            case 2:
                return Self.cancelled
            case 3:
                return Self.dndDropPerformed
            case 4:
                return Self.dndFinished
            case 5:
                return Self.action(dndAction: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
