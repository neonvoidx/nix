# Provides option for declaring standalone Home Manager configurations
# These configurations end up as flake outputs under `#homeConfigurations."<name>"`
{ lib, config, inputs, ... }:
{
  options.configurations.homeManager = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          module = lib.mkOption {
            type = lib.types.deferredModule;
          };
          system = lib.mkOption {
            type = lib.types.str;
          };
        };
      }
    );
    default = {};
  };

  config.flake.homeConfigurations = lib.flip lib.mapAttrs config.configurations.homeManager (
    name: { module, system }:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [ module ];
      }
  );
}
