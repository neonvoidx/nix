{ den, ... }:
{
  den.aspects.nixsettings =
    { user, ... }:
    {
      nixos =
        { lib, ... }:
        {
          nixpkgs = {
            config = {
              allowUnfree = true;
            };
          };
          nix = {
            gc = {
              automatic = lib.mkDefault true;
              dates = lib.mkDefault "daily";
              options = lib.mkDefault "--delete-older-than 5d";
            };
            settings = {
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
                "https://attic.xuyh0120.win/lantian"
                "https://hyprland.cachix.org"
              ];
              trusted-substituters = [
                # Official nix cache
                "https://cache.nixos.org"
                # Garnix
                "https://cache.garnix.io"
                # Nix Community Cache
                "https://nix-community.cachix.org"
                # nur
                "https://attic.xuyh0120.win/lantian"
                # hyprland cache
                "https://hyprland.cachix.org"
              ];
              trusted-public-keys = [
                # Official nix cache
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                # Garnix
                "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                # Nix community cache
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                # nur
                "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
                # hyprland cache
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              ];
              trusted-users = [
                "root"
                user.userName
                "@wheel"
              ];
              allowed-users = [
                "root"
                user.userName
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
    };
}
