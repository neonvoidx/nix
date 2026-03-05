{ den, inputs, ... }:
{
  den.aspects.neovim.homeManager =
    { pkgs, lib, ... }:
    let
      wlib = inputs.nix-wrapper-modules.lib;

      neovimModule =
        { config, wlib, ... }:
        {
          imports = [ wlib.wrapperModules.neovim ];

          # Use the nvim config repo as the configuration directory
          config.settings.config_directory = inputs.nvim-config;

          config.settings.aliases = [
            "vim"
            "vi"
          ];

          # Extra spec to expose an extraPackages option on each spec
          config.specMods =
            { config, ... }:
            {
              options.extraPackages = lib.mkOption {
                type = lib.types.listOf wlib.types.stringable;
                default = [ ];
                description = "Runtime packages to add to PATH for this spec";
              };
            };

          # Collect all extraPackages from specs and add them to the wrapper PATH
          config.extraPackages = config.specCollect (acc: v: acc ++ (v.extraPackages or [ ])) [ ];

          # LSPs, formatters, linters, and runtime tools
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
              stylua
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
              prettierd
              black
              isort
              nodePackages.markdownlint-cli2
              nixfmt

              # Linters
              nodePackages.eslint_d
              pylint
              yamllint
              checkmake
              terraform
            ];
          };
        };

      wrapper = wlib.evalModule neovimModule;
    in
    {
      home.packages = [ (wrapper.config.wrap { inherit pkgs; }) ];
    };
}
