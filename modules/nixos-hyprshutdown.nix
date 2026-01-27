{ config, ... }:
{
  flake.modules.nixos.hyprshutdown = { pkgs, ... }: {
    nixpkgs.overlays = [
      (final: prev: {
        hyprshutdown = final.callPackage ../modules-old/programs/hyprshutdown.nix { };
      })
    ];
  };
}
