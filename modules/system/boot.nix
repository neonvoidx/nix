{ den, ... }:
{
  den.aspects.boot.nixos = {
    boot = {
      plymouth.enable = true;
      tmp = {
        cleanOnBoot = true;
      };
      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        timeout = 3;
        limine = {
          enable = true;
          maxGenerations = 10;
        };
      };
    };
  };
}
