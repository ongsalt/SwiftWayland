#!/usr/bin/env python3
import subprocess
import sys
import os
from pathlib import Path

PROTOCOLS = [
    # XDG
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
    # Xwayland
    "./Protocols/staging/xwayland-shell/xwayland-shell-v1.xml",
    "./Protocols/unstable/xwayland-keyboard-grab/xwayland-keyboard-grab-unstable-v1.xml",
    # WP
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


def to_camel(stem: str) -> str:
    return "".join(part.capitalize() for part in stem.split("-"))


def get_traits(path: str) -> str | None:
    parts = Path(path).parts
    for i, part in enumerate(parts):
        if part == "Protocols" and i + 1 < len(parts):
            stability = parts[i + 1].upper()
            return None if stability == "STABLE" else stability
    return None


def run(cli: str, args: list[str]) -> bool:
    # print(args[2])
    return subprocess.run([cli] + args).returncode == 0


def main():
    os.makedirs("Sources/SwiftWayland/Generated", exist_ok=True)
    os.makedirs("Sources/WaylandProtocols/Generated", exist_ok=True)

    print("Building WaylandScannerCLI...")
    subprocess.run(["swift", "build", "--product", "WaylandScannerCLI"], check=True)

    bin_path = subprocess.run(
        ["swift", "build", "--product", "WaylandScannerCLI", "--show-bin-path"],
        capture_output=True, text=True, check=True,
    ).stdout.strip()
    cli = os.path.join(bin_path, "WaylandScannerCLI")

    errors = 0

    ok = run(cli, ["client", "wayland.xml", "Sources/SwiftWayland/Generated/Wayland.swift", "--import", "SwiftWaylandCommon"])
    if not ok:
        errors += 1

    for proto_path in PROTOCOLS:
        name = to_camel(Path(proto_path).stem)
        output = f"Sources/WaylandProtocols/Generated/{name}.swift"
        args = ["client", proto_path, output, "--import", "SwiftWayland"]
        traits = get_traits(proto_path)
        if traits:
            args += ["--traits", traits]
        if not run(cli, args):
            errors += 1

    if errors:
        print(f"\n{errors} error(s).")
        sys.exit(1)
    else:
        print("\nDone.")


if __name__ == "__main__":
    main()
