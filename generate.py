#!/usr/bin/env python3
import subprocess
import sys
import os

DRY_RUN = False

XDG_PROTOCOLS = [
    "./Protocols/unstable/xdg-decoration/xdg-decoration-unstable-v1.xml",
    "./Protocols/unstable/xdg-foreign/xdg-foreign-unstable-v1.xml",
    "./Protocols/unstable/xdg-foreign/xdg-foreign-unstable-v2.xml",
    "./Protocols/unstable/xdg-output/xdg-output-unstable-v1.xml",
    "./Protocols/stable/xdg-shell/xdg-shell.xml",
    "./Protocols/staging/xdg-toplevel-drag/xdg-toplevel-drag-v1.xml",
    "./Protocols/staging/xdg-dialog/xdg-dialog-v1.xml",
    "./Protocols/staging/xdg-toplevel-icon/xdg-toplevel-icon-v1.xml",
    "./Protocols/staging/xdg-toplevel-tag/xdg-toplevel-tag-v1.xml",
    "./Protocols/staging/xdg-system-bell/xdg-system-bell-v1.xml",
]

XWAYLAND_PROTOCOLS = [
    "./Protocols/staging/xwayland-shell/xwayland-shell-v1.xml",
    "./Protocols/unstable/xwayland-keyboard-grab/xwayland-keyboard-grab-unstable-v1.xml",
]

WP_PROTOCOLS = [
    "./Protocols/staging/content-type/content-type-v1.xml",
    "./Protocols/staging/color-management/color-management-v1.xml",
    "./Protocols/staging/color-representation/color-representation-v1.xml",
    "./Protocols/staging/drm-lease/drm-lease-v1.xml",
    "./Protocols/staging/tearing-control/tearing-control-v1.xml",
    "./Protocols/staging/fractional-scale/fractional-scale-v1.xml",
    "./Protocols/unstable/fullscreen-shell/fullscreen-shell-unstable-v1.xml",
    "./Protocols/unstable/idle-inhibit/idle-inhibit-unstable-v1.xml",
    "./Protocols/unstable/input-method/input-method-unstable-v1.xml",
    "./Protocols/unstable/input-timestamps/input-timestamps-unstable-v1.xml",
    "./Protocols/unstable/keyboard-shortcuts-inhibit/keyboard-shortcuts-inhibit-unstable-v1.xml",
    "./Protocols/stable/linux-dmabuf/linux-dmabuf-v1.xml",
    "./Protocols/unstable/linux-explicit-synchronization/linux-explicit-synchronization-unstable-v1.xml",
    "./Protocols/staging/linux-drm-syncobj/linux-drm-syncobj-v1.xml",
    "./Protocols/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml",
    "./Protocols/unstable/pointer-gestures/pointer-gestures-unstable-v1.xml",
    "./Protocols/stable/presentation-time/presentation-time.xml",
    "./Protocols/unstable/primary-selection/primary-selection-unstable-v1.xml",
    "./Protocols/unstable/relative-pointer/relative-pointer-unstable-v1.xml",
    "./Protocols/staging/single-pixel-buffer/single-pixel-buffer-v1.xml",
    "./Protocols/unstable/tablet/tablet-unstable-v1.xml",
    "./Protocols/stable/tablet/tablet-v2.xml",
    "./Protocols/unstable/text-input/text-input-unstable-v1.xml",
    "./Protocols/unstable/text-input/text-input-unstable-v3.xml",
    "./Protocols/stable/viewporter/viewporter.xml",
    "./Protocols/staging/security-context/security-context-v1.xml",
    "./Protocols/staging/alpha-modifier/alpha-modifier-v1.xml",
    "./Protocols/staging/fifo/fifo-v1.xml",
    "./Protocols/staging/commit-timing/commit-timing-v1.xml",
    "./Protocols/staging/pointer-warp/pointer-warp-v1.xml",
    "./Protocols/staging/ext-session-lock/ext-session-lock-v1.xml",
]

