{ ... }:
{
  flake.modules.nixos.overlays =
    { inputs, ... }:
    {
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
