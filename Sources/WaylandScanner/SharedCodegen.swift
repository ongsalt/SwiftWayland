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
        gen.block("Interface(", endWith: ")") {
            gen << "name: \"\(self.name)\","
            gen << "version: \(self.version),"

            if !requests.isEmpty {
                gen.array(requests, startWith: "requests: ", endWith: ",")
            }
            if !events.isEmpty {
                gen.array(events, startWith: "events: ")
            }
        }
    }
}

extension Message: Code {
    func generate(_ gen: Generator) {
        gen.block("Message(", endWith: ")") {
            gen << "name: \"\(self.name)\","
            if let type {
                gen << "type: .\(type),"
            }
            gen.array(self.arguments, startWith: "arguments: ", endWith: ",")
            if let since {
                gen << "since: \(since)"
            }
        }
    }
}

extension Argument: Code {
    func generate(_ gen: Generator) {
        gen.block("Argument(", endWith: ")") {
            gen << "name: \"\(self.name)\","
            gen << "type: .\(self.type),"
            if let interface {
                gen << "interface: \"\(interface)\","
            }
            if self.nullable {
                gen << "nullable: \(self.nullable),"
            }
        }

    }
}
