{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    kitty-themes
    godot
    godotPackages.export-template
    proton-pass-cli
    ffmpeg
    kdePackages.plasma-workspace # TODO this is only for xembedsniproxy, which is annoying
  ];
}
