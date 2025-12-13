# nixCats Neovim Configuration

This directory contains your nixCats-managed Neovim configuration with lazy.nvim support.

## Structure

```
nixcats/
├── default.nix          # Nix configuration for nixCats
├── init.lua             # Main entry point
├── lua/
│   └── plugins/         # Your LazyVim plugin configurations
│       └── example.lua  # Example plugin config
└── README.md            # This file
```

## How to Use

1. **Copy your existing config**: Drop your lazy.nvim `lua/plugins/` files here
2. **Copy your init.lua content**: Settings, keymaps, autocmds into this `init.lua`
3. **Add LSPs and tools**: Edit `default.nix` to add LSPs, formatters, etc.
4. **Rebuild**: Run `nixos-rebuild switch` on your VM

## Adding LSPs and Tools

Edit `default.nix` in the `lspsAndRuntimeDeps.general` section:

```nix
lspsAndRuntimeDeps = {
  general = with pkgs; [
    lua-language-server
    nil
    stylua
    nixfmt-rfc-style
    # Add more LSPs here:
    # typescript-language-server
    # rust-analyzer
    # pyright
  ];
};
```

## Adding System Dependencies

Some plugins need system packages. Add them in `propagatedBuildInputs.general`:

```nix
propagatedBuildInputs = {
  general = with pkgs; [
    ripgrep
    fd
    git
    # Add more tools here
  ];
};
```

## lazy.nvim Plugin Configuration

Your existing lazy.nvim plugin specs work as-is. Just copy them to `lua/plugins/`.

Example (`lua/plugins/lsp.lua`):

```lua
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- LSPs are on PATH via nixCats
      require("lspconfig").lua_ls.setup({})
      require("lspconfig").nil_ls.setup({})
    end,
  },
}
```

## Tips

- **Don't use `:Mason`**: LSPs are managed by Nix in `default.nix`
- **Plugin management**: lazy.nvim handles plugins, but you can also add them via Nix
- **Updates**: Plugin versions are pinned by the flake.lock
- **Config location**: Your config lives at `~/.config/nixCats-nvim/`

## Next Steps

1. Copy your `~/.config/nvim/lua/` directory here
2. Copy your `~/.config/nvim/init.lua` content here
3. Remove Mason-related configs (LSPs managed by Nix)
4. Run `nixos-rebuild switch`
5. Launch with `nvim`

## Troubleshooting

- **Plugins not loading**: Check lazy.nvim spec in `init.lua`
- **LSP not found**: Add it to `default.nix` lspsAndRuntimeDeps
- **Command not found**: Add to propagatedBuildInputs in `default.nix`
- **Config not syncing**: The config dir is symlinked from the nix store
