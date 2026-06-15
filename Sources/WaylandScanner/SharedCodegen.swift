import SwiftWaylandCommon

extension Protocol: Code {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        gen.add("Protocol(")
        gen.indent {
            gen.add("name: \"\(self.name)\",")
            gen.add("interfaces: ")
            for interface in self.interfaces {
                interface.generate(gen)
            }
        }
        gen.add(")")
    }
}

extension Interface: Code {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        gen.block("Interface(", endWith: ")") {
            gen << "name: \"\(self.name)\","
            gen << "version: \(self.version),"

            if !requests.isEmpty {
                gen.block("requests: [", endWith: "],") {
                    for request in self.requests {
                        request.generate(gen)
                        gen << ","
                    }
                }
            }

            if !events.isEmpty {
                gen.block("events: [", endWith: "],") {
                    for event in self.events {
                        event.generate(gen)
                        gen << ","
                    }
                }
            }
        }
    }
}

extension Message: Code {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
        gen.block("Message(", endWith: ")") {
            gen << "name: \"\(self.name)\","
            if let type {
                gen << "type: .\(type),"
            }

            gen.block("arguments: [", endWith: "],") {
                for arg in self.self.arguments {
                    arg.generate(gen)
                    gen << ","
                }
            }

            if let since {
                gen << "since: \(since)"
            }
        }
    }
}

extension Argument: Code {
    func generate<Output: TextOutputStream>(_ gen: Generator<Output>) {
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
