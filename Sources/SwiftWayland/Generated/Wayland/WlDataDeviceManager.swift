import Foundation

/// Data Transfer Interface
/// 
/// The wl_data_device_manager is a singleton global object that
/// provides access to inter-client data transfer mechanisms such as
/// copy-and-paste and drag-and-drop.  These mechanisms are tied to
/// a wl_seat and this interface lets a client get a wl_data_device
/// corresponding to a wl_seat.
/// Depending on the version bound, the objects created from the bound
/// wl_data_device_manager object will have different requirements for
/// functioning properly. See wl_data_source.set_actions,
/// wl_data_offer.accept and wl_data_offer.finish for details.
public final class WlDataDeviceManager: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_data_device_manager"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create A New Data Source
    /// 
    /// Create a new data source.
    public func createDataSource() throws(WaylandProxyError) -> WlDataSource {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlDataSource.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Create A New Data Device
    /// 
    /// Create a new data device for a given seat.
    /// 
    /// - Parameters:
    ///   - Seat: seat associated with the data device
    public func getDataDevice(seat: WlSeat) throws(WaylandProxyError) -> WlDataDevice {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlDataDevice.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(seat)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Drag And Drop Actions
    /// 
    /// This is a bitmask of the available/preferred actions in a
    /// drag-and-drop operation.
    /// In the compositor, the selected action is a result of matching the
    /// actions offered by the source and destination sides.  "action" events
    /// with a "none" action will be sent to both source and destination if
    /// there is no match. All further checks will effectively happen on
    /// (source actions ∩ destination actions).
    /// In addition, compositors may also pick different actions in
    /// reaction to key modifiers being pressed. One common design that
    /// is used in major toolkits (and the behavior recommended for
    /// compositors) is:
    /// - If no modifiers are pressed, the first match (in bit order)
    /// will be used.
    /// - Pressing Shift selects "move", if enabled in the mask.
    /// - Pressing Control selects "copy", if enabled in the mask.
    /// Behavior beyond that is considered implementation-dependent.
    /// Compositors may for example bind other modifiers (like Alt/Meta)
    /// or drags initiated with other buttons than BTN_LEFT to specific
    /// actions (e.g. "ask").
    /// 
    /// Available since version 3
    public enum DndAction: UInt32, WlEnum {
        /// No Action
        case `none` = 0
        
        /// Copy Action
        case `copy` = 1
        
        /// Move Action
        case move = 2
        
        /// Ask Action
        case ask = 4
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
