#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# build.sh — budowanie i instalacja rozszerzenia RQL dla VS Code
#
# Użycie:
#   ./build.sh          — zbuduj .vsix i zainstaluj
#   ./build.sh build    — tylko zbuduj .vsix
#   ./build.sh install  — zainstaluj ostatnio zbudowany .vsix
#   ./build.sh check    — sprawdź zależności bez budowania
# ---------------------------------------------------------------------------

ACTION="${1:-all}"

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; RESET='\033[0m'

info()  { echo -e "${GREEN}[INFO]${RESET}  $*" >&2; }
warn()  { echo -e "${YELLOW}[WARN]${RESET}  $*" >&2; }
error() { echo -e "${RED}[ERROR]${RESET} $*" >&2; }
die()   { error "$*"; exit 1; }

# ---------------------------------------------------------------------------
# Wykrywanie środowiska WSL
# ---------------------------------------------------------------------------
is_wsl() {
    grep -qi microsoft /proc/version 2>/dev/null
}

# Zwraca true jeśli podany plik pochodzi z /mnt/c (Windows)
is_windows_binary() {
    local bin
    bin=$(command -v "$1" 2>/dev/null) || return 1
    [[ "$bin" == /mnt/* ]]
}

# ---------------------------------------------------------------------------
# Sprawdzenie zależności
# ---------------------------------------------------------------------------
check_deps() {
    local ok=true

    info "Sprawdzanie zależności..."

    # Python 3
    if command -v python3 &>/dev/null; then
        local pyver
        pyver=$(python3 --version 2>&1)
        info "python3 : $pyver"
    else
        error "python3 nie znaleziony — wymagany do budowania"
        ok=false
    fi

    # VS Code CLI
    if command -v code &>/dev/null; then
        local codever
        codever=$(code --version 2>&1 | head -1)
        if is_wsl && is_windows_binary code; then
            # W WSL 'code' z Windows działa przez Remote — to poprawne zachowanie
            info "code    : $codever (VS Code Server / WSL)"
        else
            info "code    : $codever"
        fi
    else
        warn "code nie znaleziony — instalacja rozszerzenia będzie niemożliwa"
        warn "Zainstaluj VS Code i upewnij się, że 'code' jest w PATH"
        warn "  https://code.visualstudio.com/"
    fi

    # Opcjonalnie: natywny npm/vsce (nie jest wymagany)
    if command -v npm &>/dev/null && ! is_windows_binary npm; then
        local npmver
        npmver=$(npm --version 2>&1)
        info "npm     : $npmver (Linux — można użyć 'vsce package')"
    else
        if is_wsl && is_windows_binary npm 2>/dev/null; then
            warn "npm     : znaleziony, ale pochodzi z Windows — pomijam (znany problem z WSL)"
        else
            warn "npm     : nie znaleziony — budowanie przez Python (build.py)"
        fi
    fi

    # Sprawdzenie pliku gramatyki
    local grammar="syntaxes/rql.tmLanaguage"
    if [[ -f "$grammar" ]]; then
        info "grammar : $grammar — OK"
    else
        error "Brakuje pliku: $grammar"
        ok=false
    fi

    # package.json
    if [[ -f "package.json" ]]; then
        info "package : package.json — OK"
    else
        error "Brakuje pliku: package.json"
        ok=false
    fi

    $ok || die "Niektóre wymagania nie są spełnione."
    info "Wszystkie wymagania spełnione."
}

# ---------------------------------------------------------------------------
# Budowanie .vsix
# ---------------------------------------------------------------------------
build_vsix() {
    info "Budowanie pakietu .vsix..."

    local use_vsce=false
    if command -v npm &>/dev/null && ! is_windows_binary npm; then
        # Sprawdź czy vsce jest zainstalowane lokalnie lub globalnie
        if command -v vsce &>/dev/null && ! is_windows_binary vsce; then
            use_vsce=true
        elif npm list -g @vscode/vsce &>/dev/null 2>&1; then
            use_vsce=true
        fi
    fi

    if $use_vsce; then
        info "Metoda: vsce"
        vsce package --allow-missing-repository --no-git-tag-version >&2
    else
        info "Metoda: python3 build.py"
        python3 build.py >&2
    fi

    # Znajdź zbudowany plik
    local vsix
    vsix=$(ls -t ./*.vsix 2>/dev/null | head -1) || die "Nie znaleziono pliku .vsix po budowaniu."
    info "Zbudowano: $vsix"
    echo "$vsix"
}

# ---------------------------------------------------------------------------
# Instalacja .vsix
# ---------------------------------------------------------------------------
install_vsix() {
    local vsix="${1:-}"

    if [[ -z "$vsix" ]]; then
        vsix=$(ls -t ./*.vsix 2>/dev/null | head -1) || die "Brak pliku .vsix do instalacji. Najpierw uruchom: ./build.sh build"
    fi

    [[ -f "$vsix" ]] || die "Plik nie istnieje: $vsix"

    if ! command -v code &>/dev/null; then
        warn "Polecenie 'code' niedostępne — pomiń instalację automatyczną."
        warn "Zainstaluj ręcznie: Extensions → ... → Install from VSIX → $vsix"
        return
    fi

    info "Instalowanie: $vsix"
    code --install-extension "$vsix"
    info "Instalacja zakończona. Przeładuj VS Code: Ctrl+Shift+P → Developer: Reload Window"
}

# ---------------------------------------------------------------------------
# Główna logika
# ---------------------------------------------------------------------------
cd "$(dirname "$0")"

case "$ACTION" in
    check)
        check_deps
        ;;
    build)
        check_deps
        build_vsix > /dev/null
        ;;
    install)
        install_vsix
        ;;
    all|"")
        check_deps
        VSIX=$(build_vsix)
        install_vsix "$VSIX"
        ;;
    *)
        echo "Użycie: $0 [build|install|check|all]"
        exit 1
        ;;
esac
