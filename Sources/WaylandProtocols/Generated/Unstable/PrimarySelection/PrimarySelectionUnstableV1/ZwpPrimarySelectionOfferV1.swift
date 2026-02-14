import Foundation
import SwiftWayland

/// Offer To Transfer Primary Selection Contents
/// 
/// A wp_primary_selection_offer represents an offer to transfer the contents
/// of the primary selection clipboard to the client. Similar to
/// wl_data_offer, the offer also describes the mime types that the data can
/// be converted to and provides the mechanisms for transferring the data
/// directly to the client.
public final class ZwpPrimarySelectionOfferV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_primary_selection_offer_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Request That The Data Is Transferred
    /// 
    /// To transfer the contents of the primary selection clipboard, the client
    /// issues this request and indicates the mime type that it wants to
    /// receive. The transfer happens through the passed file descriptor
    /// (typically created with the pipe system call). The source client writes
    /// the data in the mime type representation requested and then closes the
    /// file descriptor.
    /// The receiving client reads from the read end of the pipe until EOF and
    /// closes its end, at which point the transfer is complete.
    public func receive(mimeType: String, fd: FileHandle) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.string(mimeType),
            WaylandData.fd(fd)
        ])
        connection.send(message: message)
    }
    
    /// Destroy The Primary Selection Offer
    /// 
    /// Destroy the primary selection offer.
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
        /// Advertise Offered Mime Type
        /// 
        /// Sent immediately after creating announcing the
        /// wp_primary_selection_offer through
        /// wp_primary_selection_device.data_offer. One event is sent per offered
        /// mime type.
        case offer(mimeType: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.offer(mimeType: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
