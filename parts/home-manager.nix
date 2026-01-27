# Provides options for declaring home-manager configurations.
# These configurations end up as flake outputs under `#homeConfigurations."<name>"`.
{ lib, config, inputs, ... }:
{
  options.configurations.home = lib.mkOption {
    default = {};
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          module = lib.mkOption {
            type = lib.types.deferredModule;
            description = "The home-manager configuration module";
          };
          
          username = lib.mkOption {
            type = lib.types.str;
            description = "The username for this home configuration";
          };
          
          system = lib.mkOption {
            type = lib.types.str;
            description = "The system architecture (e.g., aarch64-darwin)";
          };
        };
      }
    );
    description = "Standalone home-manager configurations";
  };

  config.flake.homeConfigurations = lib.mapAttrs
    (name: cfg:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${cfg.system};
        modules = [ cfg.module ];
        extraSpecialArgs = {
          inherit inputs;
          username = cfg.username;
        };
      }
    )
    config.configurations.home;
}
