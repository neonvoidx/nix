# nixcats configuration entry point
{ inputs, pkgs, ... }:
let
  inherit (inputs.nixcats) utils;
  luaPath = "${./.}";
  
  # Define categories for your configuration
  categoryDefinitions = { pkgs, settings, categories, name, ... }@packageDef: {
    # Propagate system level categories
    propagatedBuildInputs = {
      generalBuildInputs = with pkgs; [
        # Add any build inputs needed
      ];
    };

    # LSP servers
    lspsAndRuntimeDeps = with pkgs; [
      # Language servers
      nodePackages.vtsls
      nodePackages.eslint
      nixd
      basedpyright
      nodePackages.bash-language-server
      biome
      clang-tools
      cmake-language-server
      docker-compose-language-server
      dockerfile-language-server-nodejs
      elixir-ls
      gopls
      hyprls
      nodePackages.vscode-langservers-extracted # jsonls
      lua-language-server
      libsForQt5.qtdeclarative # qmlls
      rust-analyzer
      stylua
      
      # Additional tools
      ripgrep
      fd
      tree-sitter
    ];

    # Startup plugins (always loaded)
    startupPlugins = with pkgs.vimPlugins; [
      # Colorscheme
      (pkgs.vimUtils.buildVimPlugin {
        name = "eldritch.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "eldritch-theme";
          repo = "eldritch.nvim";
          rev = "0415fa72c348e814a7a6cc9405593a4f812fe12f";
          hash = "sha256-nEt25TqsYePRCYkCI9zEk/awFBQ9ENyYWR0hSyy24GY=";
        };
      })
      
      # Core plugins
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      lazydev-nvim
      rustaceanvim-nightly
      vim-illuminate
      lspkind-nvim
      
      # Completion
      blink-cmp
      
      # UI
      lualine-nvim
      nvim-web-devicons
      bufferline-nvim
      noice-nvim
      nui-nvim
      nvim-notify
      which-key-nvim
      nvim-colorizer-lua
      
      # Navigation
      flash-nvim
      yazi-nvim
      plenary-nvim
      
      # Editing
      nvim-autopairs
      mini-nvim
      yanky-nvim
      inc-rename-nvim
      comment-nvim
      nvim-ufo
      promise-async
      guess-indent-nvim
      
      # Git
      gitsigns-nvim
      diffview-nvim
      
      # Formatting and linting
      conform-nvim
      nvim-lint
      
      # Productivity
      snacks-nvim
      render-markdown-nvim
      persistence-nvim
      overseer-nvim
      
      # Miscellaneous
      numb-nvim
      helpview-nvim
      hmts-nvim
    ];

    # Optional plugins (can be lazy-loaded)
    optionalPlugins = { };

    # Shared libraries
    sharedLibraries = {
      general = with pkgs; [
        # Add any shared libraries needed
      ];
    };

    # Environment variables
    environmentVariables = {
      test = {
        TESTING_NIX_CATS = true;
      };
    };

    # Extra Lua packages
    extraLuaPackages = [ ];

    # Extra Python 3 packages
    extraPython3Packages = [ ];
  };

  # Default package definition
  defaultPackageDefinition = {
    categories = {
      generalBuildInputs = true;
      lspsAndRuntimeDeps = true;
      startupPlugins = true;
      optionalPlugins = true;
      sharedLibraries = true;
      environmentVariables = true;
    };
  };

  # Package definitions
  packageDefinitions = {
    nixcats = defaultPackageDefinition;
  };

  # Generate the packages
  nixCatsBuilder = utils.baseBuilder luaPath {
    inherit pkgs;
    nixpkgs_version = pkgs;
  } categoryDefinitions packageDefinitions;

  # Default package
  defaultPackage = nixCatsBuilder defaultPackageDefinition;
in
{
  # Export the package for use in home-manager or NixOS
  nixcats = defaultPackage;
}
