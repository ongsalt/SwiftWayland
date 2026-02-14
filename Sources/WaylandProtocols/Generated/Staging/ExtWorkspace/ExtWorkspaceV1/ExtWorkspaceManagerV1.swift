import Foundation
import SwiftWayland

/// List And Control Workspaces
/// 
/// Workspaces, also called virtual desktops, are groups of surfaces. A
/// compositor with a concept of workspaces may only show some such groups of
/// surfaces (those of 'active' workspaces) at a time. 'Activating' a
/// workspace is a request for the compositor to display that workspace's
/// surfaces as normal, whereas the compositor may hide or otherwise
/// de-emphasise surfaces that are associated only with 'inactive' workspaces.
/// Workspaces are grouped by which sets of outputs they correspond to, and
/// may contain surfaces only from those outputs. In this way, it is possible
/// for each output to have its own set of workspaces, or for all outputs (or
/// any other arbitrary grouping) to share workspaces. Compositors may
/// optionally conceptually arrange each group of workspaces in an
/// N-dimensional grid.
/// The purpose of this protocol is to enable the creation of taskbars and
/// docks by providing them with a list of workspaces and their properties,
/// and allowing them to activate and deactivate workspaces.
/// After a client binds the ext_workspace_manager_v1, each workspace will be
/// sent via the workspace event.
public final class ExtWorkspaceManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_workspace_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// All Requests About The Workspaces Have Been Sent
    /// 
    /// The client must send this request after it has finished sending other
    /// requests. The compositor must process a series of requests preceding a
    /// commit request atomically.
    /// This allows changes to the workspace properties to be seen as atomic,
    /// even if they happen via multiple events, and even if they involve
    /// multiple ext_workspace_handle_v1 objects, for example, deactivating one
    /// workspace and activating another.
    public func commit() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    /// Stop Sending Events
    /// 
    /// Indicates the client no longer wishes to receive events for new
    /// workspace groups. However the compositor may emit further workspace
    /// events, until the finished event is emitted. The compositor is expected
    /// to send the finished event eventually once the stop request has been processed.
    /// The client must not send any requests after this one, doing so will raise a wl_display
    /// invalid_object error.
    public func stop() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    public enum Event: WlEventEnum {
        /// A Workspace Group Has Been Created
        /// 
        /// This event is emitted whenever a new workspace group has been created.
        /// All initial details of the workspace group (outputs) will be
        /// sent immediately after this event via the corresponding events in
        /// ext_workspace_group_handle_v1 and ext_workspace_handle_v1.
        case workspaceGroup(workspaceGroup: ExtWorkspaceGroupHandleV1)
        
        /// Workspace Has Been Created
        /// 
        /// This event is emitted whenever a new workspace has been created.
        /// All initial details of the workspace (name, coordinates, state) will
        /// be sent immediately after this event via the corresponding events in
        /// ext_workspace_handle_v1.
        /// Workspaces start off unassigned to any workspace group.
        case workspace(workspace: ExtWorkspaceHandleV1)
        
        /// All Information About The Workspaces And Workspace Groups Has Been Sent
        /// 
        /// This event is sent after all changes in all workspaces and workspace groups have been
        /// sent.
        /// This allows changes to one or more ext_workspace_group_handle_v1
        /// properties and ext_workspace_handle_v1 properties
        /// to be seen as atomic, even if they happen via multiple events.
        /// In particular, an output moving from one workspace group to
        /// another sends an output_enter event and an output_leave event to the two
        /// ext_workspace_group_handle_v1 objects in question. The compositor sends
        /// the done event only after updating the output information in both
        /// workspace groups.
        case done
        
        /// The Compositor Has Finished With The Workspace_Manager
        /// 
        /// This event indicates that the compositor is done sending events to the
        /// ext_workspace_manager_v1. The server will destroy the object
        /// immediately after sending this request.
        case finished
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.workspaceGroup(workspaceGroup: connection.createProxy(type: ExtWorkspaceGroupHandleV1.self, version: version, id: r.readNewId()))
            case 1:
                return Self.workspace(workspace: connection.createProxy(type: ExtWorkspaceHandleV1.self, version: version, id: r.readNewId()))
            case 2:
                return Self.done
            case 3:
                return Self.finished
            default:
                fatalError("Unknown message")
            }
        }
    }
}
