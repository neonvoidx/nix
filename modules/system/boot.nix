{ pkgs, ... }:
{
  boot = {
    plymouth = {
      enable = true;
    };
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      limine = {
        enable = true;
        enableEditor = true;
        maxGenerations = 10;
        extraConfig = "hash_mismatch_panic: no";
      };
    };
  };
}
