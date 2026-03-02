{ den, inputs, ... }:
{
  den.aspects.overlays.nixos =
    { ... }:
    {
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          inputs.nix-cachyos-kernel.overlays.pinned
          (final: prev: {
            nur = import inputs.nur {
              nurpkgs = prev;
              pkgs = prev;
            };
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
    };
}
