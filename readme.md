# SwiftWayland
Wayland client library for swift. The package structure is very much inspired by [wayland-rs](https://github.com/Smithay/wayland-rs). Some part of SwiftWayland was directly ported from that. 

experimental. use at your own risk.


# Usages
- request is a method
- register a `onEvent` callback to deal with event from server  

```swift
let connection = try! Connection()
let display = connection.display

try display.sync { data in
    print(data)
}

let registry = try Globals(connection: connection)
try connection.roundtrip()

let compositor = try registry.bind(version: 1...6, type: WlCompositor.self)
let surface = try compositor.createSurface()
try connection.roundtrip()

let xdgWmBase = try registry.bind(version: 6...6, type: XdgWmBase.self)
xdgWmBase.onEvent = {
    switch $0 {
    case .ping(let serial):
        print("ping \(serial)")
        try? xdgWmBase.pong(serial: serial)
    }
}
try connection.roundtrip()
```

See `Examples` target for more.

## Object lifetime
There is no raii (except for the `Connection` object). You manually call its desctructor(s). Every object hold a strong reference to the `Connection` object. 

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
- stop doing build plugin, its buggy af
- allow-null
- event type="destructor"

- typed error
    - and better error handling in general
- bitfield
- generate more documentation
    - throws
    - when returns multiple object (probably never????)
- version validation
- enum
- signature transformation `setMode(mode:)` -> `setMode(_:)`
- kde and wlr protocol