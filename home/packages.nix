{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    kitty-themes
    godot
    proton-pass-cli
    proton-pass
    ffmpeg
  ];
}
