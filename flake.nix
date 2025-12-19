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
    # TODO
    # nix-cachyos-kernel = {
    #   url = "github:xddxdd/nix-cachyos-kernel";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      nixvim,
      spicetify-nix,
      ...
    }@inputs:
    let
      username = "neonvoid";
      specialArgs = {
        inherit inputs;
        inherit username;
      };

      mkHost =
        hostname:
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            { nixpkgs.config.allowUnfree = true; }
            ./hosts/${hostname}
            ./modules/programs/noctalia.nix
            ./home/${username}/nixos.nix
            spicetify-nix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              # nixpkgs.config.allowUnfree = true;
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs // specialArgs;
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

      # Standalone home-manager configuration for macOS
      homeConfigurations = {
        "${username}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Use x86_64-darwin for Intel Mac
          extraSpecialArgs = specialArgs;
          modules = [
            # { nixpkgs.config.allowUnfree = true; }
            ./home/${username}/home.nix
          ];
        };
      };
    };
}
