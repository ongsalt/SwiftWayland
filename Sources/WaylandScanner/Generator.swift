import Foundation

public final class Generator<Output: TextOutputStream> {
    var indentation: Int = 4
    public var indentLevel: Int = 0

    private var outputStream: Output
    public init(outputStream: Output) {
        self.outputStream = outputStream
    }

    public func add(_ string: String, endWith ending: String? = "\n") {
        outputStream.write(string.indent(space: indentLevel))
        if let ending {
            outputStream.write(ending)
        }
    }

    public func add() {
        outputStream.write("\n")
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

    func block(
        _ prefix: String = "{",
        endWith subfix: String = "}",
        unwrapIf skipWrapping: Bool = false,
        _ block: () -> Void
    ) {
        if !skipWrapping {
            add(prefix)
            self.indentLevel += indentation
        }
        block()
        if !skipWrapping {
            self.indentLevel -= indentation
            add(subfix)
        }
    }

    func walk(node: some Code) {
        node.generate(self)
    }

    public static func << (generator: Generator, line: String) {
        generator.add(line)
    }
}

protocol Code {
    func generate<Output: TextOutputStream>(_ generator: Generator<Output>)
}

