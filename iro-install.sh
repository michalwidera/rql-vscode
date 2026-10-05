#!/usr/bin/env bash
set -euo pipefail

# Instaluje gotowy release iro4cli dla Linuksa, bez budowania ze zrodel.
# Uzycie: ./iro-install.sh [latest|v0.4.1]
# IRO_INSTALL_DIR zmienia katalog docelowy (domyslnie ~/.local/bin).

usage() {
    echo "Uzycie: $0 [latest|tag-wydania]"
    echo "Katalog instalacji: IRO_INSTALL_DIR (domyslnie ~/.local/bin)"
}

die() { echo "[ERROR] $*" >&2; exit 1; }
info() { echo "[INFO] $*" >&2; }

if [[ "${1:-}" == --help || "${1:-}" == -h ]]; then
    usage
    exit 0
fi
[[ $# -le 1 ]] || { usage >&2; exit 1; }

version="${1:-latest}"
[[ "$version" != -* ]] || die "Nieznana opcja: $version"
install_dir="${IRO_INSTALL_DIR:-$HOME/.local/bin}"

for dependency in curl python3 install; do
    command -v "$dependency" >/dev/null || die "Brak wymaganego polecenia: $dependency"
done
[[ "$(uname -s)" == Linux ]] || die "Instalator obsluguje Linux (takze WSL)."

case "$(uname -m)" in
    x86_64|amd64) platform=linux-x64 ;;
    aarch64|arm64) platform=linux-arm64 ;;
    *) die "Brak paczki iro4cli dla architektury $(uname -m)." ;;
esac
if compgen -G '/lib/ld-musl-*.so.1' >/dev/null; then
    [[ "$platform" == linux-x64 ]] || die "Brak paczki iro4cli dla Linux ARM64 z musl."
    platform=linux-musl-x64
fi

release_api=https://api.github.com/repos/c272/iro4cli/releases
if [[ "$version" == latest ]]; then
    release_api+=/latest
else
    release_api+="/tags/$version"
fi

work_dir=$(mktemp -d "${TMPDIR:-/tmp}/iro-install.XXXXXX")
trap 'rm -rf -- "$work_dir"' EXIT

info "Pobieranie metadanych wydania $version..."
curl --fail --silent --show-error --location --retry 3 --connect-timeout 15 \
    --max-time 60 "$release_api" -o "$work_dir/release.json"
download_url=$(python3 - "$work_dir/release.json" "$platform.zip" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as file:
    release = json.load(file)
for asset in release.get("assets", []):
    if asset["name"] == sys.argv[2]:
        print(asset["browser_download_url"])
        break
else:
    sys.exit(f"Brak paczki {sys.argv[2]} w wydaniu {release.get('tag_name', '?')}.")
PY
)

info "Pobieranie $download_url..."
curl --fail --silent --show-error --location --retry 3 --connect-timeout 15 \
    --max-time 180 "$download_url" -o "$work_dir/release.zip"
python3 - "$work_dir/release.zip" "$work_dir" <<'PY'
from pathlib import Path
import shutil
import sys
import zipfile

with zipfile.ZipFile(sys.argv[1]) as archive:
    binaries = [name for name in archive.namelist() if Path(name).name == "iro"]
    if len(binaries) != 1:
        sys.exit("Paczka musi zawierac dokladnie jeden plik wykonywalny iro.")
    binary = binaries[0]
    config = str(Path(binary).with_name("iro.dll.config"))
    for name in [binary, config]:
        if name in archive.namelist():
            with archive.open(name) as source, (Path(sys.argv[2]) / Path(name).name).open("wb") as target:
                shutil.copyfileobj(source, target)
PY

chmod +x "$work_dir/iro"
"$work_dir/iro" --help >/dev/null
install -d "$install_dir"
if [[ -f "$work_dir/iro.dll.config" ]]; then
    install -m 644 "$work_dir/iro.dll.config" "$install_dir/iro.dll.config"
fi
install -m 755 "$work_dir/iro" "$install_dir/iro"
info "Zainstalowano: $install_dir/iro"
info "Pomoc: $install_dir/iro --help"
case ":$PATH:" in
    *":$install_dir:"*) ;;
    *) info "Dodaj katalog $install_dir do PATH, aby wywolywac polecenie iro." ;;
esac
