{ den, inputs, ... }:
{
  den.aspects.overlays.nixos =
    { ... }:
    {
      nixpkgs = {
        #NOTE: These are overlays, i.e patches etc to overwrite pkgs
        # these are usually just holdovers until PRs get merged and built
        # into nixos-unstable branch
        overlays = [
          # (final: prev: {
          #   pkgname = prev.pkgname.overrideAttrs (oldAttrs: {
          #   ...
          #   });
          # })
        ];
      };
    };
}
