import Foundation
import SwiftWayland

/// Child Surface Positioner
/// 
/// The xdg_positioner provides a collection of rules for the placement of a
/// child surface relative to a parent surface. Rules can be defined to ensure
/// the child surface remains within the visible area's borders, and to
/// specify how the child surface changes its position, such as sliding along
/// an axis, or flipping around a rectangle. These positioner-created rules are
/// constrained by the requirement that a child surface must intersect with or
/// be at least partially adjacent to its parent surface.
/// See the various requests for details about possible rules.
/// At the time of the request, the compositor makes a copy of the rules
/// specified by the xdg_positioner. Thus, after the request is complete the
/// xdg_positioner object can be destroyed or reused; further changes to the
/// object will have no effect on previous usages.
/// For an xdg_positioner object to be considered complete, it must have a
/// non-zero size set by set_size, and a non-zero anchor rectangle set by
/// set_anchor_rect. Passing an incomplete xdg_positioner object when
/// positioning a surface raises an error.
public final class ZxdgPositionerV6: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_positioner_v6"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Xdg_Positioner Object
    /// 
    /// Notify the compositor that the xdg_positioner will no longer be used.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set The Size Of The To-Be Positioned Rectangle
    /// 
    /// Set the size of the surface that is to be positioned with the positioner
    /// object. The size is in surface-local coordinates and corresponds to the
    /// window geometry. See xdg_surface.set_window_geometry.
    /// If a zero or negative size is set the invalid_input error is raised.
    /// 
    /// - Parameters:
    ///   - Width: width of positioned rectangle
    ///   - Height: height of positioned rectangle
    public func setSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    /// Set The Anchor Rectangle Within The Parent Surface
    /// 
    /// Specify the anchor rectangle within the parent surface that the child
    /// surface will be placed relative to. The rectangle is relative to the
    /// window geometry as defined by xdg_surface.set_window_geometry of the
    /// parent surface. The rectangle must be at least 1x1 large.
    /// When the xdg_positioner object is used to position a child surface, the
    /// anchor rectangle may not extend outside the window geometry of the
    /// positioned child's parent surface.
    /// If a zero or negative size is set the invalid_input error is raised.
    /// 
    /// - Parameters:
    ///   - X: x position of anchor rectangle
    ///   - Y: y position of anchor rectangle
    ///   - Width: width of anchor rectangle
    ///   - Height: height of anchor rectangle
    public func setAnchorRect(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.int(x),
            WaylandData.int(y),
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    /// Set Anchor Rectangle Anchor Edges
    /// 
    /// Defines a set of edges for the anchor rectangle. These are used to
    /// derive an anchor point that the child surface will be positioned
    /// relative to. If two orthogonal edges are specified (e.g. 'top' and
    /// 'left'), then the anchor point will be the intersection of the edges
    /// (e.g. the top left position of the rectangle); otherwise, the derived
    /// anchor point will be centered on the specified edge, or in the center of
    /// the anchor rectangle if no edge is specified.
    /// If two parallel anchor edges are specified (e.g. 'left' and 'right'),
    /// the invalid_input error is raised.
    /// 
    /// - Parameters:
    ///   - Anchor: bit mask of anchor edges
    public func setAnchor(anchor: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.uint(anchor)
        ])
        connection.send(message: message)
    }
    
    /// Set Child Surface Gravity
    /// 
    /// Defines in what direction a surface should be positioned, relative to
    /// the anchor point of the parent surface. If two orthogonal gravities are
    /// specified (e.g. 'bottom' and 'right'), then the child surface will be
    /// placed in the specified direction; otherwise, the child surface will be
    /// centered over the anchor point on any axis that had no gravity
    /// specified.
    /// If two parallel gravities are specified (e.g. 'left' and 'right'), the
    /// invalid_input error is raised.
    /// 
    /// - Parameters:
    ///   - Gravity: bit mask of gravity directions
    public func setGravity(gravity: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.uint(gravity)
        ])
        connection.send(message: message)
    }
    
    /// Set The Adjustment To Be Done When Constrained
    /// 
    /// Specify how the window should be positioned if the originally intended
    /// position caused the surface to be constrained, meaning at least
    /// partially outside positioning boundaries set by the compositor. The
    /// adjustment is set by constructing a bitmask describing the adjustment to
    /// be made when the surface is constrained on that axis.
    /// If no bit for one axis is set, the compositor will assume that the child
    /// surface should not change its position on that axis when constrained.
    /// If more than one bit for one axis is set, the order of how adjustments
    /// are applied is specified in the corresponding adjustment descriptions.
    /// The default adjustment is none.
    /// 
    /// - Parameters:
    ///   - ConstraintAdjustment: bit mask of constraint adjustments
    public func setConstraintAdjustment(constraintAdjustment: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.uint(constraintAdjustment)
        ])
        connection.send(message: message)
    }
    
    /// Set Surface Position Offset
    /// 
    /// Specify the surface position offset relative to the position of the
    /// anchor on the anchor rectangle and the anchor on the surface. For
    /// example if the anchor of the anchor rectangle is at (x, y), the surface
    /// has the gravity bottom|right, and the offset is (ox, oy), the calculated
    /// surface position will be (x + ox, y + oy). The offset position of the
    /// surface is the one used for constraint testing. See
    /// set_constraint_adjustment.
    /// An example use case is placing a popup menu on top of a user interface
    /// element, while aligning the user interface element of the parent surface
    /// with some user interface element placed somewhere in the popup surface.
    /// 
    /// - Parameters:
    ///   - X: surface position x offset
    ///   - Y: surface position y offset
    public func setOffset(x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            WaylandData.int(x),
            WaylandData.int(y)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Invalid Input Provided
        case invalidInput = 0
    }
    
    public enum Anchor: UInt32, WlEnum {
        /// The Center Of The Anchor Rectangle
        case `none` = 0
        
        /// The Top Edge Of The Anchor Rectangle
        case top = 1
        
        /// The Bottom Edge Of The Anchor Rectangle
        case bottom = 2
        
        /// The Left Edge Of The Anchor Rectangle
        case `left` = 4
        
        /// The Right Edge Of The Anchor Rectangle
        case `right` = 8
    }
    
    public enum Gravity: UInt32, WlEnum {
        /// Center Over The Anchor Edge
        case `none` = 0
        
        /// Position Above The Anchor Edge
        case top = 1
        
        /// Position Below The Anchor Edge
        case bottom = 2
        
        /// Position To The Left Of The Anchor Edge
        case `left` = 4
        
        /// Position To The Right Of The Anchor Edge
        case `right` = 8
    }
    
    /// Constraint Adjustments
    /// 
    /// The constraint adjustment value define ways the compositor will adjust
    /// the position of the surface, if the unadjusted position would result
    /// in the surface being partly constrained.
    /// Whether a surface is considered 'constrained' is left to the compositor
    /// to determine. For example, the surface may be partly outside the
    /// compositor's defined 'work area', thus necessitating the child surface's
    /// position be adjusted until it is entirely inside the work area.
    /// The adjustments can be combined, according to a defined precedence: 1)
    /// Flip, 2) Slide, 3) Resize.
    public enum ConstraintAdjustment: UInt32, WlEnum {
        case `none` = 0
        
        case slideX = 1
        
        case slideY = 2
        
        case flipX = 4
        
        case flipY = 8
        
        case resizeX = 16
        
        case resizeY = 32
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
