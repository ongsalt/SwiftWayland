from pathlib import Path
import subprocess

def list_files_recursive(directory) -> list[Path]:
    # rglob('*') iterates through all files and directories recursively
    out = []
    for path in Path(directory).rglob('*'):
        if path.is_file():
            out.append(path)
    return out

def kebab_to_camel(kebab_str):
    parts = kebab_str.split('-')
    return ''.join(word.title() for word in parts)


# @WaylandProtocol("<protocol>...LinuxDmaBuf<protocol>")
# #if Staging
# extension ColorManagement {
#   
# }
# #endif

# so we need to emit `enum ColorManagement {}` as well 

def generate_file(path: str, content: str):
    pass
    
# binary = ".build/release/WaylandScanner"
binary = ".build/debug/WaylandScanner"

protocols_dir = Path("./Protocols")

staging = {
    "Xdg": {
        "Activation": {
            "V1": "./protocols/staging/xdg-activation/xdg-activation-v1.xml"
        }
    }
}

# subprocess.run([binary, "client", "/usr/share/wayland/wayland.xml", "Sources/SwiftWayland/Generated/Wayland"])

generate(protocols_dir / "stable", Path.cwd() / Path("Sources/WaylandProtocols/Generated"), import_name="SwiftWayland")
generate(protocols_dir / "staging", Path.cwd() / Path("Sources/WaylandProtocols/Generated"), import_name="SwiftWayland")
generate(protocols_dir / "unstable", Path.cwd() / Path("Sources/WaylandProtocols/Generated"), import_name="SwiftWayland")

# linux_dmabuf_unstable_v1
