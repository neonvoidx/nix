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
          config.flake.modules.nixos.${name}
          { nixpkgs.hostPlatform = lib.mkDefault system; }
        ];
      };
    };
}
