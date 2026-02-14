import Foundation

/// An Onscreen Surface
/// 
/// A surface is a rectangular area that may be displayed on zero
/// or more outputs, and shown any number of times at the compositor's
/// discretion. They can present wl_buffers, receive user input, and
/// define a local coordinate system.
/// The size of a surface (and relative positions on it) is described
/// in surface-local coordinates, which may differ from the buffer
/// coordinates of the pixel content, in case a buffer_transform
/// or a buffer_scale is used.
/// A surface without a "role" is fairly useless: a compositor does
/// not know where, when or how to present it. The role is the
/// purpose of a wl_surface. Examples of roles are a cursor for a
/// pointer (as set by wl_pointer.set_cursor), a drag icon
/// (wl_data_device.start_drag), a sub-surface
/// (wl_subcompositor.get_subsurface), and a window as defined by a
/// shell protocol (e.g. wl_shell.get_shell_surface).
/// A surface can have only one role at a time. Initially a
/// wl_surface does not have a role. Once a wl_surface is given a
/// role, it is set permanently for the whole lifetime of the
/// wl_surface object. Giving the current role again is allowed,
/// unless explicitly forbidden by the relevant interface
/// specification.
/// Surface roles are given by requests in other interfaces such as
/// wl_pointer.set_cursor. The request should explicitly mention
/// that this request gives a role to a wl_surface. Often, this
/// request also creates a new protocol object that represents the
/// role and adds additional functionality to wl_surface. When a
/// client wants to destroy a wl_surface, they must destroy this role
/// object before the wl_surface, otherwise a defunct_role_object error is
/// sent.
/// Destroying the role object does not remove the role from the
/// wl_surface, but it may stop the wl_surface from "playing the role".
/// For instance, if a wl_subsurface object is destroyed, the wl_surface
/// it was created for will be unmapped and forget its position and
/// z-order. It is allowed to create a wl_subsurface for the same
/// wl_surface again, but it is not allowed to use the wl_surface as
/// a cursor (cursor is a different role than sub-surface, and role
/// switching is not allowed).
public final class WlSurface: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_surface"
    public var onEvent: (Event) -> Void = { _ in }

    /// Delete Surface
    /// 
    /// Deletes the surface and invalidates its object ID.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set The Surface Contents
    /// 
    /// Set a buffer as the content of this surface.
    /// The new size of the surface is calculated based on the buffer
    /// size transformed by the inverse buffer_transform and the
    /// inverse buffer_scale. This means that at commit time the supplied
    /// buffer size must be an integer multiple of the buffer_scale. If
    /// that's not the case, an invalid_size error is sent.
    /// The x and y arguments specify the location of the new pending
    /// buffer's upper left corner, relative to the current buffer's upper
    /// left corner, in surface-local coordinates. In other words, the
    /// x and y, combined with the new surface size define in which
    /// directions the surface's size changes. Setting anything other than 0
    /// as x and y arguments is discouraged, and should instead be replaced
    /// with using the separate wl_surface.offset request.
    /// When the bound wl_surface version is 5 or higher, passing any
    /// non-zero x or y is a protocol violation, and will result in an
    /// 'invalid_offset' error being raised. The x and y arguments are ignored
    /// and do not change the pending state. To achieve equivalent semantics,
    /// use wl_surface.offset.
    /// Surface contents are double-buffered state, see wl_surface.commit.
    /// The initial surface contents are void; there is no content.
    /// wl_surface.attach assigns the given wl_buffer as the pending
    /// wl_buffer. wl_surface.commit makes the pending wl_buffer the new
    /// surface contents, and the size of the surface becomes the size
    /// calculated from the wl_buffer, as described above. After commit,
    /// there is no pending buffer until the next attach.
    /// Committing a pending wl_buffer allows the compositor to read the
    /// pixels in the wl_buffer. The compositor may access the pixels at
    /// any time after the wl_surface.commit request. When the compositor
    /// will not access the pixels anymore, it will send the
    /// wl_buffer.release event. Only after receiving wl_buffer.release,
    /// the client may reuse the wl_buffer. A wl_buffer that has been
    /// attached and then replaced by another attach instead of committed
    /// will not receive a release event, and is not used by the
    /// compositor.
    /// If a pending wl_buffer has been committed to more than one wl_surface,
    /// the delivery of wl_buffer.release events becomes undefined. A well
    /// behaved client should not rely on wl_buffer.release events in this
    /// case. Alternatively, a client could create multiple wl_buffer objects
    /// from the same backing storage or use a protocol extension providing
    /// per-commit release notifications.
    /// Destroying the wl_buffer after wl_buffer.release does not change
    /// the surface contents. Destroying the wl_buffer before wl_buffer.release
    /// is allowed as long as the underlying buffer storage isn't re-used (this
    /// can happen e.g. on client process termination). However, if the client
    /// destroys the wl_buffer before receiving the wl_buffer.release event and
    /// mutates the underlying buffer storage, the surface contents become
    /// undefined immediately.
    /// If wl_surface.attach is sent with a NULL wl_buffer, the
    /// following wl_surface.commit will remove the surface content.
    /// If a pending wl_buffer has been destroyed, the result is not specified.
    /// Many compositors are known to remove the surface content on the following
    /// wl_surface.commit, but this behaviour is not universal. Clients seeking to
    /// maximise compatibility should not destroy pending buffers and should
    /// ensure that they explicitly remove content from surfaces, even after
    /// destroying buffers.
    /// 
    /// - Parameters:
    ///   - Buffer: buffer of surface contents
    ///   - X: surface-local x coordinate
    ///   - Y: surface-local y coordinate
    public func attach(buffer: WlBuffer, x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(buffer),
            WaylandData.int(x),
            WaylandData.int(y)
        ])
        connection.send(message: message)
    }
    
    /// Mark Part Of The Surface Damaged
    /// 
    /// This request is used to describe the regions where the pending
    /// buffer is different from the current surface contents, and where
    /// the surface therefore needs to be repainted. The compositor
    /// ignores the parts of the damage that fall outside of the surface.
    /// Damage is double-buffered state, see wl_surface.commit.
    /// The damage rectangle is specified in surface-local coordinates,
    /// where x and y specify the upper left corner of the damage rectangle.
    /// The initial value for pending damage is empty: no damage.
    /// wl_surface.damage adds pending damage: the new pending damage
    /// is the union of old pending damage and the given rectangle.
    /// wl_surface.commit assigns pending damage as the current damage,
    /// and clears pending damage. The server will clear the current
    /// damage as it repaints the surface.
    /// Note! New clients should not use this request. Instead damage can be
    /// posted with wl_surface.damage_buffer which uses buffer coordinates
    /// instead of surface coordinates.
    /// 
    /// - Parameters:
    ///   - X: surface-local x coordinate
    ///   - Y: surface-local y coordinate
    ///   - Width: width of damage rectangle
    ///   - Height: height of damage rectangle
    public func damage(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.int(x),
            WaylandData.int(y),
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    /// Request A Frame Throttling Hint
    /// 
    /// Request a notification when it is a good time to start drawing a new
    /// frame, by creating a frame callback. This is useful for throttling
    /// redrawing operations, and driving animations.
    /// When a client is animating on a wl_surface, it can use the 'frame'
    /// request to get notified when it is a good time to draw and commit the
    /// next frame of animation. If the client commits an update earlier than
    /// that, it is likely that some updates will not make it to the display,
    /// and the client is wasting resources by drawing too often.
    /// The frame request will take effect on the next wl_surface.commit.
    /// The notification will only be posted for one frame unless
    /// requested again. For a wl_surface, the notifications are posted in
    /// the order the frame requests were committed.
    /// The server must send the notifications so that a client
    /// will not send excessive updates, while still allowing
    /// the highest possible update rate for clients that wait for the reply
    /// before drawing again. The server should give some time for the client
    /// to draw and commit after sending the frame callback events to let it
    /// hit the next output refresh.
    /// A server should avoid signaling the frame callbacks if the
    /// surface is not visible in any way, e.g. the surface is off-screen,
    /// or completely obscured by other opaque surfaces.
    /// The object returned by this request will be destroyed by the
    /// compositor after the callback is fired and as such the client must not
    /// attempt to use it after that point.
    /// The callback_data passed in the callback is the current time, in
    /// milliseconds, with an undefined base.
    public func frame(callback: @escaping (UInt32) -> Void) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let callback = connection.createCallback(fn: callback)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.newId(callback.id)
        ])
        connection.send(message: message)
    }
    
    /// Set Opaque Region
    /// 
    /// This request sets the region of the surface that contains
    /// opaque content.
    /// The opaque region is an optimization hint for the compositor
    /// that lets it optimize the redrawing of content behind opaque
    /// regions.  Setting an opaque region is not required for correct
    /// behaviour, but marking transparent content as opaque will result
    /// in repaint artifacts.
    /// The opaque region is specified in surface-local coordinates.
    /// The compositor ignores the parts of the opaque region that fall
    /// outside of the surface.
    /// Opaque region is double-buffered state, see wl_surface.commit.
    /// wl_surface.set_opaque_region changes the pending opaque region.
    /// wl_surface.commit copies the pending region to the current region.
    /// Otherwise, the pending and current regions are never changed.
    /// The initial value for an opaque region is empty. Setting the pending
    /// opaque region has copy semantics, and the wl_region object can be
    /// destroyed immediately. A NULL wl_region causes the pending opaque
    /// region to be set to empty.
    /// 
    /// - Parameters:
    ///   - Region: opaque region of the surface
    public func setOpaqueRegion(region: WlRegion) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.object(region)
        ])
        connection.send(message: message)
    }
    
    /// Set Input Region
    /// 
    /// This request sets the region of the surface that can receive
    /// pointer and touch events.
    /// Input events happening outside of this region will try the next
    /// surface in the server surface stack. The compositor ignores the
    /// parts of the input region that fall outside of the surface.
    /// The input region is specified in surface-local coordinates.
    /// Input region is double-buffered state, see wl_surface.commit.
    /// wl_surface.set_input_region changes the pending input region.
    /// wl_surface.commit copies the pending region to the current region.
    /// Otherwise the pending and current regions are never changed,
    /// except cursor and icon surfaces are special cases, see
    /// wl_pointer.set_cursor and wl_data_device.start_drag.
    /// The initial value for an input region is infinite. That means the
    /// whole surface will accept input. Setting the pending input region
    /// has copy semantics, and the wl_region object can be destroyed
    /// immediately. A NULL wl_region causes the input region to be set
    /// to infinite.
    /// 
    /// - Parameters:
    ///   - Region: input region of the surface
    public func setInputRegion(region: WlRegion) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.object(region)
        ])
        connection.send(message: message)
    }
    
    /// Commit Pending Surface State
    /// 
    /// Surface state (input, opaque, and damage regions, attached buffers,
    /// etc.) is double-buffered. Protocol requests modify the pending state,
    /// as opposed to the active state in use by the compositor.
    /// A commit request atomically creates a content update from the pending
    /// state, even if the pending state has not been touched. The content
    /// update is placed in a queue until it becomes active. After commit, the
    /// new pending state is as documented for each related request.
    /// When the content update is applied, the wl_buffer is applied before all
    /// other state. This means that all coordinates in double-buffered state
    /// are relative to the newly attached wl_buffers, except for
    /// wl_surface.attach itself. If there is no newly attached wl_buffer, the
    /// coordinates are relative to the previous content update.
    /// All requests that need a commit to become effective are documented
    /// to affect double-buffered state.
    /// Other interfaces may add further double-buffered surface state.
    public func commit() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [])
        connection.send(message: message)
    }
    
    /// Sets The Buffer Transformation
    /// 
    /// This request sets the transformation that the client has already applied
    /// to the content of the buffer. The accepted values for the transform
    /// parameter are the values for wl_output.transform.
    /// The compositor applies the inverse of this transformation whenever it
    /// uses the buffer contents.
    /// Buffer transform is double-buffered state, see wl_surface.commit.
    /// A newly created surface has its buffer transformation set to normal.
    /// wl_surface.set_buffer_transform changes the pending buffer
    /// transformation. wl_surface.commit copies the pending buffer
    /// transformation to the current one. Otherwise, the pending and current
    /// values are never changed.
    /// The purpose of this request is to allow clients to render content
    /// according to the output transform, thus permitting the compositor to
    /// use certain optimizations even if the display is rotated. Using
    /// hardware overlays and scanning out a client buffer for fullscreen
    /// surfaces are examples of such optimizations. Those optimizations are
    /// highly dependent on the compositor implementation, so the use of this
    /// request should be considered on a case-by-case basis.
    /// Note that if the transform value includes 90 or 270 degree rotation,
    /// the width of the buffer will become the surface height and the height
    /// of the buffer will become the surface width.
    /// If transform is not one of the values from the
    /// wl_output.transform enum the invalid_transform protocol error
    /// is raised.
    /// 
    /// - Parameters:
    ///   - Transform: transform for interpreting buffer contents
    /// 
    /// Available since version 2
    public func setBufferTransform(transform: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let message = Message(objectId: self.id, opcode: 7, contents: [
            WaylandData.int(transform)
        ])
        connection.send(message: message)
    }
    
    /// Sets The Buffer Scaling Factor
    /// 
    /// This request sets an optional scaling factor on how the compositor
    /// interprets the contents of the buffer attached to the window.
    /// Buffer scale is double-buffered state, see wl_surface.commit.
    /// A newly created surface has its buffer scale set to 1.
    /// wl_surface.set_buffer_scale changes the pending buffer scale.
    /// wl_surface.commit copies the pending buffer scale to the current one.
    /// Otherwise, the pending and current values are never changed.
    /// The purpose of this request is to allow clients to supply higher
    /// resolution buffer data for use on high resolution outputs. It is
    /// intended that you pick the same buffer scale as the scale of the
    /// output that the surface is displayed on. This means the compositor
    /// can avoid scaling when rendering the surface on that output.
    /// Note that if the scale is larger than 1, then you have to attach
    /// a buffer that is larger (by a factor of scale in each dimension)
    /// than the desired surface size.
    /// If scale is not greater than 0 the invalid_scale protocol error is
    /// raised.
    /// 
    /// - Parameters:
    ///   - Scale: scale for interpreting buffer contents
    /// 
    /// Available since version 3
    public func setBufferScale(scale: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            WaylandData.int(scale)
        ])
        connection.send(message: message)
    }
    
    /// Mark Part Of The Surface Damaged Using Buffer Coordinates
    /// 
    /// This request is used to describe the regions where the pending
    /// buffer is different from the current surface contents, and where
    /// the surface therefore needs to be repainted. The compositor
    /// ignores the parts of the damage that fall outside of the surface.
    /// Damage is double-buffered state, see wl_surface.commit.
    /// The damage rectangle is specified in buffer coordinates,
    /// where x and y specify the upper left corner of the damage rectangle.
    /// The initial value for pending damage is empty: no damage.
    /// wl_surface.damage_buffer adds pending damage: the new pending
    /// damage is the union of old pending damage and the given rectangle.
    /// wl_surface.commit assigns pending damage as the current damage,
    /// and clears pending damage. The server will clear the current
    /// damage as it repaints the surface.
    /// This request differs from wl_surface.damage in only one way - it
    /// takes damage in buffer coordinates instead of surface-local
    /// coordinates. While this generally is more intuitive than surface
    /// coordinates, it is especially desirable when using wp_viewport
    /// or when a drawing library (like EGL) is unaware of buffer scale
    /// and buffer transform.
    /// Note: Because buffer transformation changes and damage requests may
    /// be interleaved in the protocol stream, it is impossible to determine
    /// the actual mapping between surface and buffer damage until
    /// wl_surface.commit time. Therefore, compositors wishing to take both
    /// kinds of damage into account will have to accumulate damage from the
    /// two requests separately and only transform from one to the other
    /// after receiving the wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - X: buffer-local x coordinate
    ///   - Y: buffer-local y coordinate
    ///   - Width: width of damage rectangle
    ///   - Height: height of damage rectangle
    /// 
    /// Available since version 4
    public func damageBuffer(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        let message = Message(objectId: self.id, opcode: 9, contents: [
            WaylandData.int(x),
            WaylandData.int(y),
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    /// Set The Surface Contents Offset
    /// 
    /// The x and y arguments specify the location of the new pending
    /// buffer's upper left corner, relative to the current buffer's upper
    /// left corner, in surface-local coordinates. In other words, the
    /// x and y, combined with the new surface size define in which
    /// directions the surface's size changes.
    /// The exact semantics of wl_surface.offset are role-specific. Refer to
    /// the documentation of specific roles for more information.
    /// Surface location offset is double-buffered state, see
    /// wl_surface.commit.
    /// This request is semantically equivalent to and the replaces the x and y
    /// arguments in the wl_surface.attach request in wl_surface versions prior
    /// to 5. See wl_surface.attach for details.
    /// 
    /// - Parameters:
    ///   - X: surface-local x coordinate
    ///   - Y: surface-local y coordinate
    /// 
    /// Available since version 5
    public func offset(x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 5 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 5) }
        let message = Message(objectId: self.id, opcode: 10, contents: [
            WaylandData.int(x),
            WaylandData.int(y)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Wl_Surface Error Values
    /// 
    /// These errors can be emitted in response to wl_surface requests.
    public enum Error: UInt32, WlEnum {
        /// Buffer Scale Value Is Invalid
        case invalidScale = 0
        
        /// Buffer Transform Value Is Invalid
        case invalidTransform = 1
        
        /// Buffer Size Is Invalid
        case invalidSize = 2
        
        /// Buffer Offset Is Invalid
        case invalidOffset = 3
        
        /// Surface Was Destroyed Before Its Role Object
        case defunctRoleObject = 4
    }
    
    public enum Event: WlEventEnum {
        /// Surface Enters An Output
        /// 
        /// This is emitted whenever a surface's creation, movement, or resizing
        /// results in some part of it being within the scanout region of an
        /// output.
        /// Note that a surface may be overlapping with zero or more outputs.
        /// 
        /// - Parameters:
        ///   - Output: output entered by the surface
        case enter(output: WlOutput)
        
        /// Surface Leaves An Output
        /// 
        /// This is emitted whenever a surface's creation, movement, or resizing
        /// results in it no longer having any part of it within the scanout region
        /// of an output.
        /// Clients should not use the number of outputs the surface is on for frame
        /// throttling purposes. The surface might be hidden even if no leave event
        /// has been sent, and the compositor might expect new surface content
        /// updates even if no enter event has been sent. The frame event should be
        /// used instead.
        /// 
        /// - Parameters:
        ///   - Output: output left by the surface
        case leave(output: WlOutput)
        
        /// Preferred Buffer Scale For The Surface
        /// 
        /// This event indicates the preferred buffer scale for this surface. It is
        /// sent whenever the compositor's preference changes.
        /// Before receiving this event the preferred buffer scale for this surface
        /// is 1.
        /// It is intended that scaling aware clients use this event to scale their
        /// content and use wl_surface.set_buffer_scale to indicate the scale they
        /// have rendered with. This allows clients to supply a higher detail
        /// buffer.
        /// The compositor shall emit a scale value greater than 0.
        /// 
        /// - Parameters:
        ///   - Factor: preferred scaling factor
        /// 
        /// Available since version 6
        case preferredBufferScale(factor: Int32)
        
        /// Preferred Buffer Transform For The Surface
        /// 
        /// This event indicates the preferred buffer transform for this surface.
        /// It is sent whenever the compositor's preference changes.
        /// Before receiving this event the preferred buffer transform for this
        /// surface is normal.
        /// Applying this transformation to the surface buffer contents and using
        /// wl_surface.set_buffer_transform might allow the compositor to use the
        /// surface buffer more efficiently.
        /// 
        /// - Parameters:
        ///   - Transform: preferred transform
        /// 
        /// Available since version 6
        case preferredBufferTransform(transform: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.enter(output: connection.get(as: WlOutput.self, id: r.readObjectId())!)
            case 1:
                return Self.leave(output: connection.get(as: WlOutput.self, id: r.readObjectId())!)
            case 2:
                return Self.preferredBufferScale(factor: r.readInt())
            case 3:
                return Self.preferredBufferTransform(transform: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
