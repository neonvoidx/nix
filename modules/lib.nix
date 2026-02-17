{
  inputs,
  lib,
  config,
  ...
}:
{
  # Define helper function for creating nixosConfigurations
  options.flake.lib = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
  };

  config.flake.lib.mkNixos = system: name: {
    ${name} = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        config.flake.modules.nixos.${name}
        { nixpkgs.hostPlatform = lib.mkDefault system; }

        # Pass inputs and variables through _module.args (dendritic pattern)
        {
          _module.args = {
            inherit inputs;
            username = "neonvoid";
            hostname = name;
          };
        }

        # Base system configuration
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [
            inputs.nur.overlays.default
            inputs.nix-cachyos-kernel.overlays.pinned
          ];
        }

        # External modules
        inputs.spicetify-nix.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        inputs.stylix.nixosModules.stylix

        # Home-manager integration
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.backupFileExtension = "backup";
          home-manager.backupCommand = "${
            inputs.nixpkgs.legacyPackages.${system}.bash
          }/bin/bash -c 'rm -f \"$1.backup\" && mv \"$1\" \"$1.backup\"' -- ";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # Pass through _module.args to home-manager (dendritic pattern)
          home-manager.sharedModules = [
            {
              _module.args = {
                inherit inputs;
                username = "neonvoid";
                hostname = name;
                inherit (inputs) nix-index-database nix-versions;
                nixvimOptions = inputs.nixvim.packages.${system}.options-json + /share/doc/nixos/options.json;
              };
            }
            # Import external home-manager modules here to avoid circular dependency
            inputs.spicetify-nix.homeManagerModules.default
            inputs.nix-index-database.homeModules.default
            inputs.noctalia.homeModules.default
          ];
        }
      ];
    };
  };
}
