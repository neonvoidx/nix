{ pkgs, inputs, ... }:
let
  inherit (inputs.nixCats) utils;
  luaPath = "${./.}";

  # Define categories and package settings
  categoryDefinitions = { pkgs, settings, categories, name, ... }@packageDef: {
    propagatedBuildInputs = { general = with pkgs; [ ripgrep fd git nodejs ]; };

    lspsAndRuntimeDeps = {
      general = with pkgs; [
        # LSPs
        bash-language-server # bashls
        vscode-langservers-extracted # jsonls, eslint, html, css
        gopls
        lua-language-server # lua_ls
        basedpyright
        yaml-language-server # yamlls
        docker-compose-language-service
        dockerfile-language-server
        neocmakelsp # neocmake
        vtsls
        terraform-ls # terraformls
        clang-tools # clangd
        zls
        emmet-language-server

        # Linters
        mermaid-cli # mmdc
        pylint
        eslint_d
        checkmake
        terraform
        yamllint
        cmake-lint # cmakelint
        cmake-format # cmakelang

        # DAP
        vscode-extensions.vadimcn.vscode-lldb # codelldb

        # Formatters
        stylua
        isort
        black
        prettierd
        markdownlint-cli2
        markdown-toc
        kdlfmt

        # Nix tools
        nil
        nixfmt-rfc-style
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

    sharedLibraries = { general = with pkgs; [ ]; };

    environmentVariables = { general = { }; };

    extraLuaPackages = { };
    extraPython3Packages = { };
  };

  packageDefinitions = {
    nixCats-nvim = { pkgs, ... }: {
      settings = {
        wrapRc = true;
        configDirName = "nixCats-nvim";
        aliases = [ "vim" "vi" "nvim" ];
      };
      categories = { general = true; };
    };
  };

  # Create the builder
  nixCatsBuilder = utils.baseBuilder luaPath {
    inherit pkgs;
    nixpkgs_version = pkgs;
    extra_pkg_config = { allowUnfree = true; };
  } categoryDefinitions packageDefinitions;

  # Build the package
  defaultPackage = nixCatsBuilder "nixCats-nvim";
in {
  home.packages = [ defaultPackage ];

  # Link config directory for your lazy.nvim configs
  xdg.configFile."nixCats-nvim".source = luaPath;
}
