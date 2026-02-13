# SwiftWayland
Wayland scanner and Wayland client library for swift 

# WARNING: fd ~~transport~~ receiving is not yet ~~implemented~~ test

# What's not in there
- Server code generation

# Design
some design decision
## Destructor method
- now every method will be able to throws
- will expose a destructor function as a `consuming func`
- will provide a `deinit` that will be automatically run if no consuming func are detected, so we need to keep track if an object is still alive or not

# Todos
- @spi export
- think about queue and concurrency
- make Event decode failable 
- programmatic rename id to the instance or any better name
- bitfield
- Codegen
    - destructor
    - wl_callback special handling
    - parse event `since`
    - generate documentation
- test


# Code generation
See Scripts/generate.py

```bash
# swift run WaylandScanner client /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml
swift run WaylandScanner client /usr/share/wayland/wayland.xml Sources/SwiftWayland/Generated/Wayland
swift run WaylandScanner client /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml Sources/SwiftWayland/Generated/Stable/XdgShell
```

