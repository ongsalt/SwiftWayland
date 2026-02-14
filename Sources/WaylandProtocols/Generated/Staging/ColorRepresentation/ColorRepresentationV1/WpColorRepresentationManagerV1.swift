import Foundation
import SwiftWayland

/// Color Representation Manager Singleton
/// 
/// A singleton global interface used for getting color representation
/// extensions for wl_surface. The extension interfaces allow setting the
/// color representation of surfaces.
/// Compositors should never remove this global.
public final class WpColorRepresentationManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_representation_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Manager
    /// 
    /// Destroy the wp_color_representation_manager_v1 object. This does not
    /// affect any other objects in any way.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A Color Representation Interface For A Wl_Surface
    /// 
    /// If a wp_color_representation_surface_v1 object already exists for the
    /// given wl_surface, the protocol error surface_exists is raised.
    /// This creates a new color wp_color_representation_surface_v1 object for
    /// the given wl_surface.
    /// See the wp_color_representation_surface_v1 interface for more details.
    public func getSurface(surface: WlSurface) throws(WaylandProxyError) -> WpColorRepresentationSurfaceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpColorRepresentationSurfaceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Protocol Errors
    /// 
    /// 
    public enum Error: UInt32, WlEnum {
        /// Color Representation Surface Exists Already
        case surfaceExists = 1
    }
    
    public enum Event: WlEventEnum {
        /// Supported Alpha Modes
        /// 
        /// When this object is created, it shall immediately send this event once
        /// for each alpha mode the compositor supports.
        /// For the definition of the supported values, see the
        /// wp_color_representation_surface_v1::alpha_mode enum.
        /// 
        /// - Parameters:
        ///   - AlphaMode: supported alpha mode
        case supportedAlphaMode(alphaMode: UInt32)
        
        /// Supported Matrix Coefficients And Ranges
        /// 
        /// When this object is created, it shall immediately send this event once
        /// for each matrix coefficient and color range combination the compositor
        /// supports.
        /// For the definition of the supported values, see the
        /// wp_color_representation_surface_v1::coefficients and
        /// wp_color_representation_surface_v1::range enums.
        /// 
        /// - Parameters:
        ///   - Coefficients: supported matrix coefficients
        ///   - Range: full range flag
        case supportedCoefficientsAndRanges(coefficients: UInt32, range: UInt32)
        
        /// All Features Have Been Sent
        /// 
        /// This event is sent when all supported features have been sent.
        case done
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.supportedAlphaMode(alphaMode: r.readUInt())
            case 1:
                return Self.supportedCoefficientsAndRanges(coefficients: r.readUInt(), range: r.readUInt())
            case 2:
                return Self.done
            default:
                fatalError("Unknown message")
            }
        }
    }
}
