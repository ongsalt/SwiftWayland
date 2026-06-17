import SwiftWaylandCommon

struct TypeConversion {
    static func swiftType(of argument: Argument, forceOptional: Bool? = nil, escaping: Bool = false)
        -> String
    {
        if argument.interface == "wl_callback" {
            if escaping {
                return "@escaping (UInt32) -> Void"
            } else {
                return "WlCallback"
            }
        }

        let ty =
            switch argument.type {
            case .int: "Int32"
            case .uint:
                if let e = argument.enum {
                    e.camel
                } else {
                    "UInt32"
                }
            case .fixed: "Double"
            case .string: "String"
            case .array:
                // TODO: fix lifetime problem when 6.4 landed
                if escaping {
                    "RawSpan"
                } else {
                    "UnsafeRawBufferPointer"
                }
            case .fd: "FileHandle"
            case .object:
                if let interface = argument.interface {
                    interface.camel
                } else {
                    "any Proxy"
                }
            case .newId:
                if let interface = argument.interface {
                    interface.camel
                } else {
                    // only wl_registry.bind, and we will manually write that
                    "_"
                }
            }

        if forceOptional ?? argument.nullable {
            if argument.type == .object && argument.interface == nil {
                return "(any Proxy)?"
            } else {
                return "\(ty)?"
            }
        } else {
            return ty
        }
    }

    static func defaultValue(of argument: Argument) -> String? {
        if argument.nullable {
            return "nil"
        }
        return nil
    }

    static func swiftToArg(swiftName: String, argument: Argument) -> (
        expression: String, wrapping: Closure?
    ) {
        var expression: String
        var wrapping: Closure?

        switch argument.type {
        case .newId:
            expression = ".newId"
        case .uint:
            let rawValueString = argument.enum != nil ? ".rawValue" : ""
            expression = ".uint(\(swiftName)\(rawValueString))"
        case .array:
            wrapping = Closure(
                begin: "\(swiftName).withUnsafeBytes { _\(swiftName) in",
                end: "}"
            )
            expression = ".array(_\(swiftName))"
        default:
            expression = ".\(argument.type)(\(swiftName))"
        }

        return (expression, wrapping)
    }

    static func wireToSwift(readerName r: String = "r", argument: Argument) -> String {
        switch argument.type {
        case .int: "\(r).int()"
        case .uint:
            if let e = argument.enum {
                "try \(r).`enum`(\(parseEnumName(e)).self)"
            } else {
                "\(r).uint()"
            }
        case .fixed: "\(r).fixed()"
        case .string:
            if argument.nullable {
                "\(r).nullableString()"
            } else {
                "\(r).string()"
            }
        case .fd: "\(r).fd()"
        case .object:
            if argument.interface == nil {
                "\(r).object()"
            } else {
                "\(r).object(type: \(swiftType(of: argument, forceOptional: false)).self)"
            }
        case .newId: "\(r).newId(type: \(swiftType(of: argument, forceOptional: false)).self)"
        /// TODO: is array nullable
        case .array: "\(r).array()"
        }
    }
}

struct Closure {
    let begin: String
    let end: String
}

/// definition | wire type | swift type | input event
/// uint (enum)| uint

// SwiftWaylandCommon.Argument -
