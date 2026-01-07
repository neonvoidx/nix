{ pkgs, ... }:
{
  home.packages = with pkgs; [
    devenv
    home-manager
    kitty-themes
    godot
    proton-pass-cli
    ffmpeg
  ];
}
