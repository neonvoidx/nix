{ den, inputs, ... }:
{
  den.aspects.overlays.nixos =
    { ... }:
    {
      nixpkgs = {
        overlays = [
          # (final: _prev: {
          # })
        ];
      };
    };
}
