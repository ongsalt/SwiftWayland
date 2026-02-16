import Foundation

public struct Options: Sendable {
    public var trimPrefix: String?
    public var trimPostfix: String?
    public var namespace: String?
    public var importName: String?
    public var traits: String?

    public init() {}

    // we stop doing namespace nowm so this is mostly unused
    public init(path: String, autoTrimPrefix: Bool = true) {
        self.importName = "SwiftWayland"
        let url = URL(filePath: path)
        let base = url.pathComponents.count - 4

        let filename = url.lastPathComponent.split(separator: ".")[0]
        var namespace = url.pathComponents[base + 2].split(separator: "-").map { $0.capitalized }

        // if autoTrimPrefix {
        //     self.trimPrefix = namespace[0]
        // } else {
        //     self.trimPrefix = nil
        // }

        let stability = url.pathComponents[base + 1]
        self.traits = stability.uppercased()
        if self.traits == "STABLE" {
            self.trimPostfix = nil
            return
        }

        let version = filename.split(separator: "-").last!.uppercased()
        self.trimPostfix = version

        let parts: [String] = []
        let versionNamespace =
            if self.traits == "UNSTABLE" {
                "Z" + self.trimPostfix!
            } else {
                self.trimPostfix!
            }

        // // xdg
        // if autoTrimPrefix {
        //     let topLevelNamespace = namespace.removeFirst()
        //     self.namespace = "\(topLevelNamespace).\(namespace.joined()).\(versionNamespace)"
        // } else {
        //     self.namespace = "\(namespace.joined()).\(versionNamespace)"
        // }
    }
}
