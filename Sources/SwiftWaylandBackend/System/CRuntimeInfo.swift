import CWayland
import SwiftWaylandCommon

public final class CRuntimeInfo {
    // trustmebro
    public nonisolated(unsafe) static var shared: CRuntimeInfo = CRuntimeInfo()

    // why did i do this
    var protocolMap: [String: UnsafeMutableBufferPointer<wl_interface>] = [:]
    // this is used in wl_proxy_create, wl_proxy_marshal_constructor_versioned (array ver. tho)
    public private(set) var interfaces: [String: UnsafePointer<wl_interface>] = [:]

    // TODO: interfaces look up

    public func addIfNotExists(protocol p: Protocol) -> UnsafeBufferPointer<wl_interface> {
        if let existed = protocolMap[p.name] {
            return UnsafeBufferPointer(existed)
        }

        return add(protocol: p)
    }

    public func add(protocol p: Protocol) -> UnsafeBufferPointer<wl_interface> {
        let pInterfaces = UnsafeMutableBufferPointer<wl_interface>.allocate(
            capacity: p.interfaces.count)
        // now we have stable pointer to `wl_interface`s in a protocol

        // next we build a `types` array which is just [argument types] for each request and event
        // var typeIndexs: [Int] = []

        for (index, interface) in p.interfaces.enumerated() {
            let pMessages = UnsafeMutableBufferPointer<wl_message>.allocate(
                capacity: interface.requests.count + interface.events.count)
            for (index, message) in (interface.requests + interface.events).enumerated() {
                var typeArray: [UnsafePointer<wl_interface>?] = []
                for arg in message.arguments {
                    if arg.type != .object && arg.type != .newId {
                        continue
                    }

                    guard let name = arg.interface else {
                        // dynamic newId
                        continue
                    }

                    let index = p.interfaces.firstIndex { $0.name == name }
                    if let index {
                        typeArray.append(
                            UnsafePointer(pInterfaces.baseAddress?.advanced(by: index)))
                        continue
                    }
                    // interface not found -> refer to interfaces outside of this protocol like wl_callback
                    if let interface = self.interfaces[name] {
                        typeArray.append(interface)
                    }
                    fatalError("interface \(name) not founded in registry")
                }

                // TODO: optimizes later
                let types = UnsafeMutableBufferPointer<UnsafePointer<wl_interface>?>.allocate(
                    capacity: typeArray.count)
                _ = types.initialize(from: typeArray)

                // typeIndexs.append(Int)
                pMessages[index] = wl_message(
                    name: alloc(string: message.name),
                    signature: alloc(string: message.signature),
                    types: types.baseAddress,  // this will be update later
                )
            }

            pInterfaces[index] = wl_interface(
                name: alloc(string: interface.name),
                version: numericCast(interface.version),
                method_count: numericCast(interface.requests.count),
                methods: pMessages.baseAddress,
                event_count: numericCast(interface.events.count),
                events: pMessages.baseAddress?.advanced(by: interface.requests.count)
            )

            self.interfaces[interface.name] = UnsafePointer(
                pInterfaces.baseAddress!.advanced(by: index))
        }

        self.protocolMap[p.name] = pInterfaces
        return UnsafeBufferPointer(pInterfaces)
    }

    private func alloc(string: String) -> UnsafePointer<CChar> {
        let bytes = string.utf8CString
        let buffer = UnsafeMutableBufferPointer<CChar>.allocate(capacity: bytes.count)
        _ = buffer.initialize(from: bytes)
        return UnsafePointer(buffer.baseAddress!)
    }

    deinit {
        for p in protocolMap.values {
            p.deallocate()
        }
    }
}

extension Message {
    public var signature: String {
        var out = ""
        if let since {
            out += "\(since)"
        }

        for arg in self.arguments {
            if arg.nullable {
                out += "?"
            }

            switch arg.type {
            case .array:
                out += "a"
            case .fd:
                out += "h"
            case .fixed:
                out += "f"
            case .int:
                out += "i"
            case .newId:
                if arg.interface == nil {
                    out += "su"
                }
                out += "n"
            case .object:
                out += "o"
            case .string:
                out += "s"
            case .uint:
                out += "u"
            default:
                break
            }
        }

        return out
    }
}
