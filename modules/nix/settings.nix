{ den, inputs, ... }:
{
  den.aspects.nixsettings.nixos =
    {
      lib,
      pkgs,
      ...
    }:
    {
      nixpkgs = {
        config = {
          allowUnfree = true;
          # https://github.com/NixOS/nixpkgs/issues/535580
          permittedInsecurePackages = [
            "pnpm-10.29.2" # Waiting for https://nixpkgs-tracker.ocfox.me/?pr=536660 hydra merge
            "pnpm-10.34.0" # nvim config depends on it for now
            "electron-39.8.10" # waiting for bitwarden update
          ];
        };
      };
      nix = {
        nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
        gc = {
          automatic = lib.mkDefault true;
          dates = lib.mkDefault "daily";
          options = lib.mkDefault "--delete-older-than 5d";
        };
        settings = {
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
          substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            "https://cache.garnix.io"
            "https://hyprland.cachix.org"
            "https://neonvoidx.cachix.org"
            "https://noctalia.cachix.org"
          ];
          trusted-substituters = [
            # Official nix cache
            "https://cache.nixos.org"
            # Garnix
            "https://cache.garnix.io"
            # Nix Community Cache
            "https://nix-community.cachix.org"
            # hyprland cache
            "https://hyprland.cachix.org"
            # Personal Cachix cache
            "https://neonvoidx.cachix.org"
            # Noctalia
            "https://noctalia.cachix.org"
          ];
          trusted-public-keys = [
            # Official nix cache
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            # Personal Cachix cache
            "neonvoidx.cachix.org-1:nHFGhvzWqULuNWFbuPwTP0eUW+k7utl0chxXhUJhU1Y="
            # Garnix
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
            # Nix community cache
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            # hyprland cache
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            # Noctalia
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
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
