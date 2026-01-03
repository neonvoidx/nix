{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    kitty-themes
    gamemode
    github-copilot-cli
    godot
    proton-pass
    lazygit
    zoxide
    fzf
    ffmpeg
  ];
}
