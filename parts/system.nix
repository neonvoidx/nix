# Core system configuration (boot, users, locale, networking basics)
{ config, inputs, ... }:
{
  flake.modules.nixos.system = { pkgs, lib, ... }: {
    imports = [
      ../../modules/system/boot.nix
      ../../modules/system/users.nix
      ../../modules/system/overlays.nix
      ../../modules/system/systemd.nix
      ../../modules/system/locale.nix
      ../../modules/system/networking.nix
      ../../modules/programs/noctalia.nix
      ../../home/neonvoid/nixos.nix
    ];
  };
}
