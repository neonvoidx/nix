{
  description = "The Void Hungers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur, ... }@inputs:
    let
      username = "neonvoid";
      specialArgs = {
        inherit inputs;
        inherit username;
      };

      mkHost = hostname:
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/${hostname}
            ./modules/noctalia.nix
            ./home/${username}/nixos.nix
            ./modules/network-drives.nix
            inputs.spicetify-nix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} =
                import ./home/${username}/home.nix;
            }
          ];
        };
    in {
      nixosConfigurations = {
        void = mkHost "void";
        voidframe = mkHost "voidframe";
      };
    };
}
