# SwiftWayland
Wayland client library for swift. The package structure is very much inspired by [wayland-rs](https://github.com/Smithay/wayland-rs). Some part of SwiftWayland was directly ported from that. 


# Usages
- request is a method
- register a `onEvent` callback to deal with event from server  

```swift
let connection = try! Connection.fromEnv()
let display: WlDisplay = connection.display

try display.sync { data in
    print(data)
}

let registry = try display.getRegistry()
registry.onEvent = { event in
    switch event {
    case .global(let name, let interface, let version):
        switch interface {
        case WlCompositor.name:
            self.compositor = registry.bind(name: name, version: version, interface: WlCompositor.self)
        default:
            break
        }
    default: 
        break
    }
}

try connection.roundtrip()
```

See `Example` target for more.

## Object lifetime
Every wayland proxy is owned by the `Connection` that create it. Proxy only contains a weak reference back to that connection. A proxy will be dropped only when its destructor method is called (exposed as a `consuming func`). Objects without destructor method will never be dropped (TODO: might provide a way tho) and so do its event handler. 

`EventQueue` is owned by both the `Connection` and associated proxies. `EventQueue` itself do not contains any strong reference back to those.

If you drop the connection every object and event queue will be close automatically.


## Code generation
Code generation was done by a build tool plugin using protocol definitions from [wayland-protocols](https://gitlab.freedesktop.org/wayland/wayland-protocols)

There is no server side code generation yet and probably won't be any time soon.

If you need to do custom protocol, see `WaylandScannerCLI`. (not yet exported)


# Dependencies
Please get wayland development header from your package manager

## Fedora
```bash
dnf install wayland-devel
```

# Todos
- `libwayland-client` backend becuase its pain in the ass to deal with egl
    - i might stop doing multiple backend becuase its pain in the ass
- runtime request and event information??
- allow-null
- stop doing `Data` and use `UnsafeMutableRawBuffer`

- refactor namespace generation, -> hardcode known prefix into the scanner
- typed error
    - and better error handling in general
- allow custom proxy?
- bitfield
- generate more documentation
    - throws
    - when returns multiple object (probably never????)
- test
    - gonna steal from wayland-rs
