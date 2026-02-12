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

def generate(protocols_dir: Path, target_dir: Path, import_name: str | None = None):
    files = list_files_recursive(protocols_dir)

    for file in files:
        name = file.stem
        new_path = [kebab_to_camel(p) for p in file.parts[-3:-1]]
        output_dir = target_dir / Path(*new_path, kebab_to_camel(name))
        args = [binary, "client", file, output_dir]
        if import_name != None:
            args += ["--import", import_name]
        subprocess.run(args)
    
binary = ".build/x86_64-unknown-linux-gnu/release/WaylandScanner"
protocols_dir = "/usr/share/wayland/"
protocols_dir = "/usr/share/wayland-protocols/"

generate(Path("/usr/share/wayland/"), Path.cwd() / Path("Sources/SwiftWayland/Generated"))

# generate(protocols_dir / "stable", Path.cwd() / Path("Sources/SwiftWayland/Generated"), import_name="SwiftWaylandCore")
# generate(protocols_dir / "staging", Path.cwd() / Path("Sources/WaylandProtocols/Generated"), import_name="SwiftWaylandCore")
# generate(protocols_dir / "unstable", Path.cwd() / Path("Sources/WaylandProtocols/Generated"), import_name="SwiftWaylandCore")
