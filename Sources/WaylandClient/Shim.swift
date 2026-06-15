import Foundation
@_exported import SwiftWaylandCommon

extension WlRegistry {
    public func bind<T>(name: UInt32, version: UInt32, interface: T.Type, queue: EventQueue? = nil)
        -> T
    where T: Proxy {
        connection.sendConstructor(
            self, 0, returning: interface, version: version, on: queue,
            [
                .uint(name),
                .string(interface.interface.name),
                .uint(version),
                // this ignored
                .newId(1001),
            ]
        )
    }
}
