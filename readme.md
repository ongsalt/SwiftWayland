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


## Code generation
its macro
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



# Design
some design decision
## Destructor method
- now every method will be able to throws
- will expose a destructor function as a `consuming func`
- will not generate a deinit
- even if we call a destructor, message might still come in, so drop it?
- connection are now required to have strong reference to those (2 way)


## Versioning
- its currently inherited from what you bind
- what if some interface create an object from another registry
    - if its wl_callback, just make it 1 or just ignore

# Todos
- we still need python codegen for putting xml into swift file and doing aliases
- typed error
- max version
- make Event decode failable (and not fatalError) in case object mentioned is already dropped
- allow custom proxy?
- when should i check if fd is open? dispatch??? or when call
- error message when connection closed,
- async again
- there is 2 `ZwpLinuxBufferParamsV1`: stable and unstable, probably need to do some namespacing + aliasing
- codegen plugin
- @spi export
- bitfield
- generate documentation
    - throws
    - returns multiple object
- test
    - probably gonna steal from wayland-rs
