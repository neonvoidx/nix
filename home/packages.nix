{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    kitty-themes
    godot
    proton-pass
    protonmail-desktop
    ffmpeg
  ];
}
