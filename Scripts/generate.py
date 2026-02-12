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


binary = ".build/x86_64-unknown-linux-gnu/release/WaylandScanner"
protocols_dir = "/usr/share/wayland-protocols/"
target_dir = Path.cwd() / Path("Sources/SwiftWayland/Generated")
print(target_dir)
files = list_files_recursive(protocols_dir)

for file in files:
    name = file.stem
    new_path = [kebab_to_camel(p) for p in file.parts[-3:-1]]
    output_dir = target_dir / Path(*new_path, kebab_to_camel(name))

    subprocess.run([binary, "client", file, output_dir])
    
