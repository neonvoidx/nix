{ config, lib, ... }:
{
  flake.modules.nixos.nix-settings = { username, ... }: {
    nix = {
      gc = {
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "daily";
        options = lib.mkDefault "--delete-older-than 5d";
      };
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://cache.garnix.io"
        ];
        trusted-users = [
          "root"
          username
          "@wheel"
        ];
        allowed-users = [
          "root"
          username
          "@wheel"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };
  };
}
