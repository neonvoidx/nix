{ den, ... }:
{
  den.aspects.boot.nixos = {
    boot = {
      plymouth.enable = true;
      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        timeout = 3;
        limine = {
          enable = true;
          enableEditor = true;
          maxGenerations = 10;
        };
      };
    };
  };
}
