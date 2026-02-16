class Scope {
    let name: String
    var children: [String: Scope] = [:]

    init(name: String) {
        self.name = name
    }

    func getOrCreate(path: String) -> Scope {
        if path == "" {
            return self
        }

        var components = path.split(separator: ".")
        let first = String(components.removeFirst())
        if children[first] == nil {
            children[first] = Scope(name: first)
        }

        return children[first]!.getOrCreate(path: components.joined(separator: "."))
    }
}

extension Scope: Code {
    func generate(_ gen: Generator) {
        if self.children.count == 0 {
            gen.add("public enum \(self.name) {}")
            return
        }
        gen.add("public enum \(self.name) {")
        gen.indent {
            for (_, s) in self.children {
                s.generate(gen)
            }
        }
        gen.add("}")
    }
}

public func createNamespaces(namespaces: Set<String>) -> String {
    var namespaces = namespaces
    namespaces.remove("")
    let root = Scope(name: "")

    for namespace in namespaces {
        _ = root.getOrCreate(path: namespace)
    }

    let gen = Generator()
    for (_, s) in root.children {
        gen.walk(node: s)
    }

    return gen.text
}
