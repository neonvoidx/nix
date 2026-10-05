{ den, inputs, ... }:
{
  den.aspects.nix-settings.nixos =
    {
      lib,
      pkgs,
      ...
    }:
    let
      caches = builtins.fromJSON (builtins.readFile ../../assets/nix/caches.json);
    in
    {
      nixpkgs = {
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
          ];
        };
      };
      nix = {
        gc = {
          automatic = lib.mkDefault true;
          dates = lib.mkDefault "daily";
          options = lib.mkDefault "--delete-older-than 5d";
        };
        settings = {
          nix-path = [ "nixpkgs=${inputs.nixpkgs}" ];
          # Push realised local builds into the personal Cachix cache.
          post-build-hook = pkgs.writeShellScript "push-to-neonvoidx-cachix" ''
            set -eu

            if ! command -v cachix >/dev/null 2>&1; then
              exit 0
            fi

            if [ -z "$OUT_PATHS" ]; then
              exit 0
            fi

            for path in $OUT_PATHS; do
              cachix push neonvoidx "$path"
            done
          '';
          # enable flakes
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          auto-optimise-store = true;
          inherit (caches) substituters trusted-public-keys;
          trusted-substituters = caches.substituters;
          trusted-users = [
            "root"
            "@wheel"
          ];
          allowed-users = [
            "root"
            "@wheel"
          ];
          connect-timeout = 10;
          stalled-download-timeout = 100;
          download-attempts = 5;
        };
      };

      # Log rebuild
      system.activationScripts.logRebuildTime = {
        text = ''
          LOG_FILE="/var/log/nixos-rebuild-log.json"
          TIMESTAMP=$(date "+%d/%m")
          GENERATION=$(readlink /nix/var/nix/profiles/system | grep -o '[0-9]\+')

          echo "{\"last_rebuild\": \"$TIMESTAMP\", \"generation\": $GENERATION}" > "$LOG_FILE"
          chmod 644 "$LOG_FILE"
        '';
      };
    };
}
