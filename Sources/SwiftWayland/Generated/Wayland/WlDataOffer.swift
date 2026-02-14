import Foundation

/// Offer To Transfer Data
/// 
/// A wl_data_offer represents a piece of data offered for transfer
/// by another client (the source client).  It is used by the
/// copy-and-paste and drag-and-drop mechanisms.  The offer
/// describes the different mime types that the data can be
/// converted to and provides the mechanism for transferring the
/// data directly from the source client.
public final class WlDataOffer: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_data_offer"
    public var onEvent: (Event) -> Void = { _ in }

    /// Accept One Of The Offered Mime Types
    /// 
    /// Indicate that the client can accept the given mime type, or
    /// NULL for not accepted.
    /// For objects of version 2 or older, this request is used by the
    /// client to give feedback whether the client can receive the given
    /// mime type, or NULL if none is accepted; the feedback does not
    /// determine whether the drag-and-drop operation succeeds or not.
    /// For objects of version 3 or newer, this request determines the
    /// final result of the drag-and-drop operation. If the end result
    /// is that no mime types were accepted, the drag-and-drop operation
    /// will be cancelled and the corresponding drag source will receive
    /// wl_data_source.cancelled. Clients may still use this event in
    /// conjunction with wl_data_source.action for feedback.
    /// 
    /// - Parameters:
    ///   - Serial: serial number of the accept request
    ///   - MimeType: mime type accepted by the client
    public func accept(serial: UInt32, mimeType: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.uint(serial),
            WaylandData.string(mimeType)
        ])
        connection.send(message: message)
    }
    
    /// Request That The Data Is Transferred
    /// 
    /// To transfer the offered data, the client issues this request
    /// and indicates the mime type it wants to receive.  The transfer
    /// happens through the passed file descriptor (typically created
    /// with the pipe system call).  The source client writes the data
    /// in the mime type representation requested and then closes the
    /// file descriptor.
    /// The receiving client reads from the read end of the pipe until
    /// EOF and then closes its end, at which point the transfer is
    /// complete.
    /// This request may happen multiple times for different mime types,
    /// both before and after wl_data_device.drop. Drag-and-drop destination
    /// clients may preemptively fetch data or examine it more closely to
    /// determine acceptance.
    /// 
    /// - Parameters:
    ///   - MimeType: mime type desired by receiver
    ///   - Fd: file descriptor for data transfer
    public func receive(mimeType: String, fd: FileHandle) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.string(mimeType),
            WaylandData.fd(fd)
        ])
        connection.send(message: message)
    }
    
    /// Destroy Data Offer
    /// 
    /// Destroy the data offer.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// The Offer Will No Longer Be Used
    /// 
    /// Notifies the compositor that the drag destination successfully
    /// finished the drag-and-drop operation.
    /// Upon receiving this request, the compositor will emit
    /// wl_data_source.dnd_finished on the drag source client.
    /// It is a client error to perform other requests than
    /// wl_data_offer.destroy after this one. It is also an error to perform
    /// this request after a NULL mime type has been set in
    /// wl_data_offer.accept or no action was received through
    /// wl_data_offer.action.
    /// If wl_data_offer.finish request is received for a non drag and drop
    /// operation, the invalid_finish protocol error is raised.
    /// 
    /// Available since version 3
    public func finish() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 3, contents: [])
        connection.send(message: message)
    }
    
    /// Set The Available/Preferred Drag-And-Drop Actions
    /// 
    /// Sets the actions that the destination side client supports for
    /// this operation. This request may trigger the emission of
    /// wl_data_source.action and wl_data_offer.action events if the compositor
    /// needs to change the selected action.
    /// This request can be called multiple times throughout the
    /// drag-and-drop operation, typically in response to wl_data_device.enter
    /// or wl_data_device.motion events.
    /// This request determines the final result of the drag-and-drop
    /// operation. If the end result is that no action is accepted,
    /// the drag source will receive wl_data_source.cancelled.
    /// The dnd_actions argument must contain only values expressed in the
    /// wl_data_device_manager.dnd_actions enum, and the preferred_action
    /// argument must only contain one of those values set, otherwise it
    /// will result in a protocol error.
    /// While managing an "ask" action, the destination drag-and-drop client
    /// may perform further wl_data_offer.receive requests, and is expected
    /// to perform one last wl_data_offer.set_actions request with a preferred
    /// action other than "ask" (and optionally wl_data_offer.accept) before
    /// requesting wl_data_offer.finish, in order to convey the action selected
    /// by the user. If the preferred action is not in the
    /// wl_data_offer.source_actions mask, an error will be raised.
    /// If the "ask" action is dismissed (e.g. user cancellation), the client
    /// is expected to perform wl_data_offer.destroy right away.
    /// This request can only be made on drag-and-drop offers, a protocol error
    /// will be raised otherwise.
    /// 
    /// - Parameters:
    ///   - DndActions: actions supported by the destination client
    ///   - PreferredAction: action preferred by the destination client
    /// 
    /// Available since version 3
    public func setActions(dndActions: UInt32, preferredAction: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.uint(dndActions),
            WaylandData.uint(preferredAction)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Finish Request Was Called Untimely
        case invalidFinish = 0
        
        /// Action Mask Contains Invalid Values
        case invalidActionMask = 1
        
        /// Action Argument Has An Invalid Value
        case invalidAction = 2
        
        /// Offer Doesn't Accept This Request
        case invalidOffer = 3
    }
    
    public enum Event: WlEventEnum {
        /// Advertise Offered Mime Type
        /// 
        /// Sent immediately after creating the wl_data_offer object.  One
        /// event per offered mime type.
        /// 
        /// - Parameters:
        ///   - MimeType: offered mime type
        case offer(mimeType: String)
        
        /// Notify The Source-Side Available Actions
        /// 
        /// This event indicates the actions offered by the data source. It
        /// will be sent immediately after creating the wl_data_offer object,
        /// or anytime the source side changes its offered actions through
        /// wl_data_source.set_actions.
        /// 
        /// - Parameters:
        ///   - SourceActions: actions offered by the data source
        /// 
        /// Available since version 3
        case sourceActions(sourceActions: UInt32)
        
        /// Notify The Selected Action
        /// 
        /// This event indicates the action selected by the compositor after
        /// matching the source/destination side actions. Only one action (or
        /// none) will be offered here.
        /// This event can be emitted multiple times during the drag-and-drop
        /// operation in response to destination side action changes through
        /// wl_data_offer.set_actions.
        /// This event will no longer be emitted after wl_data_device.drop
        /// happened on the drag-and-drop destination, the client must
        /// honor the last action received, or the last preferred one set
        /// through wl_data_offer.set_actions when handling an "ask" action.
        /// Compositors may also change the selected action on the fly, mainly
        /// in response to keyboard modifier changes during the drag-and-drop
        /// operation.
        /// The most recent action received is always the valid one. Prior to
        /// receiving wl_data_device.drop, the chosen action may change (e.g.
        /// due to keyboard modifiers being pressed). At the time of receiving
        /// wl_data_device.drop the drag-and-drop destination must honor the
        /// last action received.
        /// Action changes may still happen after wl_data_device.drop,
        /// especially on "ask" actions, where the drag-and-drop destination
        /// may choose another action afterwards. Action changes happening
        /// at this stage are always the result of inter-client negotiation, the
        /// compositor shall no longer be able to induce a different action.
        /// Upon "ask" actions, it is expected that the drag-and-drop destination
        /// may potentially choose a different action and/or mime type,
        /// based on wl_data_offer.source_actions and finally chosen by the
        /// user (e.g. popping up a menu with the available options). The
        /// final wl_data_offer.set_actions and wl_data_offer.accept requests
        /// must happen before the call to wl_data_offer.finish.
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
                return Self.offer(mimeType: r.readString())
            case 1:
                return Self.sourceActions(sourceActions: r.readUInt())
            case 2:
                return Self.action(dndAction: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
