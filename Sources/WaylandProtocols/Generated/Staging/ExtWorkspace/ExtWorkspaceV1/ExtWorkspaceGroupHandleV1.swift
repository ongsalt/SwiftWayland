import Foundation
import SwiftWayland

/// A Workspace Group Assigned To A Set Of Outputs
/// 
/// A ext_workspace_group_handle_v1 object represents a workspace group
/// that is assigned a set of outputs and contains a number of workspaces.
/// The set of outputs assigned to the workspace group is conveyed to the client via
/// output_enter and output_leave events, and its workspaces are conveyed with
/// workspace events.
/// For example, a compositor which has a set of workspaces for each output may
/// advertise a workspace group (and its workspaces) per output, whereas a compositor
/// where a workspace spans all outputs may advertise a single workspace group for all
/// outputs.
public final class ExtWorkspaceGroupHandleV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_workspace_group_handle_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create A New Workspace
    /// 
    /// Request that the compositor create a new workspace with the given name
    /// and assign it to this group.
    /// There is no guarantee that the compositor will create a new workspace,
    /// or that the created workspace will have the provided name.
    public func createWorkspace(workspace: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.string(workspace)
        ])
        connection.send(message: message)
    }
    
    /// Destroy The Ext_Workspace_Group_Handle_V1 Object
    /// 
    /// Destroys the ext_workspace_group_handle_v1 object.
    /// This request should be send either when the client does not want to
    /// use the workspace group object any more or after the removed event to finalize
    /// the destruction of the object.
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
    
    public enum GroupCapabilities: UInt32, WlEnum {
        /// Create_Workspace Request Is Available
        case createWorkspace = 1
    }
    
    public enum Event: WlEventEnum {
        /// Compositor Capabilities
        /// 
        /// This event advertises the capabilities supported by the compositor. If
        /// a capability isn't supported, clients should hide or disable the UI
        /// elements that expose this functionality. For instance, if the
        /// compositor doesn't advertise support for creating workspaces, a button
        /// triggering the create_workspace request should not be displayed.
        /// The compositor will ignore requests it doesn't support. For instance,
        /// a compositor which doesn't advertise support for creating workspaces will ignore
        /// create_workspace requests.
        /// Compositors must send this event once after creation of an
        /// ext_workspace_group_handle_v1. When the capabilities change, compositors
        /// must send this event again.
        /// 
        /// - Parameters:
        ///   - Capabilities: capabilities
        case capabilities(capabilities: UInt32)
        
        /// Output Assigned To Workspace Group
        /// 
        /// This event is emitted whenever an output is assigned to the workspace
        /// group or a new `wl_output` object is bound by the client, which was already
        /// assigned to this workspace_group.
        case outputEnter(output: WlOutput)
        
        /// Output Removed From Workspace Group
        /// 
        /// This event is emitted whenever an output is removed from the workspace
        /// group.
        case outputLeave(output: WlOutput)
        
        /// Workspace Added To Workspace Group
        /// 
        /// This event is emitted whenever a workspace is assigned to this group.
        /// A workspace may only ever be assigned to a single group at a single point
        /// in time, but can be re-assigned during it's lifetime.
        case workspaceEnter(workspace: ExtWorkspaceHandleV1)
        
        /// Workspace Removed From Workspace Group
        /// 
        /// This event is emitted whenever a workspace is removed from this group.
        case workspaceLeave(workspace: ExtWorkspaceHandleV1)
        
        /// This Workspace Group Has Been Removed
        /// 
        /// This event is send when the group associated with the ext_workspace_group_handle_v1
        /// has been removed. After sending this request the compositor will immediately consider
        /// the object inert. Any requests will be ignored except the destroy request.
        /// It is guaranteed there won't be any more events referencing this
        /// ext_workspace_group_handle_v1.
        /// The compositor must remove all workspaces belonging to a workspace group
        /// via a workspace_leave event before removing the workspace group.
        case removed
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.capabilities(capabilities: r.readUInt())
            case 1:
                return Self.outputEnter(output: connection.get(as: WlOutput.self, id: r.readObjectId())!)
            case 2:
                return Self.outputLeave(output: connection.get(as: WlOutput.self, id: r.readObjectId())!)
            case 3:
                return Self.workspaceEnter(workspace: connection.get(as: ExtWorkspaceHandleV1.self, id: r.readObjectId())!)
            case 4:
                return Self.workspaceLeave(workspace: connection.get(as: ExtWorkspaceHandleV1.self, id: r.readObjectId())!)
            case 5:
                return Self.removed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
