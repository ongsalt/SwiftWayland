# SwiftWayland
Wayland scanner and Wayland client library for swift 

# WARNING: fd transport is not yet implemented

# What's not in there
- Server code generation

# Todos
- roundtrip
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

