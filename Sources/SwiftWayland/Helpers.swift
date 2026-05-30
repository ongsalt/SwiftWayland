extension RawRepresentable where RawValue == UInt32 {
    static func _parseEnum(_ rawValue: UInt32) throws(DecodingError) -> Self {
        guard let instance = Self(rawValue: rawValue) else {
            throw .unknownEnumCase(case: rawValue, enumName: String(describing: Self.self))
        }
        return instance
    }
}

func _parseEnum<T>(_ rawValue: UInt32) throws(DecodingError) -> T where T: RawRepresentable, T.RawValue == UInt32 {
    guard let instance = T(rawValue: rawValue) else {
        throw .unknownEnumCase(case: rawValue, enumName: String(describing: T.self))
    }
    return instance
}
