public func _parseEnum<T>(into: T.Type, _ rawValue: UInt32) throws(DecodingError) -> T where T: RawRepresentable, T.RawValue == UInt32 {
    guard let instance = T(rawValue: rawValue) else {
        throw .unknownEnumCase(case: rawValue, enumName: String(describing: T.self))
    }
    return instance
}
