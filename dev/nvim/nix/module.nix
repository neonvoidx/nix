# This module is imported by flake.nix via:
#   nixpkgs.lib.modules.importApply ./nix/module.nix inputs
#
# The first argument (_inputs) is the flake inputs set, available for
# fetching extra plugins or referencing other flake outputs.
_inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.wrapperModules.neovim ];

  # Use the repo root as the neovim config directory (init.lua, lua/, etc.)
  # ./.. resolves relative to this file (nix/module.nix) → repo root
  config.settings.config_directory = ./..;

  config.settings.aliases = [
    "vim"
    "vi"
  ];

  # Add an `extraPackages` field to every spec, collected into the wrapper PATH
  config.specMods =
    { config, ... }:
    {
      options.extraPackages = lib.mkOption {
        type = lib.types.listOf wlib.types.stringable;
        default = [ ];
        description = "Runtime packages to suffix to PATH for this spec";
      };
    };

  config.extraPackages = config.specCollect (acc: v: acc ++ (v.extraPackages or [ ])) [ ];

  # ── LSPs, formatters, linters, and runtime tools ──────────────────────────
  config.specs.dev-tools = {
    data = null;
    extraPackages = with pkgs; [
      # Core tools
      universal-ctags
      ripgrep
      fd
      tree-sitter

      # LSPs
      lua-language-server
      nixd
      nodePackages.bash-language-server
      nodePackages.vscode-langservers-extracted # json, html, css, eslint
      nodePackages.typescript-language-server
      gdtoolkit_4
      gopls
      basedpyright
      yaml-language-server
      dockerfile-language-server
      terraform-ls
      clang-tools
      zls

      # Formatters
      stylua
      prettierd
      black
      isort
      nodePackages.markdownlint-cli2
      nixfmt-rfc-style

      # Linters
      nodePackages.eslint_d
      pylint
      yamllint
      checkmake
      terraform
    ];
  };
}
