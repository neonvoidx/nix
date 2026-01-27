{ config, ... }:
{
  flake.modules.nixos.scopebuddy = { pkgs, ... }: {
    nixpkgs.overlays = [
      (final: prev: {
        scopebuddy = final.callPackage ../modules/programs/scopebuddy.nix { };
      })
    ];
  };
}
