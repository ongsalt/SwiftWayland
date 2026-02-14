import Foundation
import SwiftWayland

/// Offer To Replace The Contents Of The Primary Selection
/// 
/// The source side of a wp_primary_selection_offer, it provides a way to
/// describe the offered data and respond to requests to transfer the
/// requested contents of the primary selection clipboard.
public final class ZwpPrimarySelectionSourceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_primary_selection_source_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Add An Offered Mime Type
    /// 
    /// This request adds a mime type to the set of mime types advertised to
    /// targets. Can be called several times to offer multiple types.
    public func offer(mimeType: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.string(mimeType)
        ])
        connection.send(message: message)
    }
    
    /// Destroy The Primary Selection Source
    /// 
    /// Destroy the primary selection source.
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
        /// Send The Primary Selection Contents
        /// 
        /// Request for the current primary selection contents from the client.
        /// Send the specified mime type over the passed file descriptor, then
        /// close it.
        case send(mimeType: String, fd: FileHandle)
        
        /// Request For Primary Selection Contents Was Canceled
        /// 
        /// This primary selection source is no longer valid. The client should
        /// clean up and destroy this primary selection source.
        case cancelled
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.send(mimeType: r.readString(), fd: r.readFd())
            case 1:
                return Self.cancelled
            default:
                fatalError("Unknown message")
            }
        }
    }
}
