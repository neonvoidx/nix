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
        # TODO: remove once https://github.com/nixos/nixpkgs/pull/493376 lands in nixos-unstable
        (final: prev: {
          pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
            (_: pyPrev: {
              picosvg = pyPrev.picosvg.overridePythonAttrs (old: {
                patches = (old.patches or [ ]) ++ [
                  (final.fetchpatch {
                    url = "https://github.com/googlefonts/picosvg/commit/885ee64b75f526e938eb76e09fab7d93e946a355.patch";
                    hash = "sha256-fR3FfnEPHwSO1rMtmQEr1pyvByTx8T53FxSpuAKWIjw=";
                  })
                ];
              });
            })
          ];
        })
      ];
    };
}
