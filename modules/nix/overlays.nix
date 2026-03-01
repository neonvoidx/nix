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
        # WAITING: https://nixpkgs-tracker.ocfox.me/?pr=493376
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
        # WAITING: remove once https://github.com/NixOS/nixpkgs/pull/493565 lands in nixos-unstable
        (final: prev: {
          deadlock-mod-manager = prev.deadlock-mod-manager.overrideAttrs (old: rec {
            version = "0.15.0";
            src = prev.fetchFromGitHub {
              owner = "deadlock-mod-manager";
              repo = "deadlock-mod-manager";
              tag = "v${version}";
              hash = "sha256-LHLDSB51f/Z8wt3chzR1fAZbZLVKlf2UvydbqlhI74Y=";
            };
            cargoDeps = prev.rustPlatform.fetchCargoVendor {
              inherit src;
              sourceRoot = "${src.name}/apps/desktop";
              hash = "sha256-YNPduSJT30Hu75vY9OubAeVsW5cV4PptD/RPNH5SCaY=";
            };
            pnpmDeps = prev.fetchPnpmDeps {
              inherit src;
              pname = "deadlock-mod-manager";
              inherit version;
              pnpm = final.pnpm_9;
              fetcherVersion = 2;
              sourceRoot = "source";
              hash = "sha256-SR5zeAWj280QtQKDgvIBE4Y1A14HJkvwDnatuJsDBGw=";
            };
          });
        })
      ];
    };
}
