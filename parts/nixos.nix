# Provides options for declaring NixOS configurations.
# These configurations end up as flake outputs under `#nixosConfigurations."<name>"`.
{ lib, config, inputs, ... }:
{
  options.configurations.nixos = lib.mkOption {
    default = {};
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          module = lib.mkOption {
            type = lib.types.deferredModule;
            description = "The NixOS configuration module";
          };
          
          hostname = lib.mkOption {
            type = lib.types.str;
            description = "The hostname for this configuration";
          };
        };
      }
    );
    description = "NixOS system configurations";
  };

  config.flake.nixosConfigurations = lib.mapAttrs
    (name: cfg: 
      lib.nixosSystem {
        modules = [ cfg.module ];
        specialArgs = {
          inherit inputs;
          inherit (config) username;
          hostname = cfg.hostname;
        };
      }
    )
    config.configurations.nixos;
}
