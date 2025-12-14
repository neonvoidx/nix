{ pkgs, inputs, ... }:
let
  inherit (inputs.nixCats) utils;
  luaPath = "${./.}";

  # Define categories and package settings
  categoryDefinitions =
    {
      pkgs,
      settings,
      categories,
      name,
      ...
    }@packageDef:
    {
      propagatedBuildInputs = {
        general = with pkgs; [
          ripgrep
          fd
          git
          nodejs
        ];
      };

      lspsAndRuntimeDeps = {
        general = with pkgs; [
          # LSPs
          basedpyright
          bash-language-server # bashls
          clang-tools # clangd
          docker-compose-language-service
          dockerfile-language-server
          emmet-language-server
          gopls
          lua-language-server # lua_ls
          neocmakelsp # neocmake
          nil
          terraform-ls # terraformls
          vscode-langservers-extracted # jsonls, eslint, html, css
          vtsls
          yaml-language-server # yamlls
          zls

          # Linters
          checkmake
          cmake-format # cmakelang
          cmake-lint # cmakelint
          eslint_d
          mermaid-cli # mmdc
          pylint
          terraform
          yamllint

          # DAP
          vscode-extensions.vadimcn.vscode-lldb # codelldb

          # Formatters
          black
          isort
          kdlfmt
          markdown-toc
          markdownlint-cli2
          nixfmt
          nixpkgs-fmt
          prettierd
          stylua
        ];
      };

      startupPlugins = {
        general = with pkgs.vimPlugins; [
          lazy-nvim
          # Treesitter with all grammars - managed by nix
          (nvim-treesitter.withPlugins (plugins: pkgs.vimPlugins.nvim-treesitter.allGrammars))
        ];
      };

      optionalPlugins = { };

      sharedLibraries = {
        general = with pkgs; [ ];
      };

      environmentVariables = {
        general = { };
      };

      extraLuaPackages = { };
      extraPython3Packages = { };
    };

  packageDefinitions = {
    nixCats-nvim =
      { pkgs, ... }:
      {
        settings = {
          wrapRc = true;
          configDirName = "nixCats-nvim";
          aliases = [
            "vim"
            "vi"
            "nvim"
          ];
        };
        categories = {
          general = true;
        };
      };
  };

  # Create the builder
  nixCatsBuilder = utils.baseBuilder luaPath {
    inherit pkgs;
    nixpkgs_version = pkgs;
    extra_pkg_config = {
      allowUnfree = true;
    };
  } categoryDefinitions packageDefinitions;

  # Build the package
  defaultPackage = nixCatsBuilder "nixCats-nvim";
in
{
  home.packages = [ defaultPackage ];

  # Link config directory for your lazy.nvim configs
  xdg.configFile."nixCats-nvim".source = luaPath;
}
