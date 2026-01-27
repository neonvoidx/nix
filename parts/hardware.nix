# Hardware configuration
{ config, ... }:
{
  flake.modules.nixos.hardware = { ... }: {
    imports = [
      ../../modules/hardware/default.nix
    ];
  };
}
