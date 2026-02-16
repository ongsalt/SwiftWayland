# SwiftWayland
Wayland client library for swift. The package structure is very much inspired by [wayland-rs](https://github.com/Smithay/wayland-rs)


## WARNING: fd ~~transport~~ receiving is not yet ~~implemented~~ test

# Usages
- request is a method
- register a `onEvent` callback to deal event from the server  
- Generated classes are always namespaced: `Wayland.Compositor`.

```swift
let connection = try! Connection.fromEnv()
let display: Wayland.Display = connection.display

try display.sync { data in
    print(data)
}

let registry = try display.getRegistry()
registry.onEvent = { event in
    switch event {
    case .global(let name, let interface, let version):
        switch interface {
        case Wayland.Compositor.name:
            self.compositor = registry.bind(name: name, version: version, interface: Wayland.Compositor.self)
        default:
            break
        }
    default: 
        break
    }
}

try connection.roundtrip()
```

See `SwiftWaylandExample` for more example

## Object lifetime
Every wayland proxy is owned by the `Connection` that create it. Proxy only contains a weak reference back to that connection. A proxy will be dropped only when its destructor method is called (exposed as a `consuming func`). Objects without destructor method will never be dropped (TODO: might provide a way tho) and so do its event handler. 

`EventQueue` is owned by both the `Connection` and associated proxies. `EventQueue` itself do not contains any strong reference back to those.
If you drop the connection it will be close automatically


## Code generation
There is both macro and CLI. Macro is incomplete tho
```swift
public macro WaylandProtocol(trimPrefix: String? = nil, _ xml: String)

@WaylandProtocol(
    trimPrefix: "Xdg"
    """
    <xml>...
    """
)
struct Protocol {}
```

```bash
swift run WaylandScannerCLI client ./wayland.xml ./Wayland.swift --trim-prefix Wl --namespace IdkMan
```


# Design
some design decision
## Destructor method
- now every method will be able to throws
- will expose a destructor function as a `consuming func`
- will not generate a deinit that will call those destructor

## Versioning
- its currently inherited from what you bind
- what if some interface create an object from another registry
    - if its wl_callback, just make it 1 or just ignore
- i didnt do max version yet tho

# Todos
- refactor namespace generation, -> hardcode known prefix in the scanner
- more protocols
- traits
- typed error
- allow custom proxy?
- async again
- bitfield
- generate documentation
    - throws
    - returns multiple object
- test
    - probably gonna steal from wayland-rs
