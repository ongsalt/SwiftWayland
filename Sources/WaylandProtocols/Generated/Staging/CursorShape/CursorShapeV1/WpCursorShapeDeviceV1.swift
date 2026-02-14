import Foundation
import SwiftWayland

/// Cursor Shape For A Device
/// 
/// This interface allows clients to set the cursor shape.
public final class WpCursorShapeDeviceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_cursor_shape_device_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Cursor Shape Device
    /// 
    /// Destroy the cursor shape device.
    /// The device cursor shape remains unchanged.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set Device Cursor To The Shape
    /// 
    /// Sets the device cursor to the specified shape. The compositor will
    /// change the cursor image based on the specified shape.
    /// The cursor actually changes only if the input device focus is one of
    /// the requesting client's surfaces. If any, the previous cursor image
    /// (surface or shape) is replaced.
    /// The "shape" argument must be a valid enum entry, otherwise the
    /// invalid_shape protocol error is raised.
    /// This is similar to the wl_pointer.set_cursor and
    /// zwp_tablet_tool_v2.set_cursor requests, but this request accepts a
    /// shape instead of contents in the form of a surface. Clients can mix
    /// set_cursor and set_shape requests.
    /// The serial parameter must match the latest wl_pointer.enter or
    /// zwp_tablet_tool_v2.proximity_in serial number sent to the client.
    /// Otherwise the request will be ignored.
    /// 
    /// - Parameters:
    ///   - Serial: serial number of the enter event
    public func setShape(serial: UInt32, shape: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.uint(serial),
            WaylandData.uint(shape)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Cursor Shapes
    /// 
    /// This enum describes cursor shapes.
    /// The names are taken from the CSS W3C specification:
    /// https://w3c.github.io/csswg-drafts/css-ui/#cursor
    /// with a few additions.
    /// Note that there are some groups of cursor shapes that are related:
    /// The first group is drag-and-drop cursors which are used to indicate
    /// the selected action during dnd operations. The second group is resize
    /// cursors which are used to indicate resizing and moving possibilities
    /// on window borders. It is recommended that the shapes in these groups
    /// should use visually compatible images and metaphors.
    public enum Shape: UInt32, WlEnum {
        /// Default Cursor
        case `default` = 1
        
        /// A Context Menu Is Available For The Object Under The Cursor
        case contextMenu = 2
        
        /// Help Is Available For The Object Under The Cursor
        case help = 3
        
        /// Pointer That Indicates A Link Or Another Interactive Element
        case pointer = 4
        
        /// Progress Indicator
        case progress = 5
        
        /// Program Is Busy, User Should Wait
        case wait = 6
        
        /// A Cell Or Set Of Cells May Be Selected
        case cell = 7
        
        /// Simple Crosshair
        case crosshair = 8
        
        /// Text May Be Selected
        case text = 9
        
        /// Vertical Text May Be Selected
        case verticalText = 10
        
        /// Drag-And-Drop: Alias Of/Shortcut To Something Is To Be Created
        case alias = 11
        
        /// Drag-And-Drop: Something Is To Be Copied
        case `copy` = 12
        
        /// Drag-And-Drop: Something Is To Be Moved
        case move = 13
        
        /// Drag-And-Drop: The Dragged Item Cannot Be Dropped At The Current Cursor Location
        case noDrop = 14
        
        /// Drag-And-Drop: The Requested Action Will Not Be Carried Out
        case notAllowed = 15
        
        /// Drag-And-Drop: Something Can Be Grabbed
        case grab = 16
        
        /// Drag-And-Drop: Something Is Being Grabbed
        case grabbing = 17
        
        /// Resizing: The East Border Is To Be Moved
        case eResize = 18
        
        /// Resizing: The North Border Is To Be Moved
        case nResize = 19
        
        /// Resizing: The North-East Corner Is To Be Moved
        case neResize = 20
        
        /// Resizing: The North-West Corner Is To Be Moved
        case nwResize = 21
        
        /// Resizing: The South Border Is To Be Moved
        case sResize = 22
        
        /// Resizing: The South-East Corner Is To Be Moved
        case seResize = 23
        
        /// Resizing: The South-West Corner Is To Be Moved
        case swResize = 24
        
        /// Resizing: The West Border Is To Be Moved
        case wResize = 25
        
        /// Resizing: The East And West Borders Are To Be Moved
        case ewResize = 26
        
        /// Resizing: The North And South Borders Are To Be Moved
        case nsResize = 27
        
        /// Resizing: The North-East And South-West Corners Are To Be Moved
        case neswResize = 28
        
        /// Resizing: The North-West And South-East Corners Are To Be Moved
        case nwseResize = 29
        
        /// Resizing: That The Item/Column Can Be Resized Horizontally
        case colResize = 30
        
        /// Resizing: That The Item/Row Can Be Resized Vertically
        case rowResize = 31
        
        /// Something Can Be Scrolled In Any Direction
        case allScroll = 32
        
        /// Something Can Be Zoomed In
        case zoomIn = 33
        
        /// Something Can Be Zoomed Out
        case zoomOut = 34
        
        /// Drag-And-Drop: The User Will Select Which Action Will Be Carried Out (Non-Css Value)
        case dndAsk = 35
        
        /// Resizing: Something Can Be Moved Or Resized In Any Direction (Non-Css Value)
        case allResize = 36
    }
    
    public enum Error: UInt32, WlEnum {
        /// The Specified Shape Value Is Invalid
        case invalidShape = 1
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
