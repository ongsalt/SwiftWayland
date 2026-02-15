final class WeakMap<Key, Value> where Value: AnyObject, Key: Hashable {
    var objects: [Key: Weak<Value>] = [:]

    subscript(_ key: Key) -> Value? {
        get {
            let value = objects[key]?.value
            if value == nil {
                objects[key] = nil
            }

            return value
        }
        set {
            guard let newValue else {
                objects[key] = nil
                return
            }
            objects[key] = Weak(newValue)
        }
    }

    func upgrade() -> [Key: Value] {
        Dictionary(
            uniqueKeysWithValues: objects.lazy
                .map { ($0, $1.value) }
                .filter { $1 != nil }
                .map { ($0, $1!) }
        )
    }
}

extension WeakMap: ExpressibleByDictionaryLiteral {
    convenience init(dictionaryLiteral elements: (Key, Value)...) {
        self.init()
        for (key, value) in elements {
            self[key] = value
        }
    }
}
