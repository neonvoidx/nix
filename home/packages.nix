{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    kitty-themes
    gamemode
    github-copilot-cli
    proton-pass
    lazygit
    zoxide
    fzf
    ffmpeg
    pay-respects
    tealdeer
  ];
}
