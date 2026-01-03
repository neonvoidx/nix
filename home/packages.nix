{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    kitty-themes
    gamemode
    godot
    proton-pass
    ffmpeg
  ];
}
