#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== New Mac Setup ==="
echo "Script directory: $SCRIPT_DIR"
echo ""

# ─── Homebrew ────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed, skipping."
fi

# ─── Brew packages ───────────────────────────────────────────
echo ""
echo "Installing Homebrew packages..."
brew install git gh fnm uv neovim starship git-delta tree-sitter-cli direnv imagemagick librsvg fzf bat ripgrep tmux
brew install rustup

# macism (CJK input method switcher for im-select.nvim)
brew tap laishulu/homebrew
brew install macism

# Apps
brew install ghostty
brew install 1password
brew install obsidian
brew install sublime-text
brew install iina
brew install skim
brew install dropbox

# Optional apps
read -p "Install Discord? [y/N] " -n 1 -r; echo
[[ $REPLY =~ ^[Yy]$ ]] && brew install discord

read -p "Install Zoom? [y/N] " -n 1 -r; echo
[[ $REPLY =~ ^[Yy]$ ]] && brew install zoom

read -p "Install JetBrains Toolbox? [y/N] " -n 1 -r; echo
[[ $REPLY =~ ^[Yy]$ ]] && brew install jetbrains-toolbox

# Other tools
brew install tree texlive claude-code btop yazi

read -p "Install GAP (math software)? [y/N] " -n 1 -r; echo
[[ $REPLY =~ ^[Yy]$ ]] && brew install gap-system/gap/gap

# ─── Rust ────────────────────────────────────────────────────
echo ""
echo "Setting up Rust..."
if ! command -v rustc &>/dev/null; then
    rustup-init -y
else
    echo "Rust already installed, skipping."
fi

# ─── Oh My Zsh ───────────────────────────────────────────────
echo ""
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed, skipping."
fi

# ─── Zsh plugins ─────────────────────────────────────────────
echo ""
echo "Installing Zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed, skipping."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting already installed, skipping."
fi

# ─── Fonts ───────────────────────────────────────────────────
echo ""
echo "Installing fonts..."
brew install font-sf-mono-nerd-font-ligaturized

# ─── Config files ────────────────────────────────────────────
echo ""
echo "Copying config files..."

# zshrc
cp "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"
echo "  Copied zshrc"

# Ghostty
mkdir -p "$HOME/.config/ghostty"
cp "$SCRIPT_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"
echo "  Copied Ghostty config"

# Starship
cp "$SCRIPT_DIR/config/starship.toml" "$HOME/.config/starship.toml"
echo "  Copied Starship config"

# Neovim
mkdir -p "$HOME/.config/nvim"
cp -r "$SCRIPT_DIR/config/nvim/"* "$SCRIPT_DIR/config/nvim/".[^.]* "$HOME/.config/nvim/" 2>/dev/null
echo "  Copied Neovim config"

# Yazi
mkdir -p "$HOME/.config/yazi"
cp "$SCRIPT_DIR/config/yazi/"* "$HOME/.config/yazi/"
ya pack -a BennyOe/tokyo-night
echo "  Copied Yazi config and installed theme"

# Tmux
cp "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"
echo "  Copied tmux config"

# Install TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    echo "  Installed TPM"
else
    echo "  TPM already installed, skipping."
fi
echo "  NOTE: Open tmux and press 'Ctrl+Space I' to install tmux plugins"

# ─── Node (via fnm) ─────────────────────────────────────────
echo ""
echo "Installing Node LTS via fnm..."
eval "$(fnm env)"
fnm install --lts

# ─── Python (via uv) ────────────────────────────────────────
echo ""
echo "Installing Python via uv..."
uv python install 3.14

# ─── Git config ──────────────────────────────────────────────
echo ""
echo "Setting up Git..."
git config --global init.defaultBranch main
git config --global core.excludesfile ~/Dropbox/40.Developer/42.Configuration/gitignore/Global/macOS.gitignore

read -p "Enter git user.name: " git_name
git config --global user.name "$git_name"

read -p "Enter git user.email: " git_email
git config --global user.email "$git_email"

# Delta (diff tool)
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.dark true
git config --global merge.conflictStyle zdiff3

# Git aliases
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# ─── SSH ─────────────────────────────────────────────────────
echo ""
echo "Setting up SSH..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
echo "  NOTE: Copy your SSH keys manually to ~/.ssh/"
echo "  Then run:"
echo "    chmod 600 ~/.ssh/*_id"
echo "    chmod 644 ~/.ssh/*.pub"
echo "    ssh-add ~/.ssh/el_id"

# ─── Neovim Mason LSP servers ────────────────────────────────
echo ""
echo "Installing Mason LSP servers..."
nvim --headless -c "MasonInstall basedpyright vtsls eslint-lsp rust-analyzer texlab tinymist marksman" -c qall

# ─── Done ────────────────────────────────────────────────────
echo ""
echo "=== Setup complete! ==="
echo ""
echo "Remaining manual steps:"
echo "  1. Install Liga SFMono Nerd Font (if not done)"
echo "  2. Copy SSH keys to ~/.ssh/ and set permissions"
echo "  3. Set git user.name and user.email"
echo "  4. Open nvim and install Mason LSP servers"
echo "  5. Run 'gh auth login' to authenticate GitHub CLI"
echo "  6. Restart your terminal"
