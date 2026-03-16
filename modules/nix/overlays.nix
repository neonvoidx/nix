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
          inputs.nix-cachyos-kernel.overlays.pinned
          (final: prev: {
            nur = import inputs.nur {
              nurpkgs = prev;
              pkgs = prev;
            };
            # Temp fix for https://github.com/NixOS/nixpkgs/issues/500198
            github-copilot-cli = prev.github-copilot-cli.overrideAttrs (oldAttrs: {
              postInstall = "";
            });
          })
        ];
      };
    };
}
