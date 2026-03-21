#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Checking config changes ==="
echo ""

update_file() {
    local src="$1"
    local dst="$2"
    local name="$3"

    if [ ! -f "$src" ]; then
        echo "⚠ $name: source not found ($src), skipping."
        echo ""
        return
    fi

    if [ ! -f "$dst" ]; then
        echo "+ $name: new file (not yet backed up)"
        while true; do
            read -p "  [y] add  [d] view  [n] skip: " -n 1 -r; echo
            case $REPLY in
                d|D) cat "$src" | less; ;;
                y|Y) mkdir -p "$(dirname "$dst")" && cp "$src" "$dst"; echo "  Added."; break ;;
                n|N) echo "  Skipped."; break ;;
                *) echo "  Invalid choice." ;;
            esac
        done
        echo ""
        return
    fi

    if diff -q "$src" "$dst" &>/dev/null; then
        echo "✓ $name: up to date"
        echo ""
    else
        echo "≠ $name: different"
        while true; do
            read -p "  [y] update  [d] view diff  [n] skip: " -n 1 -r; echo
            case $REPLY in
                d|D) diff --color "$dst" "$src" | less -R; ;;
                y|Y) cp "$src" "$dst"; echo "  Updated."; break ;;
                n|N) echo "  Skipped."; break ;;
                *) echo "  Invalid choice." ;;
            esac
        done
        echo ""
    fi
}

update_dir() {
    local src="$1"
    local dst="$2"
    local name="$3"

    if [ ! -d "$src" ]; then
        echo "⚠ $name: source not found ($src), skipping."
        echo ""
        return
    fi

    if [ ! -d "$dst" ]; then
        echo "+ $name: new directory (not yet backed up)"
        while true; do
            read -p "  [y] add  [n] skip: " -n 1 -r; echo
            case $REPLY in
                y|Y) cp -r "$src" "$dst"; echo "  Added."; break ;;
                n|N) echo "  Skipped."; break ;;
                *) echo "  Invalid choice." ;;
            esac
        done
        echo ""
        return
    fi

    local changes
    changes=$(diff -rq "$src" "$dst" 2>/dev/null | grep -v ".git/" | grep -v "lazy-lock.json" || true)

    if [ -z "$changes" ]; then
        echo "✓ $name: up to date"
        echo ""
    else
        echo "≠ $name: different"
        while true; do
            read -p "  [y] update  [d] view diff  [n] skip: " -n 1 -r; echo
            case $REPLY in
                d|D) diff -r --color "$dst" "$src" 2>/dev/null | grep -v ".git/" | grep -v "lazy-lock.json" | less -R; ;;
                y|Y) rm -rf "$dst" && cp -r "$src" "$dst"; echo "  Updated."; break ;;
                n|N) echo "  Skipped."; break ;;
                *) echo "  Invalid choice." ;;
            esac
        done
        echo ""
    fi
}

update_file ~/.zshrc "$SCRIPT_DIR/zshrc" "zshrc"
update_file ~/.config/ghostty/config "$SCRIPT_DIR/config/ghostty/config" "Ghostty"
update_file ~/.config/starship.toml "$SCRIPT_DIR/config/starship.toml" "Starship"
update_dir ~/.config/nvim "$SCRIPT_DIR/config/nvim" "Neovim"
update_dir ~/.config/yazi "$SCRIPT_DIR/config/yazi" "Yazi"

echo "=== Done ==="
