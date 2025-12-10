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
    nixvim.url = "github:nix-community/nixvim";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, nur, nixvim, ... }@inputs: {
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
          inputs.spicetify-nix.nixosModules.default

          inputs.home-manager.nixosModules.home-manager
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
