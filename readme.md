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
- will provide a `deinit` that will be automatically run first destructor method with no argument

## Versioning
- its currently inherited from what you bind
- probably wrong
- what if some interface create an object from another registry
    - if its wl_callback, just make it 1 or just ignore

# Todos
- async again
- there is 2 `ZwpLinuxBufferParamsV1`: stable and unstable, probably need to do some namespacing + aliasing
- @spi export
- nullable onEvent
- think about queue and concurrency
- make Event decode failable (and not fatalError)
- programmatic renaming of id to the interface name or any better name
- bitfield
- generate documentation
    - throws
    - returnsS
    - callback
- test
    - probably gonna steal from wayland-rs

