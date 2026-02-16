func auto(_ path: String, trimPrefix: Bool = true) -> (String, Options) {
    (path, Options(path: path, autoTrimPrefix: trimPrefix))
}

// Mostly copied from wayland-rs

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
    auto("./Protocols/staging/content-type/content-type-v1.xml"),
    auto("./Protocols/staging/color-management/color-management-v1.xml", ),
    auto("./Protocols/staging/color-representation/color-representation-v1.xml", ),
    auto("./Protocols/staging/drm-lease/drm-lease-v1.xml"),
    auto("./Protocols/staging/tearing-control/tearing-control-v1.xml"),
    auto("./Protocols/staging/fractional-scale/fractional-scale-v1.xml", ),
    auto("./Protocols/unstable/fullscreen-shell/fullscreen-shell-unstable-v1.xml"),
    auto("./Protocols/unstable/idle-inhibit/idle-inhibit-unstable-v1.xml", ),
    auto("./Protocols/unstable/input-method/input-method-unstable-v1.xml", ),
    auto("./Protocols/unstable/input-timestamps/input-timestamps-unstable-v1.xml", ),
    auto(
        "./Protocols/unstable/keyboard-shortcuts-inhibit/keyboard-shortcuts-inhibit-unstable-v1.xml",
    ),
    auto("./Protocols/stable/linux-dmabuf/linux-dmabuf-v1.xml"),
    auto(
        "./Protocols/unstable/linux-explicit-synchronization/linux-explicit-synchronization-unstable-v1.xml",
    ),
    auto("./Protocols/staging/linux-drm-syncobj/linux-drm-syncobj-v1.xml", ),
    auto("./Protocols/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml", ),
    auto("./Protocols/unstable/pointer-gestures/pointer-gestures-unstable-v1.xml", ),
    auto("./Protocols/stable/presentation-time/presentation-time.xml"),
    auto("./Protocols/unstable/primary-selection/primary-selection-unstable-v1.xml", ),
    auto("./Protocols/unstable/relative-pointer/relative-pointer-unstable-v1.xml", ),
    auto("./Protocols/staging/single-pixel-buffer/single-pixel-buffer-v1.xml", ),
    auto("./Protocols/unstable/tablet/tablet-unstable-v1.xml"),
    auto("./Protocols/stable/tablet/tablet-v2.xml"),
    auto("./Protocols/unstable/text-input/text-input-unstable-v1.xml"),
    auto("./Protocols/unstable/text-input/text-input-unstable-v3.xml"),
    auto("./Protocols/stable/viewporter/viewporter.xml"),
    auto("./Protocols/staging/security-context/security-context-v1.xml", ),
    auto("./Protocols/staging/alpha-modifier/alpha-modifier-v1.xml"),
    auto("./Protocols/staging/fifo/fifo-v1.xml"),
    auto("./Protocols/staging/commit-timing/commit-timing-v1.xml"),
    auto("./Protocols/staging/pointer-warp/pointer-warp-v1.xml"),
]

let plasmaMapping: [(String, Options)] = []
let experimentalMapping: [(String, Options)] = []
let miscMapping: [(String, Options)] = []
