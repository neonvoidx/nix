{ config, inputs, ... }:
{
  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [
      (final: prev: {
        nur = import inputs.nur {
          nurpkgs = prev;
          pkgs = prev;
        };
      })
    ];
  };
}
