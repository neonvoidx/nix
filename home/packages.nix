{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    kitty-themes
    github-copilot-cli
    gh
    proton-pass
    lazygit
    zoxide
    ffmpeg
    pay-respects
    tealdeer
    fastfetch
  ];
}
