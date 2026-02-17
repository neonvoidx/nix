{ pkgs, ... }:
{
  home.packages = with pkgs; [
    appimage-run
    ffmpeg
    godot
    godotPackages.export-template
    home-manager
    kitty-themes
    proton-pass
  ];
}
