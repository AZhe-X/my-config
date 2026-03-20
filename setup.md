# New Mac Setup Guide

## Homebrew Packages

```bash
brew install node           # (managed by fnm, but needed initially)
brew install fnm            # Node version manager
brew install uv             # Python version/package manager
brew install rustup         # Rust toolchain manager
brew install starship       # Shell prompt
brew install neovim         # Editor
```

After installing rustup:
```bash
rustup-init
```

After installing fnm, add to ~/.zshrc:
```bash
eval "$(fnm env --use-on-cd)"
```

After installing starship, add to ~/.zshrc:
```bash
eval "$(starship init zsh)"
```

## Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Plugins (git clone into Oh My Zsh custom dir)

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Then in ~/.zshrc:
```bash
plugins=(git zsh-autosuggestions zsh-syntax-highlighting z npm rust)
```

## Fonts

- Liga SFMono Nerd Font (Ligaturized): https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized

## Ghostty

Install from https://ghostty.org. Config at ~/.config/ghostty/config.

## SSH

1. Copy keys to ~/.ssh/
2. Set permissions:
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config ~/.ssh/*_id
chmod 644 ~/.ssh/*.pub
```
3. Add default key to agent:
```bash
ssh-add ~/.ssh/el_id
```

## Neovim

Plugins auto-install via lazy.nvim on first launch.

LSP servers installed via Mason (open nvim, run :Mason):
- basedpyright (Python)
- vtsls (TypeScript/React/Next.js)
- eslint-lsp (ESLint)
- rust-analyzer (Rust)
- texlab (LaTeX)
- tinymist (Typst)
- marksman (Markdown)

## Config Files

| File | Location |
|---|---|
| zshrc | ~/.zshrc |
| Ghostty | ~/.config/ghostty/config |
| Starship | ~/.config/starship.toml |
| Neovim | ~/.config/nvim/ |
| SSH | ~/.ssh/config |
| Git ignore | ~/.gitignore_global |

## Not in this backup

- ~/.ssh/ keys (copy separately, do not commit)
- ~/.gitconfig (set up per machine)
- ~/.p10k.zsh (archived in Worker/p10k-archive/)
