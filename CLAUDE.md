# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal **dotfile repository** for a macOS development environment. It contains centralized configurations for terminal tools, editors, and utilities, managed as a Git repository for synchronization across machines.

## Essential Commands

### Neovim
```bash
# Install/update plugins
nvim --headless "+Lazy! sync" +qa

# Check health (LSP, treesitter, etc.)
nvim --headless "+checkhealth lsp" +qa
```

### Shell
```bash
# Reload Zsh configuration after changes
source ~/.zshrc
```

### Tmux
```bash
# Reload tmux configuration
tmux source-file ~/.tmux.conf

# Install tmux plugins (tpm)
~/.tmux/plugins/tpm/bin/install_plugins
```

## Repository Structure

```
├── .zshrc                    # Zsh shell with Zinit plugins
├── .tmux.conf               # Tmux with Nord theme
├── starship.toml            # Starship prompt config
├── nvim/                    # Neovim Lua configuration
│   ├── init.lua            # Entry point
│   ├── lua/setup/
│   │   ├── core/           # Options, keymaps, autocmds
│   │   ├── plugins/        # Plugin configs (lazy.nvim)
│   │   └── custom/         # Custom extensions
│   └── lazy-lock.json      # Plugin lockfile
├── kitty/                   # Kitty terminal
├── yazi/                    # Yazi file manager
├── zellij/                  # Zellij multiplexer
└── lazygit/                 # Lazygit config
```

## Neovim Architecture

The Neovim configuration follows a modular Lua structure:

- **Entry point**: `nvim/init.lua` loads `lua/setup/`
- **Core** (`core/`): Basic editor settings - options, keymaps, autocmds
- **Plugins** (`plugins/`): Individual plugin configurations loaded by lazy.nvim
- **Custom** (`custom/`): User extensions:
  - `highlight/`: Custom syntax highlights
  - `lsp/`: LSP configuration overrides
  - `statusline/`: Custom statusline implementation
  - `utils/`: Shared utilities (palette, path helpers)

### Plugin Management
Uses `lazy.nvim` for plugin management. Plugin specs are defined in `nvim/lua/setup/plugins/*.lua`. The lockfile `lazy-lock.json` ensures reproducible installs.

### Custom Utilities
- `utils/palette.lua`: Nord color scheme definitions used across the config
- `utils/path.lua`: Path abbreviation for statusline (e.g., `/u/y/.c/dotfile/nvim/lua/setup/c/utils/path.lua`)

## Theme and Visual Consistency

The entire configuration uses the **Nord color scheme** across:
- Tmux (custom palette in `.tmux.conf`)
- Kitty terminal
- Lazygit
- Neovim (via `plugins/theme.lua`)
- Custom highlights reference `utils/palette.lua`

## Shell Configuration

Zsh is configured with **Zinit** plugin manager:
- Key plugins: `fzf-tab`, `zsh-completions`, `zsh-autosuggestions`, `zoxide`
- `Ctrl-]` accepts autosuggestions
- Aliases: `ya` (yazi), `lg` (lazygit)
- Starship prompt is integrated at the end

## Making Changes

When modifying dotfiles:
1. Edit the configuration file directly
2. Test by reloading (see commands above)
3. Commit changes to this repository
4. Pull on other machines to sync

For Neovim plugin changes:
1. Edit plugin specs in `nvim/lua/setup/plugins/`
2. Run `nvim --headless "+Lazy! sync" +qa` to update
3. The `lazy-lock.json` will be updated automatically
