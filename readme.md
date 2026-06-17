# SwiftWayland
A Wayland client library for Swift.

> Experimental — use at your own risk.


# Usage
- Requests are methods on the proxy object.
- Register an `onEvent` callback to handle events from the server.

```swift
let connection = try! Connection()
let display = connection.display

try display.sync { print($0) }

let globals = try Globals(connection: connection)
try connection.roundtrip()

let compositor = try globals.bind(to: WlCompositor.self, version: 1...6)
let surface = try compositor.createSurface()
try connection.roundtrip()

let xdgWmBase = try globals.bind(to: XdgWmBase.self, version: 6...6)
xdgWmBase.onEvent = {
    switch $0 {
    case .ping(let serial):
        try? xdgWmBase.pong(serial: serial)
    }
}
try connection.roundtrip()
```

`array` argument will be transformed into a non owning UnsafeRawBufferPointer, so DO NOT FREE THIS. (might make it `RawSpan` later)

See the `Examples` target for more.

# Features

## Proxy Lifetime
No automatic destruction are performed. call `Proxy.destroy(_:)` or a request with `type="destructor"` to destroy the handle. Object referenced from an incoming message are always nullable in case that it was already destroyed.

## Name Translation
Some signatures are transformed into more idiomatic Swift — for example, `setMode(mode:)` becomes `setMode(_:)`.

# Code Generation
Code generation is handled by a build tool plugin using protocol definitions from [wayland-protocols](https://gitlab.freedesktop.org/wayland/wayland-protocols).

There is no server-side code generation yet, and there likely won't be any time soon.

If you need to add a custom protocol, see `WaylandScannerCLI`.


# Dependencies
Install the Wayland development headers from your package manager.

## Fedora
```bash
dnf install wayland-devel
```

# Todos
- Less copying once we have borrowing sequence
- spi export
- dynamically link libwayland
- server support
- switch back to build tool plugin later
- stop hijacking object_data