# SwiftWayland
Wayland scanner and Wayland client library for swift 

# WARNING: fd ~~transport~~ receiving is not yet ~~implemented~~ test

# What's not in there
- Server code generation

# Usages

For client library see `SwiftWaylandExample` 

## Code generation
See Scripts/generate.py

```bash
# swift run WaylandScanner client /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml
swift run WaylandScanner client /usr/share/wayland/wayland.xml Sources/SwiftWayland/Generated/Wayland
swift run WaylandScanner client /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml Sources/SwiftWayland/Generated/Stable/XdgShell
```


# Design
some design decision
## Destructor method
- now every method will be able to throws
- will expose a destructor function as a `consuming func`
- will provide a `deinit` that will be automatically run if no consuming func are detected, so we need to keep track if an object is still alive or not

## Versioning
- its currently inherited from what you bind
- probably wrong
- what if some interface create an object from another registry
    - if its wl_callback, just make it 1 or just ignore

# Todos
- @spi export
- nullable onEvent
- think about queue and concurrency
- make Event decode failable (and not fatalError)
- programmatic rename id to the instance or any better name
- bitfield
- Codegen
    - generate documentation
- test
    - probably gonna steal from wayland-rs

