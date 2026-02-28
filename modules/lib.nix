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
        # specialArgs passes flake-level values into all NixOS modules as first-class args
        specialArgs = {
          inherit inputs;
          username = "neonvoid";
        };
        modules = [
          # flake.modules.nixos.<name> is set as a freeform flake attribute by each host's
          # default.nix module — no typed option declaration needed (flake is freeform in flake-parts).
          config.flake.modules.nixos.${name}
          { nixpkgs.hostPlatform = lib.mkDefault system; }
        ];
      };
    };
}
