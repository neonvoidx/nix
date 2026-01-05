# nixCats Neovim Integration

## Summary

Successfully integrated the nixCats nvim configuration from `/home/neonvoid/nvim` into the main nix flake at `/home/neonvoid/nix`. The configuration is now located at `home/configs/common/nixcats/` and is automatically built and installed via home-manager.

## Changes Made

### 1. Directory Structure
```
home/configs/common/
├── nixcats.nix              # NixCats module integration (imports and builds neovim)
└── nixcats/
    ├── default.nix          # nixCats configuration (categories & packages)
    ├── init.lua             # Neovim entry point
    ├── lazy-lock.json       # Lazy.nvim plugin versions
    ├── lua/                 # Lua configuration files
    │   ├── config/         # Core config (opts, keymaps, autocmds)
    │   ├── nixCatsUtils/   # Utilities for Nix/non-Nix detection
    │   └── plugins/        # Plugin configurations
    ├── snippets/           # Custom snippets
    └── stylua.toml         # Lua formatter config
```

### 2. Flake Updates (`flake.nix`)
- Added `nixCats` input from `github:BirdeeHub/nixCats-nvim`
- Added `nixCats` to outputs parameters

### 3. Home Manager Integration
- **`home/configs/common/nixcats.nix`**: Isolated nixCats module that:
  - Imports nixCats configuration from `./nixcats`
  - Builds neovim using `nixCats.utils.baseBuilder`
  - Installs the built package via `home.packages`
  - Manages snippet symlinks
- **`home/configs/common/default.nix`**: Imports `nixcats.nix`
- **`home/common.nix`**: Clean and imports from `./configs/common`

### 4. Plugin Adjustments (`home/configs/common/nixcats/default.nix`)

**Simplified Approach**: Instead of managing all plugins through Nix, we let lazy.nvim handle plugin installation:

- **Nix provides**: LSPs, formatters, linters, and treesitter grammars (for performance)
- **Lazy.nvim handles**: All vim plugins defined in your lua files

This gives you the best of both worlds:
- Declarative system tools (LSPs, formatters) managed by Nix
- Dynamic plugin management by lazy.nvim (easier updates, no flake rebuilds)

The `nixCatsUtils/lazyCat.lua` wrapper automatically detects when running under Nix and adjusts behavior accordingly.

## Configuration Files

### Key Features
- **LSP Support**: Pre-configured with 15+ language servers (Lua, Nix, TypeScript, Go, Python, etc.) - managed by Nix
- **Formatters**: Prettier, Black, Stylua, nixpkgs-fmt, etc. - managed by Nix
- **Linters**: ESLint, Pylint, Yamllint, etc. - managed by Nix
- **Treesitter**: All grammars included - managed by Nix for better performance
- **Plugins**: All vim plugins managed by lazy.nvim from your lua configs

### Category System
The nixCats configuration uses categories to organize dependencies:
```nix
categories = {
  general = true;          # All core plugins & LSPs
  gitPlugins = true;       # Git integration
  customPlugins = true;    # Custom plugin handling
  have_nerd_font = true;   # UI with nerd font support
}
```

## Usage

The neovim package is automatically built and installed when you rebuild your system or home-manager configuration:

```bash
# For NixOS
sudo nixos-rebuild switch --flake .#void

# For home-manager only
home-manager switch --flake .#neonvoid
```

Neovim is available with aliases: `nvim`, `vim`, `vi`

## Notes

1. **Mason Disabled**: When running under Nix, Mason (the LSP/tool installer) is automatically disabled since Nix manages LSPs, formatters, and linters.

2. **Lazy.nvim Handles Plugins**: The configuration uses `nixCatsUtils/lazyCat.lua` wrapper to make lazy.nvim work seamlessly. When running under Nix, lazy.nvim still downloads and manages all your vim plugins from the lua configs.

3. **Treesitter via Nix**: Treesitter grammars are provided by Nix for better performance and reproducibility. The `withAllGrammars` option includes all available parsers.

4. **Snippets Path**: The snippets are symlinked from `assets/common/nvim/snippets/` to `~/.config/nvim/snippets/`

## Future Enhancements

If you want to manage plugins through Nix (optional):
- Add them to `startupPlugins` in `default.nix`
- Benefit: Faster startup, no internet required for plugins
- Drawback: Need to rebuild flake for plugin updates

Current approach (lazy.nvim) is simpler and more flexible for most users.
