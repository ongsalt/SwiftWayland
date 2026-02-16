func auto(_ path: String, trimPrefix: Bool = true) -> (String, Options) {
    (path, Options(path: path, autoTrimPrefix: trimPrefix))
}

let waylandMappings: [(String, Options)] = [("./wayland.xml", Options())]

let defaultMappings: [(String, Options)] = [
    // XDG
    auto("./Protocols/unstable/xdg-decoration/xdg-decoration-unstable-v1.xml"),
    auto("./Protocols/unstable/xdg-foreign/xdg-foreign-unstable-v1.xml"),
    auto("./Protocols/unstable/xdg-foreign/xdg-foreign-unstable-v2.xml"),
    auto("./Protocols/unstable/xdg-output/xdg-output-unstable-v1.xml"),
    auto("./Protocols/stable/xdg-shell/xdg-shell.xml"),
    auto("./Protocols/staging/xdg-toplevel-drag/xdg-toplevel-drag-v1.xml"),  // TODO: dependencies, this depend on Xdg.Shell
    auto("./Protocols/staging/xdg-dialog/xdg-dialog-v1.xml"),
    auto("./Protocols/staging/xdg-toplevel-icon/xdg-toplevel-icon-v1.xml"),
    auto("./Protocols/staging/xdg-toplevel-tag/xdg-toplevel-tag-v1.xml"),  // also depend on Xdg.Shell
    auto("./Protocols/staging/xdg-system-bell/xdg-system-bell-v1.xml", ),

    // Xwayland
    auto("./Protocols/staging/xwayland-shell/xwayland-shell-v1.xml"),
    auto("./Protocols/unstable/xwayland-keyboard-grab/xwayland-keyboard-grab-unstable-v1.xml"),

    // WP
]

let plasmaMapping: [(String, Options)] = []
let experimentalMapping: [(String, Options)] = []
let miscMapping: [(String, Options)] = []
