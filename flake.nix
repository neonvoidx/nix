{
  description = "The Void Hungers";

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # TODO remove these 2 after patches
    nixpkgs-vesktop.url = "github:nixos/nixpkgs/pull/476347/head";
    nixpkgs-sgdboop.url = "github:fxzzi/nixpkgs/fix-sgdboop";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-search-tv = {
      url = "github:3timeslazy/nix-search-tv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixvim = {
    #   url = "github:nix-community/nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixcats = {
      url = "github:BirdeeHub/nixCats-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      # nixvim,
      nixcats,
      spicetify-nix,
      nix-search-tv,
      nix-colors,
      nix-index-database,
      sops-nix,
      ...
    }@inputs:
    let
      username = "neonvoid";
      macUsername = "jrreed";
      specialArgs = {
        inherit inputs;
        inherit username;
      };

      mkHost =
        hostname:
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [ nur.overlays.default ];
            }
            ./hosts/${hostname}
            ./modules/programs/noctalia.nix
            ./home/${username}/nixos.nix
            spicetify-nix.nixosModules.default
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.backupFileExtension = "backup";
              home-manager.backupCommand = "${nixpkgs.legacyPackages.x86_64-linux.bash}/bin/bash -c 'rm -f \"$1.backup\" && mv \"$1\" \"$1.backup\"' -- ";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs =
                inputs
                // specialArgs
                // {
                  inherit hostname;
                  inherit nix-colors;
                  inherit nix-index-database;
                  # nixvimOptions = nixvim.packages.x86_64-linux.options-json + /share/doc/nixos/options.json;
                };
              home-manager.users.${username} = import ./home/${username}/home.nix;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        void = mkHost "void";
        voidframe = mkHost "voidframe";
      };

      # Standalone home-manager configuration for macOS (jrreed user)
      homeConfigurations = {
        "${macUsername}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Use x86_64-darwin for Intel Mac
          extraSpecialArgs = {
            inherit inputs;
            username = macUsername;
            inherit nix-colors;
            # nixvimOptions = nixvim.packages.aarch64-darwin.options-json + /share/doc/nixos/options.json;
          };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [ nur.overlays.default ];
            }
            sops-nix.homeManagerModules.sops
            ./home/${macUsername}/home.nix
          ];
        };
      };

      # nixcats neovim packages
      packages = 
        let
          inherit (nixcats) utils;
          luaPath = "${./configs/nixcats}";
          
          mkNixCats = system: 
            let
              pkgs = nixpkgs.legacyPackages.${system};
              
              categoryDefinitions = { pkgs, settings, categories, name, ... }@packageDef: {
                lspsAndRuntimeDeps = with pkgs; [
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
                  nodePackages.vscode-langservers-extracted
                  lua-language-server
                  libsForQt5.qtdeclarative
                  rust-analyzer
                  stylua
                  ripgrep
                  fd
                  tree-sitter
                ];

                startupPlugins = with pkgs.vimPlugins; [
                  (pkgs.vimUtils.buildVimPlugin {
                    name = "eldritch.nvim";
                    src = pkgs.fetchFromGitHub {
                      owner = "eldritch-theme";
                      repo = "eldritch.nvim";
                      rev = "0415fa72c348e814a7a6cc9405593a4f812fe12f";
                      hash = "sha256-nEt25TqsYePRCYkCI9zEk/awFBQ9ENyYWR0hSyy24GY=";
                    };
                  })
                  nvim-treesitter.withAllGrammars
                  nvim-lspconfig
                  lazydev-nvim
                  rustaceanvim-nightly
                  vim-illuminate
                  lspkind-nvim
                  blink-cmp
                  lualine-nvim
                  nvim-web-devicons
                  bufferline-nvim
                  noice-nvim
                  nui-nvim
                  nvim-notify
                  which-key-nvim
                  nvim-colorizer-lua
                  flash-nvim
                  yazi-nvim
                  plenary-nvim
                  nvim-autopairs
                  mini-nvim
                  yanky-nvim
                  inc-rename-nvim
                  comment-nvim
                  nvim-ufo
                  promise-async
                  guess-indent-nvim
                  gitsigns-nvim
                  diffview-nvim
                  conform-nvim
                  nvim-lint
                  snacks-nvim
                  render-markdown-nvim
                  persistence-nvim
                  overseer-nvim
                  numb-nvim
                  helpview-nvim
                  hmts-nvim
                ];
              };

              defaultPackageDefinition = {
                categories = {
                  lspsAndRuntimeDeps = true;
                  startupPlugins = true;
                };
              };
            in
            utils.baseBuilder luaPath {
              inherit pkgs;
            } categoryDefinitions { nixCats = defaultPackageDefinition; };
        in
        {
          x86_64-linux.nixCats = (mkNixCats "x86_64-linux").nixCats;
          aarch64-darwin.nixCats = (mkNixCats "aarch64-darwin").nixCats;
        };
    };
