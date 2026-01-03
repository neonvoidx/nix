{ pkgs, nixpkgs-vesktop, ... }:
{
  programs.vesktop = {
    enable = true;
    package = nixpkgs-vesktop.legacyPackages.${pkgs.stdenv.hostPlatform.system}.vesktop;
    settings = {
      discordBranch = "stable";
      minimizeToTray = true;
      tray = true;
    };
  };
}
