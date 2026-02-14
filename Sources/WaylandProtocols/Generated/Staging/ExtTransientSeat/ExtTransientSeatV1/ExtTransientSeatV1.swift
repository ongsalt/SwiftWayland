import Foundation
import SwiftWayland

/// Transient Seat Handle
/// 
/// When the transient seat handle is destroyed, the seat itself will also be
/// destroyed.
public final class ExtTransientSeatV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_transient_seat_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy Transient Seat
    /// 
    /// When the transient seat object is destroyed by the client, the
    /// associated seat created by the compositor is also destroyed.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// Transient Seat Is Ready
        /// 
        /// This event advertises the global name for the wl_seat to be used with
        /// wl_registry_bind.
        /// It is sent exactly once, immediately after the transient seat is created
        /// and the new "wl_seat" global is advertised, if and only if the creation
        /// of the transient seat was allowed.
        case ready(globalName: UInt32)
        
        /// Transient Seat Creation Denied
        /// 
        /// The event informs the client that the compositor denied its request to
        /// create a transient seat.
        /// It is sent exactly once, immediately after the transient seat object is
        /// created, if and only if the creation of the transient seat was denied.
        /// After receiving this event, the client should destroy the object.
        case denied
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.ready(globalName: r.readUInt())
            case 1:
                return Self.denied
            default:
                fatalError("Unknown message")
            }
        }
    }
}
