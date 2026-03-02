{ den, ... }:
{
  den.aspects.nix-settings =
    { user, ... }:
    {
      nixos =
        { lib, ... }:
        {
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
                "https://cache.nixos.org"
                "https://nix-community.cachix.org"
                "https://cache.garnix.io"
                "https://attic.xuyh0120.win/lantian"
                "https://hyprland.cachix.org"
              ];
              trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
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
        };
    };
}
