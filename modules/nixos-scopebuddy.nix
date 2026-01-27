{ config, ... }:
{
  flake.modules.nixos.scopebuddy = { pkgs, ... }: {
    nixpkgs.overlays = [
      (final: prev: {
        scopebuddy = final.callPackage ../modules-old/programs/scopebuddy.nix { };
      })
    ];
  };
}
