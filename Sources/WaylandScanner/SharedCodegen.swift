import SwiftWaylandCommon

extension Protocol: Code {
    func generate(_ gen: Generator) {
        gen.add("Protocol(")
        gen.indent {
            gen.add("name: \"\(self.name)\",")
            gen.add("interfaces: ")
            gen.walk(array: self.interfaces)
        }
        gen.add(")")
    }
}

extension Interface: Code {
    func generate(_ gen: Generator) {
        gen.add("Interface(")
        gen.indent {
            gen.add("name: \"\(self.name)\",")
            gen.add("version: \(self.version),")
            gen.add("enums: [],")

            gen.add("requests: ")
            gen.indent {
                gen.walk(array: self.requests)
            }
            gen.add(sameLine: ",")
            gen.add("events: ")
            gen.indent {
                gen.walk(array: self.events)
            }
            gen.add(sameLine: ",")
        }
        gen.add(")")
    }
}

extension Message: Code {
    func generate(_ gen: Generator) {
        gen.add("Message(")
        gen.indent {
            gen.add("name: \"\(self.name)\",")
            if let type {
                gen.add("type: .\(type),")
            }
            gen.add("arguments: ")
            gen.walk(array: self.arguments)
            gen.add(sameLine: ",")
            if let since {
                gen.add("since: \(since)")
            }
        }
        gen.add(")")
    }
}

extension Argument: Code {
    func generate(_ gen: Generator) {
        gen.add("Argument(")
        gen.indent {
            gen.add("name: \"\(self.name)\",")
            gen.add("type: .\(type),")
        }
        gen.add(")")

    }
}
