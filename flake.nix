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
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      void = let
        username = "neonvoid";
        specialArgs = {
          inherit inputs;
          inherit username;
        };
      in nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/void
          ./modules/noctalia.nix
          ./home/${username}/nixos.nix
          ./modules/network-drives.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.${username} = import ./home/${username}/home.nix;
          }
        ];
      };
    };
  };
}
