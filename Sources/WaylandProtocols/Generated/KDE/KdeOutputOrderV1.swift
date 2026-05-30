import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Announce Order Of Outputs
/// 
/// Announce the order in which desktop environment components should be placed on outputs.
/// The compositor will send the list of outputs when the global is bound and whenever there is a change.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class KdeOutputOrderV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_output_order_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "output",
                    arguments: [
                    Argument(
                        name: "output_name",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [
                    ],
                ),
                ],
        )
    /// Destroy The Output Order Notifier.
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: KdeOutputOrderV1)
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
        /// Output Name
        /// 
        /// Specifies the output identified by their wl_output.name.
        case output(outputName: String)

        /// Done
        /// 
        /// Specifies that the output list is complete. On the next output event, a new list begins.
        case done

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.output(outputName: r.string())
            case 1:
                self = Self.done
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let KdeOutputOrderV1 = Protocol(
        name: "kde_output_order_v1",
        interfaces: [
            KdeOutputOrderV1.interface
        ]
    )

#endif