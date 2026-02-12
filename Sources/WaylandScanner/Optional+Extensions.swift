extension Optional {
    func expect(_ message: String) -> Wrapped {
        if let value = self {
            value
        } else {
            fatalError(message)
        }
    }
}