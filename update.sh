#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Checking config changes ==="

update_file() {
    local src="$1"
    local dst="$2"
    local name="$3"

    if [ ! -f "$src" ]; then
        echo "  ⚠ $name: source not found ($src), skipping."
        return
    fi

    if [ ! -f "$dst" ]; then
        echo "  + $name: new file"
        read -p "    Add? [y/N] " -n 1 -r; echo
        [[ $REPLY =~ ^[Yy]$ ]] && cp "$src" "$dst" && echo "    Added."
        return
    fi

    if diff -q "$src" "$dst" &>/dev/null; then
        echo "  ✓ $name: no changes"
    else
        echo "  ≠ $name: changed"
        diff --color "$dst" "$src" || true
        echo ""
        read -p "    Update? [y/N] " -n 1 -r; echo
        [[ $REPLY =~ ^[Yy]$ ]] && cp "$src" "$dst" && echo "    Updated."
    fi
}

update_dir() {
    local src="$1"
    local dst="$2"
    local name="$3"

    if [ ! -d "$src" ]; then
        echo "  ⚠ $name: source not found ($src), skipping."
        return
    fi

    local changes
    changes=$(diff -rq "$src" "$dst" 2>/dev/null | grep -v ".git/" | grep -v "lazy-lock.json" || true)

    if [ -z "$changes" ]; then
        echo "  ✓ $name: no changes"
    else
        echo "  ≠ $name: changed"
        echo "$changes"
        echo ""
        diff -r --color "$dst" "$src" 2>/dev/null | grep -v ".git/" | grep -v "lazy-lock.json" || true
        echo ""
        read -p "    Update? [y/N] " -n 1 -r; echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$dst"
            cp -r "$src" "$dst"
            echo "    Updated."
        fi
    fi
}

echo ""
update_file ~/.zshrc "$SCRIPT_DIR/zshrc" "zshrc"
update_file ~/.config/ghostty/config "$SCRIPT_DIR/config/ghostty/config" "Ghostty"
update_file ~/.config/starship.toml "$SCRIPT_DIR/config/starship.toml" "Starship"
update_dir ~/.config/nvim "$SCRIPT_DIR/config/nvim" "Neovim"

echo ""
echo "=== Done ==="
