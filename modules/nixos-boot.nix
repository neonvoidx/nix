{ config, ... }:
{
  flake.modules.nixos.boot = {
    boot = {
      plymouth = {
        enable = true;
      };
      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        timeout = 1;
        limine = {
          enable = true;
          enableEditor = true;
          maxGenerations = 10;
        };
      };
    };
  };
}
