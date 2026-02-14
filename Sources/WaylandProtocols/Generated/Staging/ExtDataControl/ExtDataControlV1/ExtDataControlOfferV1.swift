import Foundation
import SwiftWayland

/// Offer To Transfer Data
/// 
/// A ext_data_control_offer represents a piece of data offered for transfer
/// by another client (the source client). The offer describes the different
/// MIME types that the data can be converted to and provides the mechanism
/// for transferring the data directly from the source client.
public final class ExtDataControlOfferV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_data_control_offer_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Request That The Data Is Transferred
    /// 
    /// To transfer the offered data, the client issues this request and
    /// indicates the MIME type it wants to receive. The transfer happens
    /// through the passed file descriptor (typically created with the pipe
    /// system call). The source client writes the data in the MIME type
    /// representation requested and then closes the file descriptor.
    /// The receiving client reads from the read end of the pipe until EOF and
    /// then closes its end, at which point the transfer is complete.
    /// This request may happen multiple times for different MIME types.
    /// 
    /// - Parameters:
    ///   - MimeType: MIME type desired by receiver
    ///   - Fd: file descriptor for data transfer
    public func receive(mimeType: String, fd: FileHandle) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.string(mimeType),
            WaylandData.fd(fd)
        ])
        connection.send(message: message)
    }
    
    /// Destroy This Offer
    /// 
    /// Destroys the data offer object.
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
        /// Sent immediately after creating the ext_data_control_offer object.
        /// One event per offered MIME type.
        /// 
        /// - Parameters:
        ///   - MimeType: offered MIME type
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
