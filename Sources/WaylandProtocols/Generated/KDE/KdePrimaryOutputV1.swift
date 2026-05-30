import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Expose Which Is The Primary Display
/// 
/// Protocol for telling which is the primary display among the selection
/// of enabled outputs.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class KdePrimaryOutputV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_primary_output_v1",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 2
                ),
                ],
            events: [
                Message(
                    name: "primary_output",
                    arguments: [
                    Argument(
                        name: "output_name",
                        type: .string,
                    ),
                    ],
                ),
                ],
        )
    /// Destroy The Primary Output Notifier.
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdePrimaryOutputV1Protocol)
    }
    
    var destructor: Destructor? = .destroy

    enum Destructor {
        case destroy
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .destroy: try? self.destroy()
                case nil: break
            }
        }
    }

    public enum Event: Decodable {
        /// Provide The Current Primary Output's Name
        /// 
        /// Specifies which output is the primary one identified by their uuid. See kde_output_device_v2 uuid event for more information about it.
        case primaryOutput(outputName: String)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.primaryOutput(outputName: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let KdePrimaryOutputV1Protocol = Protocol(
        name: "kde_primary_output_v1",
        interfaces: [
            KdePrimaryOutputV1.interface
        ]
    )

#endif