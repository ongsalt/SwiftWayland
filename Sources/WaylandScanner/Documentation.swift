extension Description {
    var docc: String {
        """
        \(self.summary.capitalized)

        \(self.value.trimmed)
        """
    }
}

extension EnumEntry {
    var docc: String? {
        self.summary?.capitalized
    }
}

extension Argument {
    var docc: String? {
        if let summary {
            """
            - \(self.name.camel): \(summary)
            """
        } else {
            nil
        }
    }
}

extension Request {
    var docc: String? {
        // TODO: apply our rule: callback and newId handling
        var lines: [String] = []
        if let description {
            lines.append(description.docc)
        }

        let arguments = arguments
            .filter { $0.type != .newId }
            .filter { $0.docc != nil }
            .map { $0.docc! }
        if !arguments.isEmpty {
            lines.append(
                """
                - Parameters:
                \(arguments.joined(separator: "\n").indent(space: 2))
                """)
        }

        if let since {
            lines.append("Available since version \(since)")
        }

        return lines.isEmpty ? nil : lines.joined(separator: "\n\n")
    }
}

extension Event {
    // same as Request bruh
    var docc: String? {
        Request(name: name, type: nil, description: description, since: since, arguments: arguments)
            .docc
    }
}

extension Enum {
    // bruhhh
    var docc: String? {
        Request(name: name, type: nil, description: description, since: since, arguments: [])
            .docc
    }
}