KDE_PROTOCOLS = [
    "./ProtocolsKDE/src/protocols/appmenu.xml",
    "./ProtocolsKDE/src/protocols/blur.xml",
    "./ProtocolsKDE/src/protocols/contrast.xml",
    "./ProtocolsKDE/src/protocols/dpms.xml",
    "./ProtocolsKDE/src/protocols/fake-input.xml",
    "./ProtocolsKDE/src/protocols/fullscreen-shell.xml",
    "./ProtocolsKDE/src/protocols/idle.xml",
    "./ProtocolsKDE/src/protocols/kde-external-brightness-v1.xml",
    "./ProtocolsKDE/src/protocols/kde-lockscreen-overlay-v1.xml",
    "./ProtocolsKDE/src/protocols/kde-output-device-v2.xml",
    "./ProtocolsKDE/src/protocols/kde-output-management-v2.xml",
    "./ProtocolsKDE/src/protocols/kde-output-order-v1.xml",
    "./ProtocolsKDE/src/protocols/kde-primary-output-v1.xml",
    "./ProtocolsKDE/src/protocols/kde-screen-edge-v1.xml",
    "./ProtocolsKDE/src/protocols/keystate.xml",
    "./ProtocolsKDE/src/protocols/org-kde-plasma-virtual-desktop.xml",
    "./ProtocolsKDE/src/protocols/outputdevice.xml",
    "./ProtocolsKDE/src/protocols/output-management.xml",
    "./ProtocolsKDE/src/protocols/plasma-shell.xml",
    "./ProtocolsKDE/src/protocols/plasma-window-management.xml",
    "./ProtocolsKDE/src/protocols/remote-access.xml",
    "./ProtocolsKDE/src/protocols/server-decoration-palette.xml",
    "./ProtocolsKDE/src/protocols/server-decoration.xml",
    "./ProtocolsKDE/src/protocols/shadow.xml",
    "./ProtocolsKDE/src/protocols/slide.xml",
    "./ProtocolsKDE/src/protocols/surface-extension.xml",
    "./ProtocolsKDE/src/protocols/text-input-unstable-v2.xml",
    "./ProtocolsKDE/src/protocols/text-input.xml",
    "./ProtocolsKDE/src/protocols/wayland-eglstream-controller.xml",
    "./ProtocolsKDE/src/protocols/zkde-screencast-unstable-v1.xml",
]

WLR_PROTOCOLS = [
    "./ProtocolsWlr/unstable/wlr-data-control-unstable-v1.xml",
    "./ProtocolsWlr/unstable/wlr-export-dmabuf-unstable-v1.xml",
    "./ProtocolsWlr/unstable/wlr-foreign-toplevel-management-unstable-v1.xml",
    "./ProtocolsWlr/unstable/wlr-gamma-control-unstable-v1.xml",
    "./ProtocolsWlr/unstable/wlr-input-inhibitor-unstable-v1.xml",
    "./ProtocolsWlr/unstable/wlr-layer-shell-unstable-v1.xml",
    "./ProtocolsWlr/unstable/wlr-output-management-unstable-v1.xml",
    "./ProtocolsWlr/unstable/wlr-output-power-management-unstable-v1.xml",
    "./ProtocolsWlr/unstable/wlr-screencopy-unstable-v1.xml",
    "./ProtocolsWlr/unstable/wlr-virtual-pointer-unstable-v1.xml",
]

def run(cli: str, args: list[str]) -> bool:
    command = [cli] + args
    if DRY_RUN:
        print(f"DRY RUN:")
        print(' '.join(command))
        return True
    return subprocess.run(command).returncode == 0

def generate_group(
    cli: str,
    protocols: list[str],
    output_file: str,
    trait: str | None,
    namespace: str | None = None,
    prefix_map: list[tuple[str, str]] | None = None,
) -> int:
    if prefix_map is None:
        prefix_map = []
        
    args = ["client", "--input-files"] + protocols + ["--output-file", output_file, "--import", "WaylandClient"]
    
    if namespace:
        args += ["--namespace", namespace]
    if trait:
        args += ["--traits", trait]
        
    for old, new in prefix_map:
        args += ["--prefix-map", f"{old}:{new}"]
        
    if not run(cli, args):
        return 1
    return 0

def main():
    os.makedirs("Sources/WaylandProtocols/Generated", exist_ok=True)

    print("Building WaylandScannerCLI...")
    subprocess.run(["swift", "build", "--product", "WaylandScannerCLI"], check=True)

    bin_path = subprocess.run(
        ["swift", "build", "--product", "WaylandScannerCLI", "--show-bin-path"],
        capture_output=True, text=True, check=True,
    ).stdout.strip()
    cli = os.path.join(bin_path, "WaylandScannerCLI")

    errors = 0

    ok = run(cli, [
        "client", 
        "--input-files", "wayland.xml", 
        "--output-file", "Sources/WaylandClient/Generated/Wayland.swift", 
    ])
    
    if not ok:
        errors += 1

    errors += generate_group(cli, XDG_PROTOCOLS, "Sources/WaylandClientProtocols/Generated/Xdg.swift", "XDG")
    errors += generate_group(cli, XWAYLAND_PROTOCOLS, "Sources/WaylandClientProtocols/Generated/Xwayland.swift", "XWAYLAND")
    errors += generate_group(cli, WP_PROTOCOLS, "Sources/WaylandClientProtocols/Generated/Wp.swift", "WP")
    errors += generate_group(
        cli, KDE_PROTOCOLS, "Sources/WaylandClientProtocols/Generated/KDE.swift", "KDE", prefix_map=[("org_kde_kwin", "Kde")]
    )
    errors += generate_group(cli, WLR_PROTOCOLS, "Sources/WaylandClientProtocols/Generated/Wlr.swift", "WLR")

    if errors:
        print(f"\n{errors} error(s).")
        sys.exit(1)
    else:
        print("\nDone.")

if __name__ == "__main__":
    main()