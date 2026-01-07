{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    kitty-themes
    godot
    # protonmail-bridge-gui
    proton-pass
    ffmpeg
  ];
}
