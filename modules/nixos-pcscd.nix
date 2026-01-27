{ config, ... }:
{
  flake.modules.nixos.pcscd = {
    services.pcscd = {
      enable = true;
    };
  };
}
