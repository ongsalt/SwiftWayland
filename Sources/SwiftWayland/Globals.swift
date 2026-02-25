// This file is ported version of https://github.com/Smithay/wayland-rs/blob/master/wayland-client/src/globals.rs

public struct Global {
    let name: UInt32
    let interfaceName: String
    let version: UInt32
}

public enum BindError: Error {
    case unsupportedVersion
    case notPresent
}

public class Globals {
    public let registry: WlRegistry
    private var connection: Connection {
        registry.connection
    }
    public private(set) var globals: [Global] = []

    public init(connection: Connection) throws {
        self.registry = try connection.display.getRegistry()
        registry.onEvent = { event in
            switch event {
            case .global(let name, let interfaceName, let version):
                self.globals.append(
                    Global(
                        name: name, interfaceName: interfaceName, version: version))
            case .globalRemove(let name):
                // how do we handle this tho, destroy every object???
                self.globals.removeAll(where: { $0.name == name })
            }
        }
    }

    public func bind<T>(version: Range<UInt32>, type: T.Type, on queue: EventQueue? = nil)
        throws(BindError) -> T
    where T: Proxy {
        let queue = queue ?? connection.mainQueue
        if version.upperBound > type.interface.version {
            // This is a fatalError because it's a compile-time programmer error, not a runtime error.
            fatalError(
                "Maximum version (\(version.upperBound)) of \(type.interface.name) was higher than the proxy's maximum version (\(type.interface.version)); outdated wayland XML files"
            )
        }

        // mutex???
        guard let global = self.globals.first(where: { type.interface.name == $0.interfaceName }) else {
            throw .notPresent
        }

        if global.version < version.lowerBound {
            throw .unsupportedVersion
        }

        let version = min(version.upperBound, UInt32(type.interface.version))

        return registry.bind(name: global.name, version: version, interface: T.self, queue: queue)
    }

}
