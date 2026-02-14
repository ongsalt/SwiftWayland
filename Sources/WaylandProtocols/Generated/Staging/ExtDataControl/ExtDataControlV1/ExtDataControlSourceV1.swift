import Foundation
import SwiftWayland

/// Offer To Transfer Data
/// 
/// The ext_data_control_source object is the source side of a
/// ext_data_control_offer. It is created by the source client in a data
/// transfer and provides a way to describe the offered data and a way to
/// respond to requests to transfer the data.
public final class ExtDataControlSourceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_data_control_source_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Add An Offered Mime Type
    /// 
    /// This request adds a MIME type to the set of MIME types advertised to
    /// targets. Can be called several times to offer multiple types.
    /// Calling this after ext_data_control_device.set_selection is a protocol
    /// error.
    /// 
    /// - Parameters:
    ///   - MimeType: MIME type offered by the data source
    public func offer(mimeType: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.string(mimeType)
        ])
        connection.send(message: message)
    }
    
    /// Destroy This Source
    /// 
    /// Destroys the data source object.
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
    
    public enum Error: UInt32, WlEnum {
        /// Offer Sent After Ext_Data_Control_Device.Set_Selection
        case invalidOffer = 1
    }
    
    public enum Event: WlEventEnum {
        /// Send The Data
        /// 
        /// Request for data from the client. Send the data as the specified MIME
        /// type over the passed file descriptor, then close it.
        /// 
        /// - Parameters:
        ///   - MimeType: MIME type for the data
        ///   - Fd: file descriptor for the data
        case send(mimeType: String, fd: FileHandle)
        
        /// Selection Was Cancelled
        /// 
        /// This data source is no longer valid. The data source has been replaced
        /// by another data source.
        /// The client should clean up and destroy this data source.
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
