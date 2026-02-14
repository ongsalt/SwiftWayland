import Foundation

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
/// positioning a surface raises an invalid_positioner error.
public final class XdgPositioner: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_positioner"
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
    /// parent surface.
    /// When the xdg_positioner object is used to position a child surface, the
    /// anchor rectangle may not extend outside the window geometry of the
    /// positioned child's parent surface.
    /// If a negative size is set the invalid_input error is raised.
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
    
    /// Set Anchor Rectangle Anchor
    /// 
    /// Defines the anchor point for the anchor rectangle. The specified anchor
    /// is used derive an anchor point that the child surface will be
    /// positioned relative to. If a corner anchor is set (e.g. 'top_left' or
    /// 'bottom_right'), the anchor point will be at the specified corner;
    /// otherwise, the derived anchor point will be centered on the specified
    /// edge, or in the center of the anchor rectangle if no edge is specified.
    /// 
    /// - Parameters:
    ///   - Anchor: anchor
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
    /// the anchor point of the parent surface. If a corner gravity is
    /// specified (e.g. 'bottom_right' or 'top_left'), then the child surface
    /// will be placed towards the specified gravity; otherwise, the child
    /// surface will be centered over the anchor point on any axis that had no
    /// gravity specified. If the gravity is not in the ‘gravity’ enum, an
    /// invalid_input error is raised.
    /// 
    /// - Parameters:
    ///   - Gravity: gravity direction
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
    
    /// Continuously Reconstrain The Surface
    /// 
    /// When set reactive, the surface is reconstrained if the conditions used
    /// for constraining changed, e.g. the parent window moved.
    /// If the conditions changed and the popup was reconstrained, an
    /// xdg_popup.configure event is sent with updated geometry, followed by an
    /// xdg_surface.configure event.
    /// 
    /// Available since version 3
    public func setReactive() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 7, contents: [])
        connection.send(message: message)
    }
    
    /// 
    /// 
    /// Set the parent window geometry the compositor should use when
    /// positioning the popup. The compositor may use this information to
    /// determine the future state the popup should be constrained using. If
    /// this doesn't match the dimension of the parent the popup is eventually
    /// positioned against, the behavior is undefined.
    /// The arguments are given in the surface-local coordinate space.
    /// 
    /// - Parameters:
    ///   - ParentWidth: future window geometry width of parent
    ///   - ParentHeight: future window geometry height of parent
    /// 
    /// Available since version 3
    public func setParentSize(parentWidth: Int32, parentHeight: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            WaylandData.int(parentWidth),
            WaylandData.int(parentHeight)
        ])
        connection.send(message: message)
    }
    
    /// Set Parent Configure This Is A Response To
    /// 
    /// Set the serial of an xdg_surface.configure event this positioner will be
    /// used in response to. The compositor may use this information together
    /// with set_parent_size to determine what future state the popup should be
    /// constrained using.
    /// 
    /// - Parameters:
    ///   - Serial: serial of parent configure event
    /// 
    /// Available since version 3
    public func setParentConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 9, contents: [
            WaylandData.uint(serial)
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
        case `none` = 0
        
        case top = 1
        
        case bottom = 2
        
        case `left` = 3
        
        case `right` = 4
        
        case topLeft = 5
        
        case bottomLeft = 6
        
        case topRight = 7
        
        case bottomRight = 8
    }
    
    public enum Gravity: UInt32, WlEnum {
        case `none` = 0
        
        case top = 1
        
        case bottom = 2
        
        case `left` = 3
        
        case `right` = 4
        
        case topLeft = 5
        
        case bottomLeft = 6
        
        case topRight = 7
        
        case bottomRight = 8
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
