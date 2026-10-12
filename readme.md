# SwiftWayland
A Wayland client library for Swift.

> Experimental - use at your own risk.


# Usage
- Requests are methods on the proxy object.
- Register an `onEvent` callback to handle events from the server.

```swift
let connection = Connection()
let display = connection.display

try display.sync { print($0) }

let globals = try Globals(connection: connection)
connection.roundtrip()

let compositor = try globals.bind(to: WlCompositor.self, version: 1...6)
let surface = try compositor.createSurface()
connection.roundtrip()

let xdgWmBase = try globals.bind(to: XdgWmBase.self, version: 6...6)
xdgWmBase.onEvent = {
    switch $0 {
    case .ping(let serial):
        try? xdgWmBase.pong(serial: serial)
    }
}
connection.roundtrip()
```

Incoming `array` argument will be transformed into a borrowed `UnsafeRawBufferPointer`, so dont free it. (might make it `RawSpan` later but it will make the generated message enum non escapable)

See the `Examples` for more.

# Features

## Proxy Lifetime
You own your proxies; `Connection` does not keep them alive. Dropping the last reference destroys the proxy on the client side only. It won't send any request with `type="destructor"` to the compositor, so call the destructor request yourself if the compositor needs to know. Each proxy keeps a strong reference to its `Connection`.

Objects referenced in incoming messages are always nullable, because the object may already have been destroyed.

## Name Translation
Some signatures are transformed into more idiomatic Swift - for example, `setMode(mode:)` becomes `setMode(_:)`.

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

## Debian/Ubuntu
```bash
apt install libwayland-dev
```

# Todos
- fix prefix map. may redesign it
- spi export
- dynamically link libwayland??

