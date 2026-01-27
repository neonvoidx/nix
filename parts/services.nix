# System services configuration
{ config, ... }:
{
  flake.modules.nixos.services = { ... }: {
    imports = [
      ../../modules/services/pipewire.nix
      ../../modules/services/desktop.nix
      ../../modules/services/pcscd.nix
      ../../modules/services/xserver.nix
      ../../modules/services/udev.nix
      ../../modules/services/greetd.nix
      ../../modules/services/network-drives.nix
      ../../modules/programs/hyprshutdown.nix
      ../../modules/programs/scopebuddy.nix
    ];
  };
}
