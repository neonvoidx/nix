{
  description = "The Void Hungers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scopebuddy = {
      url = "github:OpenGamingCollective/ScopeBuddy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-versions = {
      url = "github:vic/nix-versions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-config = {
      url = "github:neonvoidx/nvim";
      flake = false;
    };
    hytale-launcher = {
      url = "github:TNAZEP/HytaleLauncherFlake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        # Define typed flake.modules option for the dendritic pattern
        (
          { lib, ... }:
          {
            options.flake.modules = lib.mkOption {
              type = lib.types.submodule {
                freeformType = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.raw);
              };
              default = { };
              description = "Dendritic aspect modules organized by class (nixos, homeManager)";
            };
          }
        )

        # mkNixos helper: builds a nixosConfiguration from collected aspects
        (
          {
            inputs,
            lib,
            config,
            ...
          }:
          {
            options.flake.lib = lib.mkOption {
              type = lib.types.lazyAttrsOf lib.types.raw;
              default = { };
            };

            config.flake.lib.mkNixos =
              system: name:
              {
                ${name} = inputs.nixpkgs.lib.nixosSystem {
                  modules = [
                    config.flake.modules.nixos.${name}
                    { nixpkgs.hostPlatform = lib.mkDefault system; }

                    # Pass shared args through _module.args (dendritic pattern)
                    {
                      _module.args = {
                        inherit inputs;
                        username = "neonvoid";
                        hostname = name;
                      };
                    }

                    # Base nixpkgs configuration
                    {
                      nixpkgs.config.allowUnfree = true;
                      nixpkgs.overlays = [
                        inputs.nur.overlays.default
                        inputs.nix-cachyos-kernel.overlays.pinned
                      ];
                    }

                    # External NixOS modules
                    inputs.spicetify-nix.nixosModules.default
                    inputs.sops-nix.nixosModules.sops
                    inputs.stylix.nixosModules.stylix

                    # Home-Manager integration
                    inputs.home-manager.nixosModules.home-manager
                    {
                      home-manager.backupFileExtension = "backup";
                      home-manager.backupCommand = "${
                        inputs.nixpkgs.legacyPackages.${system}.bash
                      }/bin/bash -c 'rm -f \"$1.backup\" && mv \"$1\" \"$1.backup\"' -- ";
                      home-manager.useGlobalPkgs = true;
                      home-manager.useUserPackages = true;

                      # Pass shared args into Home-Manager modules
                      home-manager.sharedModules = [
                        {
                          _module.args = {
                            inherit inputs;
                            username = "neonvoid";
                            hostname = name;
                            inherit (inputs) nix-index-database nix-versions;
                            nixvimOptions =
                              inputs.nixvim.packages.${system}.options-json
                              + /share/doc/nixos/options.json;
                          };
                        }
                        # External Home-Manager modules (imported here to avoid circular dependency)
                        inputs.spicetify-nix.homeManagerModules.default
                        inputs.nix-index-database.homeModules.default
                        inputs.noctalia.homeModules.default
                      ];
                    }
                  ];
                };
              };
          }
        )

        # Auto-discover all feature aspect modules
        (inputs.import-tree ./modules)
      ];
    };
}
