# Common nixpkgs configuration shared across all configurations
{ config, ... }:
{
  flake.modules.nixos.nixpkgs-config = { inputs, ... }: {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [ inputs.nur.overlays.default ];
    nix.extraOptions = ''
      connect-timeout = 10
      stalled-download-timeout = 100
      download-attempts = 5
    '';
  };
}
