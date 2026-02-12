extension String {
    func snakeToLowerCamel() -> String {
        let parts = self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "_", omittingEmptySubsequences: true)

        guard let first = parts.first else { return "" }

        let head = first.lowercased()
        let tail = parts.dropFirst().map { $0.lowercased().capitalized }

        return ([head] + tail).joined()
    }

    func snakeToCamel() -> String {
        let camel = snakeToLowerCamel()
        guard let first = camel.first else { return "" }

        return String(first).uppercased() + camel.dropFirst()
    }

    var lowerCamel: String {
        snakeToLowerCamel()
    }

    var camel: String {
        snakeToCamel()
    }

    func indent(space: UInt) -> String {
        let indentation = String(repeating: " ", count: Int(space))
        return self
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { indentation + $0 }
            .joined(separator: "\n")
    }
}
