import Foundation

/// Group Of Input Devices
/// 
/// A seat is a group of keyboards, pointer and touch devices. This
/// object is published as a global during start up, or when such a
/// device is hot plugged.  A seat typically has a pointer and
/// maintains a keyboard focus and a pointer focus.
public final class WlSeat: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_seat"
    public var onEvent: (Event) -> Void = { _ in }

    /// Return Pointer Object
    /// 
    /// The ID provided will be initialized to the wl_pointer interface
    /// for this seat.
    /// This request only takes effect if the seat has the pointer
    /// capability, or has had the pointer capability in the past.
    /// It is a protocol violation to issue this request on a seat that has
    /// never had the pointer capability. The missing_capability error will
    /// be sent in this case.
    public func getPointer() throws(WaylandProxyError) -> WlPointer {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlPointer.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Return Keyboard Object
    /// 
    /// The ID provided will be initialized to the wl_keyboard interface
    /// for this seat.
    /// This request only takes effect if the seat has the keyboard
    /// capability, or has had the keyboard capability in the past.
    /// It is a protocol violation to issue this request on a seat that has
    /// never had the keyboard capability. The missing_capability error will
    /// be sent in this case.
    public func getKeyboard() throws(WaylandProxyError) -> WlKeyboard {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlKeyboard.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Return Touch Object
    /// 
    /// The ID provided will be initialized to the wl_touch interface
    /// for this seat.
    /// This request only takes effect if the seat has the touch
    /// capability, or has had the touch capability in the past.
    /// It is a protocol violation to issue this request on a seat that has
    /// never had the touch capability. The missing_capability error will
    /// be sent in this case.
    public func getTouch() throws(WaylandProxyError) -> WlTouch {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlTouch.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Release The Seat Object
    /// 
    /// Using this request a client can tell the server that it is not going to
    /// use the seat object anymore.
    /// 
    /// Available since version 5
    public consuming func release() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 5 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 5) }
        let message = Message(objectId: self.id, opcode: 3, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.release()
    }
    
    /// Seat Capability Bitmask
    /// 
    /// This is a bitmask of capabilities this seat has; if a member is
    /// set, then it is present on the seat.
    public enum Capability: UInt32, WlEnum {
        /// The Seat Has Pointer Devices
        case pointer = 1
        
        /// The Seat Has One Or More Keyboards
        case keyboard = 2
        
        /// The Seat Has Touch Devices
        case touch = 4
    }
    
    /// Wl_Seat Error Values
    /// 
    /// These errors can be emitted in response to wl_seat requests.
    public enum Error: UInt32, WlEnum {
        /// Get_Pointer, Get_Keyboard Or Get_Touch Called On Seat Without The Matching Capability
        case missingCapability = 0
    }
    
    public enum Event: WlEventEnum {
        /// Seat Capabilities Changed
        /// 
        /// This is sent on binding to the seat global or whenever a seat gains
        /// or loses the pointer, keyboard or touch capabilities.
        /// The argument is a capability enum containing the complete set of
        /// capabilities this seat has.
        /// When the pointer capability is added, a client may create a
        /// wl_pointer object using the wl_seat.get_pointer request. This object
        /// will receive pointer events until the capability is removed in the
        /// future.
        /// When the pointer capability is removed, a client should destroy the
        /// wl_pointer objects associated with the seat where the capability was
        /// removed, using the wl_pointer.release request. No further pointer
        /// events will be received on these objects.
        /// In some compositors, if a seat regains the pointer capability and a
        /// client has a previously obtained wl_pointer object of version 4 or
        /// less, that object may start sending pointer events again. This
        /// behavior is considered a misinterpretation of the intended behavior
        /// and must not be relied upon by the client. wl_pointer objects of
        /// version 5 or later must not send events if created before the most
        /// recent event notifying the client of an added pointer capability.
        /// The above behavior also applies to wl_keyboard and wl_touch with the
        /// keyboard and touch capabilities, respectively.
        /// 
        /// - Parameters:
        ///   - Capabilities: capabilities of the seat
        case capabilities(capabilities: UInt32)
        
        /// Unique Identifier For This Seat
        /// 
        /// In a multi-seat configuration the seat name can be used by clients to
        /// help identify which physical devices the seat represents.
        /// The seat name is a UTF-8 string with no convention defined for its
        /// contents. Each name is unique among all wl_seat globals. The name is
        /// only guaranteed to be unique for the current compositor instance.
        /// The same seat names are used for all clients. Thus, the name can be
        /// shared across processes to refer to a specific wl_seat global.
        /// The name event is sent after binding to the seat global, and should be sent
        /// before announcing capabilities. This event only sent once per seat object,
        /// and the name does not change over the lifetime of the wl_seat global.
        /// Compositors may re-use the same seat name if the wl_seat global is
        /// destroyed and re-created later.
        /// 
        /// - Parameters:
        ///   - Name: seat identifier
        /// 
        /// Available since version 2
        case name(name: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.capabilities(capabilities: r.readUInt())
            case 1:
                return Self.name(name: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
