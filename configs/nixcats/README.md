# nixcats Neovim Configuration

This directory contains the nixcats-based Neovim configuration for the nix flake.

## Structure

```
configs/nixcats/
├── README.md             # This file
├── init.lua              # Neovim entry point
└── lua/
    ├── config/
    │   ├── options.lua   # Neovim options and settings
    │   ├── keymaps.lua   # Key mappings
    │   └── plugins.lua   # Plugin loader
    └── plugins/
        ├── treesitter.lua
        ├── lsp.lua
        ├── completion.lua
        ├── colorscheme.lua
        ├── lualine.lua
        ├── bufferline.lua
        ├── noice.lua
        ├── whichkey.lua
        ├── flash.lua
        ├── yazi.lua
        ├── mini.lua
        ├── yanky.lua
        ├── comments.lua
        ├── autopairs.lua
        ├── gitsigns.lua
        ├── diffview.lua
        ├── conform.lua
        ├── lint.lua
        └── snacks.lua
```

## Integration

The nixcats configuration is integrated into the flake through:

1. **Flake Input**: Added `nixcats` input from `github:BirdeeHub/nixCats-nvim`
2. **Package Definition**: Defined in `flake.nix` under the `packages` output using `nixcats.utils.baseBuilder`
3. **Home Manager**: Integrated via `home/configs/common/nixcats.nix`

## Configuration

### Plugins

All plugins are defined in the flake's `categoryDefinitions.startupPlugins` and configured in individual Lua files under `lua/plugins/`.

### LSP Servers

Language servers are defined in `categoryDefinitions.lspsAndRuntimeDeps` and configured in `lua/plugins/lsp.lua`.

Included LSP servers:
- TypeScript/JavaScript (vtsls, eslint)
- Nix (nixd)
- Python (basedpyright)
- Bash (bash-language-server)
- Go (gopls)
- Rust (rust-analyzer)
- Lua (lua-language-server)
- And more...

### Key Mappings

Leader key is set to `<Space>`.

Key mapping categories:
- **`<leader>b`** - Buffer operations
- **`<leader>c`** - Code actions
- **`<leader>f`** - File/Find operations
- **`<leader>g`** - Git operations
- **`<leader>h`** - Git hunks
- **`<leader>s`** - Search operations
- **`<leader>u`** - UI toggles
- **`<leader>w`** - Window operations
- **`<leader>x`** - Diagnostics/Quickfix

See `lua/config/keymaps.lua` for all mappings.

## Migrated from nixvim

This configuration was migrated from the previous nixvim setup. The original nixvim files are preserved in `home/configs/common/nixvim/` but are no longer imported in the configuration.

## Customization

To customize the configuration:

1. **Add/Remove Plugins**: Edit the `startupPlugins` list in `flake.nix`
2. **Configure Plugins**: Create or edit files in `lua/plugins/`
3. **Change Settings**: Edit `lua/config/options.lua`
4. **Add Keymaps**: Edit `lua/config/keymaps.lua`
5. **Add LSP Servers**: Add to `lspsAndRuntimeDeps` in `flake.nix`

## Usage

The nixcats Neovim is automatically installed via home-manager and set as the default editor through the `EDITOR` and `VISUAL` environment variables.

To use it:
```bash
nvim
```

To rebuild after making changes:
```bash
just rebuild  # or: sudo nixos-rebuild switch --flake . --impure
```
