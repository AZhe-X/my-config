#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Syncing configs from repo to local ==="
echo ""

update_file() {
    local src="$1"  # from repo (my-config)
    local dst="$2"  # to machine (~/.config/...)
    local name="$3"

    if [ ! -f "$src" ]; then
        echo "  ⚠ $name: not found in repo, skipping."
        echo ""
        return
    fi

    if [ ! -f "$dst" ]; then
        echo "  + $name: not yet on machine"
        while true; do
            read -p "    [y] install  [d] view  [n] skip: " -n 1 choice; echo
            case $choice in
                d|D) cat "$src" | less ;;
                y|Y) mkdir -p "$(dirname "$dst")" && cp "$src" "$dst" && echo "    Installed." ; break ;;
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
            read -p "    [y] apply  [d] view diff  [n] skip: " -n 1 choice; echo
            case $choice in
                d|D) diff -u --color "$dst" "$src" | less -R ;;
                y|Y) cp "$src" "$dst" && echo "    Applied." ; break ;;
                n|N) echo "    Skipped." ; break ;;
                *) echo "    Invalid choice." ;;
            esac
        done
    fi
    echo ""
}

# Neovim: only sync config files, not plugin data
update_nvim() {
    local src="$SCRIPT_DIR/config/nvim"
    local dst="$HOME/.config/nvim"
    local name="Neovim"

    if [ ! -d "$src" ]; then
        echo "  ⚠ $name: not found in repo, skipping."
        echo ""
        return
    fi

    mkdir -p "$dst/lua/config" "$dst/lua/plugins"

    local has_diff=false
    local diff_output=""

    if ! diff -q "$src/init.lua" "$dst/init.lua" &>/dev/null 2>&1; then
        has_diff=true
        diff_output+="    init.lua differs"$'\n'
    fi

    if [ -f "$src/lazyvim.json" ] && ! diff -q "$src/lazyvim.json" "$dst/lazyvim.json" &>/dev/null 2>&1; then
        has_diff=true
        diff_output+="    lazyvim.json differs"$'\n'
    fi

    if [ -f "$src/.neoconf.json" ] && ! diff -q "$src/.neoconf.json" "$dst/.neoconf.json" &>/dev/null 2>&1; then
        has_diff=true
        diff_output+="    .neoconf.json differs"$'\n'
    fi

    if ! diff -rq "$src/lua/config/" "$dst/lua/config/" &>/dev/null 2>&1; then
        has_diff=true
        diff_output+="    lua/config/ differs"$'\n'
    fi

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
            read -p "    [y] apply  [d] view diff  [n] skip: " -n 1 choice; echo
            case $choice in
                d|D)
                    {
                        diff -u --color "$dst/init.lua" "$src/init.lua" 2>/dev/null
                        [ -f "$src/lazyvim.json" ] && diff -u --color "$dst/lazyvim.json" "$src/lazyvim.json" 2>/dev/null
                        diff -ru --color "$dst/lua/config/" "$src/lua/config/" 2>/dev/null
                        diff -ru --color "$dst/lua/plugins/" "$src/lua/plugins/" 2>/dev/null
                    } | less -R
                    ;;
                y|Y)
                    cp "$src/init.lua" "$dst/init.lua"
                    [ -f "$src/lazyvim.json" ] && cp "$src/lazyvim.json" "$dst/lazyvim.json"
                    [ -f "$src/.neoconf.json" ] && cp "$src/.neoconf.json" "$dst/.neoconf.json"
                    rm -rf "$dst/lua/config" && cp -r "$src/lua/config" "$dst/lua/config"
                    rm -rf "$dst/lua/plugins" && cp -r "$src/lua/plugins" "$dst/lua/plugins"
                    echo "    Applied."
                    break
                    ;;
                n|N) echo "    Skipped." ; break ;;
                *) echo "    Invalid choice." ;;
            esac
        done
    fi
    echo ""
}

# Yazi: only sync config files, not runtime data
update_yazi() {
    local src="$SCRIPT_DIR/config/yazi"
    local dst="$HOME/.config/yazi"
    local name="Yazi"

    if [ ! -d "$src" ]; then
        echo "  ⚠ $name: not found in repo, skipping."
        echo ""
        return
    fi

    mkdir -p "$dst"

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
            read -p "    [y] apply  [d] view diff  [n] skip: " -n 1 choice; echo
            case $choice in
                d|D)
                    for f in yazi.toml theme.toml init.lua keymap.toml; do
                        [ -f "$src/$f" ] && [ -f "$dst/$f" ] && diff -u --color "$dst/$f" "$src/$f" 2>/dev/null
                    done | less -R
                    ;;
                y|Y)
                    for f in yazi.toml theme.toml init.lua keymap.toml; do
                        [ -f "$src/$f" ] && cp "$src/$f" "$dst/$f"
                    done
                    echo "    Applied."
                    break
                    ;;
                n|N) echo "    Skipped." ; break ;;
                *) echo "    Invalid choice." ;;
            esac
        done
    fi
    echo ""
}

# repo → machine
update_file "$SCRIPT_DIR/zshrc" ~/.zshrc "zshrc"
update_file "$SCRIPT_DIR/config/ghostty/config" ~/.config/ghostty/config "Ghostty"
update_file "$SCRIPT_DIR/config/starship.toml" ~/.config/starship.toml "Starship"
update_nvim
update_yazi

echo "=== Done ==="
