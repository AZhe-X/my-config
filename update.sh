#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Checking config changes ==="
echo ""

update_file() {
    local src="$1"
    local dst="$2"
    local name="$3"

    if [ ! -f "$src" ]; then
        echo "  ⚠ $name: source not found ($src), skipping."
        echo ""
        return
    fi

    if [ ! -f "$dst" ]; then
        echo "  + $name: new file (not yet backed up)"
        while true; do
            read -p "    [y] add  [d] view  [n] skip: " choice
            case $choice in
                d|D) cat "$src" | less ;;
                y|Y) mkdir -p "$(dirname "$dst")" && cp "$src" "$dst" && echo "    Added." ; break ;;
                n|N) echo "    Skipped." ; break ;;
                *) echo "    Invalid choice." ;;
            esac
        done
        echo ""
        return
    fi

    if diff -q "$src" "$dst" &>/dev/null; then
        echo "  ✓ $name: up to date"
    else
        echo "  ≠ $name: different"
        while true; do
            read -p "    [y] update  [d] view diff  [n] skip: " choice
            case $choice in
                d|D) diff -u --color "$dst" "$src" | less -R ;;
                y|Y) cp "$src" "$dst" && echo "    Updated." ; break ;;
                n|N) echo "    Skipped." ; break ;;
                *) echo "    Invalid choice." ;;
            esac
        done
    fi
    echo ""
}

# Neovim: only back up config files, not plugin data
update_nvim() {
    local src="$HOME/.config/nvim"
    local dst="$SCRIPT_DIR/config/nvim"
    local name="Neovim"

    if [ ! -d "$src" ]; then
        echo "  ⚠ $name: source not found, skipping."
        echo ""
        return
    fi

    # Compare only the config files we care about
    local has_diff=false
    local diff_output=""

    # Check init.lua
    if ! diff -q "$src/init.lua" "$dst/init.lua" &>/dev/null 2>&1; then
        has_diff=true
        diff_output+="    init.lua differs"$'\n'
    fi

    # Check lua/config/
    if ! diff -rq "$src/lua/config/" "$dst/lua/config/" &>/dev/null 2>&1; then
        has_diff=true
        diff_output+="    lua/config/ differs"$'\n'
    fi

    # Check lua/plugins/
    if ! diff -rq "$src/lua/plugins/" "$dst/lua/plugins/" &>/dev/null 2>&1; then
        has_diff=true
        diff_output+="    lua/plugins/ differs"$'\n'
    fi

    if [ "$has_diff" = false ]; then
        echo "  ✓ $name: up to date"
    else
        echo "  ≠ $name: different"
        echo "$diff_output"
        while true; do
            read -p "    [y] update  [d] view diff  [n] skip: " choice
            case $choice in
                d|D)
                    {
                        diff -u --color "$dst/init.lua" "$src/init.lua" 2>/dev/null
                        diff -ru --color "$dst/lua/config/" "$src/lua/config/" 2>/dev/null
                        diff -ru --color "$dst/lua/plugins/" "$src/lua/plugins/" 2>/dev/null
                    } | less -R
                    ;;
                y|Y)
                    cp "$src/init.lua" "$dst/init.lua"
                    rm -rf "$dst/lua/config" && cp -r "$src/lua/config" "$dst/lua/config"
                    rm -rf "$dst/lua/plugins" && cp -r "$src/lua/plugins" "$dst/lua/plugins"
                    echo "    Updated."
                    break
                    ;;
                n|N) echo "    Skipped." ; break ;;
                *) echo "    Invalid choice." ;;
            esac
        done
    fi
    echo ""
}

# Yazi: only back up config files, not runtime data
update_yazi() {
    local src="$HOME/.config/yazi"
    local dst="$SCRIPT_DIR/config/yazi"
    local name="Yazi"

    if [ ! -d "$src" ]; then
        echo "  ⚠ $name: source not found, skipping."
        echo ""
        return
    fi

    local has_diff=false
    local diff_output=""

    for f in yazi.toml theme.toml init.lua keymap.toml; do
        if [ -f "$src/$f" ]; then
            if [ ! -f "$dst/$f" ] || ! diff -q "$src/$f" "$dst/$f" &>/dev/null; then
                has_diff=true
                diff_output+="    $f differs"$'\n'
            fi
        fi
    done

    if [ "$has_diff" = false ]; then
        echo "  ✓ $name: up to date"
    else
        echo "  ≠ $name: different"
        echo "$diff_output"
        while true; do
            read -p "    [y] update  [d] view diff  [n] skip: " choice
            case $choice in
                d|D)
                    for f in yazi.toml theme.toml init.lua keymap.toml; do
                        [ -f "$src/$f" ] && [ -f "$dst/$f" ] && diff -u --color "$dst/$f" "$src/$f" 2>/dev/null
                    done | less -R
                    ;;
                y|Y)
                    mkdir -p "$dst"
                    for f in yazi.toml theme.toml init.lua keymap.toml; do
                        [ -f "$src/$f" ] && cp "$src/$f" "$dst/$f"
                    done
                    echo "    Updated."
                    break
                    ;;
                n|N) echo "    Skipped." ; break ;;
                *) echo "    Invalid choice." ;;
            esac
        done
    fi
    echo ""
}

update_file ~/.zshrc "$SCRIPT_DIR/zshrc" "zshrc"
update_file ~/.config/ghostty/config "$SCRIPT_DIR/config/ghostty/config" "Ghostty"
update_file ~/.config/starship.toml "$SCRIPT_DIR/config/starship.toml" "Starship"
update_nvim
update_yazi

echo "=== Done ==="
