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
        style = {
          backdrop = "212337";
          graphicalTerminal = {
            palette = "212337;f16c75;37f499;f1fc79;04d1f9;a48cf2;7081d0;ebfafa";
            brightPalette = "323449;f16c75;37f499;f1fc79;04d1f9;a48cf2;7081d0;ebfafa";
            background = "212337";
            foreground = "37f499";
            brightBackground = "323449";
            brightForeground = "37f499";
          };
        };
      };
    };
  };
}
