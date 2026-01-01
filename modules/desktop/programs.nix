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

  programs.gamemode = {
    enable = true;
    # Turn off renice, since we use ananicy-cpp
    enableRenice = false;
  };

  programs.streamcontroller.enable = true;

  programs.hyprland.enable = true;
  programs.dconf.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-dropbox-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };
}
