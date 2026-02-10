extension String {
    func snakeToCamel() -> String {
        let parts = self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "_", omittingEmptySubsequences: true)

        guard let first = parts.first else { return "" }

        let head = first.lowercased()
        let tail = parts.dropFirst().map { $0.lowercased().capitalized }

        return ([head] + tail).joined()
    }

    func snakeToLowerCamel() -> String {
        let camel = snakeToCamel()
        guard let first = camel.first else { return "" }

        return String(first).uppercased() + camel.dropFirst()
    }
}
