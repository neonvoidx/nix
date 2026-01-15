{
  description = "The Void Hungers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
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
    curseforge = {
      url = "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.AppImage";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nur,
      nixvim,
      spicetify-nix,
      stylix,
      nix-index-database,
      sops-nix,
      nix-versions,
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
              nix.extraOptions = ''
                connect-timeout = 10
                stalled-download-timeout = 100
                download-attempts = 5
              '';
            }
            ./hosts/${hostname}
            ./modules/programs/noctalia.nix
            ./home/${username}/nixos.nix
            spicetify-nix.nixosModules.default
            sops-nix.nixosModules.sops
            stylix.nixosModules.stylix
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
                  inherit nix-index-database;
                  inherit nix-versions;
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
            nixvimOptions = nixvim.packages.aarch64-darwin.options-json + /share/doc/nixos/options.json;
          };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [ nur.overlays.default ];
            }
            sops-nix.homeManagerModules.sops
            stylix.homeManagerModules.stylix
            ./home/${macUsername}/home.nix
          ];
        };
      };
    };
}
