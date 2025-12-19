{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    kitty-themes
    github-copilot-cli
    proton-pass
    lazygit
    zoxide
    ffmpeg
    pay-respects
    tealdeer
  ];
}
