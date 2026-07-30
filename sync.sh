#!/usr/bin/env bash
set -euo pipefail

# Repo dir (this script is expected to live at the root of nvim-vscode repo,
# or adjust REPO_DIR below to point at it explicitly)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSCODE_DIR="${REPO_DIR}/vscode"

# Detect WSL
IS_WSL=false
if grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
fi

# Let user choose editor
echo "Choose your editor:"
echo "  1) VS Code"
echo "  2) VSCodium"
read -rp "> " CHOICE

case "${CHOICE:-}" in
    2)
        EDITOR="vscodium"
        WIN_DIRNAME="VSCodium"
        LINUX_DIRNAME="VSCodium"
        ;;
    *)
        EDITOR="vscode"
        WIN_DIRNAME="Code"
        LINUX_DIRNAME="Code"
        ;;
esac

if [ "$IS_WSL" = true ]; then
    WIN_USER="$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')"
    VSCODE_USER_DIR="/mnt/c/Users/${WIN_USER}/AppData/Roaming/${WIN_DIRNAME}/User"
else
    VSCODE_USER_DIR="${HOME}/.config/${LINUX_DIRNAME}/User"
fi

echo "=== NVIM-VSCODE SYNC SCRIPT ==="
echo "  Editor:           $EDITOR"
echo "  Environment:      $([ "$IS_WSL" = true ] && echo WSL || echo Linux)"
echo "  Repo dir:         $REPO_DIR"
echo "  VS Code user dir: $VSCODE_USER_DIR"
echo "  Sync dir:         $VSCODE_DIR"
echo

mkdir -p "$VSCODE_DIR"

FILES="settings.json keybindings.json"

for f in $FILES; do
    SRC="${VSCODE_USER_DIR}/${f}"
    TRACKED="${VSCODE_DIR}/${f%.json}.${EDITOR}.jsonc"
    BACKUP="${VSCODE_DIR}/${f%.json}.${EDITOR}.local.jsonc"

    if [ -L "$SRC" ]; then
        # Already symlinked. Make sure it points at our tracked repo file;
        # if not (e.g. stale/manual link), leave it alone and warn.
        CURRENT_TARGET="$(readlink -f "$SRC" 2>/dev/null || true)"
        if [ "$CURRENT_TARGET" = "$(cd "$VSCODE_DIR" && pwd)/$(basename "$TRACKED")" ]; then
            echo "OK (already linked): $SRC -> $TRACKED"
        else
            echo "WARNING: $SRC is a symlink but points elsewhere ($CURRENT_TARGET). Left untouched."
        fi
        continue
    fi

    if [ -f "$SRC" ]; then
        # A real, local file already exists. Back it up (gitignored) so nothing
        # is lost, but do NOT let it become the tracked file.
        cp "$SRC" "$BACKUP"
        echo "Backed up local file: $SRC -> $BACKUP (gitignored, not tracked)"
        rm "$SRC"
    fi

    # Ensure the tracked repo file exists (empty JSONC if this is a fresh repo)
    if [ ! -f "$TRACKED" ]; then
        printf '{\n    // %s (%s) — managed by nvim-vscode\n}\n' "${f%.json}" "$EDITOR" > "$TRACKED"
        echo "Created tracked file: $TRACKED"
    fi

    ln -s "$TRACKED" "$SRC"
    echo "Symlinked: $SRC -> $TRACKED"
done

echo
echo "=== DONE ==="
