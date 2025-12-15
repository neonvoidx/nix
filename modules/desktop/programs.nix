{ pkgs, ... }:
{
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.hyprland.enable = true;
  programs.dconf.enable = true;
}
