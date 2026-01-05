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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
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
    nvim-config = {
      url = "git+ssh://git@github.com/neonvoidx/nvim.git";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      nixvim,
      nixCats,
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
                  nixvimOptions = nixvim.packages.x86_64-linux.options-json + /share/doc/nixos/options.json;
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
            nixvimOptions = nixvim.packages.aarch64-darwin.options-json + /share/doc/nixos/options.json;
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
    };
}
