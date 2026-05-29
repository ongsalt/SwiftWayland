final class Generator {
    var stack: [any Code] = []
    var indentation: Int = 4
    var indentLevel: Int = 0
    var importName: String?

    var text: String {
        lines.joined(separator: "\n")
    }

    var lines: [String] = []

    func add(_ string: String) {
        lines.append(
            string.indent(space: indentLevel)
        )
    }

    func add(sameLine string: String) {
        if let l = lines.popLast() {
            lines.append(l + string)
        }
    }

    func add() {
        lines.append("")
    }

    func add(docc str: String) {
        add("\(str)".indent("/// "))
    }

    func add(comment str: String) {
        add("\(str)".indent("// "))
    }

    func indent(level: Int? = nil, _ block: () -> Void) {
        self.indentLevel += level ?? indentation
        block()
        self.indentLevel -= level ?? indentation
    }

    func block(_ prefix: String = "{", endWith subfix: String = "}", _ block: () -> Void) {
        add(prefix)
        self.indentLevel += indentation
        block()
        self.indentLevel -= indentation
        add(subfix)
    }

    func walk(node: some Code) {
        stack.append(node)
        node.generate(self)
        _ = stack.popLast()
    }

    func walk(array: [some Code]) {
        self.add(sameLine: "[")
        for c in array {
            self.walk(node: c)
            self.add(sameLine: ",")
        }
        self.add("]")
    }

    static func << (generator: Generator, line: String) {
        generator.add(line)
    }
}

protocol Code {
    func generate(_ generator: Generator)
}
