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

def generate(protocols_dir: Path | [Path], target_dir: Path, import_name: str | None = None):
    files = list_files_recursive(protocols_dir)

    for file in files:
        name = file.stem
        new_path = [kebab_to_camel(p) for p in file.parts[-3:-1]]
        output_dir = target_dir / Path(*new_path, kebab_to_camel(name))
        args = [binary, "client", file, output_dir]
        if import_name != None:
            args += ["--import", import_name]
        subprocess.run(args)
        # print(args)
    
# binary = ".build/release/WaylandScanner"
binary = ".build/debug/WaylandScanner"

protocols_dir = Path("/usr/share/wayland-protocols/")

subprocess.run([binary, "client", "/usr/share/wayland/wayland.xml", "Sources/SwiftWayland/Generated/Wayland"])
# generate(protocols_dir / "stable", Path.cwd() / Path("Sources/SwiftWayland/Generated"))

# generate(protocols_dir / "stable", Path.cwd() / Path("Sources/WaylandProtocols/Generated"), import_name="SwiftWayland")
# generate(protocols_dir / "staging", Path.cwd() / Path("Sources/WaylandProtocols/Generated"), import_name="SwiftWayland")
# generate(protocols_dir / "unstable", Path.cwd() / Path("Sources/WaylandProtocols/Generated"), import_name="SwiftWayland")
