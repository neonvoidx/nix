{
  inputs,
  lib,
  config,
  ...
}:
{
  systems = [ "x86_64-linux" ];

  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
    description = "Utility functions for building system configurations (e.g. mkNixos).";
  };

  config.flake.lib.mkNixos =
    system: name:
    {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          # flake.modules.nixos.<name> is set as a freeform flake attribute by each host's
          # default.nix module — no typed option declaration needed (flake is freeform in flake-parts).
          config.flake.modules.nixos.${name}
          { nixpkgs.hostPlatform = lib.mkDefault system; }

          {
            _module.args = {
              inherit inputs;
              username = "neonvoid";
              hostname = name;
            };
          }

          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [
              inputs.nur.overlays.default
              inputs.nix-cachyos-kernel.overlays.pinned
            ];
          }

          inputs.spicetify-nix.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          inputs.stylix.nixosModules.stylix

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.backupFileExtension = "backup";
            home-manager.backupCommand = "${
              inputs.nixpkgs.legacyPackages.${system}.bash
            }/bin/bash -c 'rm -f \"$1.backup\" && mv \"$1\" \"$1.backup\"' -- ";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

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
              inputs.spicetify-nix.homeManagerModules.default
              inputs.nix-index-database.homeModules.default
              inputs.noctalia.homeModules.default
            ];
          }
        ];
      };
    };
}
