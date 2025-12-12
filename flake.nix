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
    nixCats = { url = "github:BirdeeHub/nixCats-nvim"; };
  };

  outputs = { self, nixpkgs, home-manager, nur, nixCats, ... }@inputs:
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
            { nixpkgs.config.allowUnfree = true; }
            ./hosts/${hostname}
            ./modules/noctalia.nix
            ./home/${username}/nixos.nix
            ./modules/network-drives.nix
            inputs.spicetify-nix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
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
