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
            iosevka-custom = prev.runCommand "iosevka-custom" { } ''
              mkdir -p $out/share/fonts/truetype
              cp ${../../assets/fonts}/IosevkaCustom/*.ttf $out/share/fonts/truetype/
            '';
          })
          (final: prev: {
            nur = import inputs.nur {
              nurpkgs = prev;
              pkgs = prev;
            };
          })
          # The libaom-sys patch needs an updated directory path — cargo vendor
          # now uses a source-registry-0/ subdirectory that nixpkgs doesn't account for.
          # https://github.com/NixOS/nixpkgs/issues/475989
          (final: prev: {
            oculante = prev.oculante.overrideAttrs (oldAttrs: {
              patchFlags = [
                "-p1"
                "--directory=../${oldAttrs.pname}-${oldAttrs.version}-vendor/source-registry-0"
              ];
            });
          })
        ];
      };
    };
}
