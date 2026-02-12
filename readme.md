# Todos
- fd transport is not yet implemented
- programmatic rename id to the instance or any better name
- make Event decode failable 
- Codegen
    - multiple new_id handling
    - destructor
    - wl_callback handling
    - event `since`
    - generate documentation
- test

```bash
# swift run WaylandScanner client /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml
swift run WaylandScanner client /usr/share/wayland/wayland.xml Sources/SwiftWayland/Generated/Wayland
swift run WaylandScanner client /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml Sources/SwiftWayland/Generated/XdgShell
```

