# NixOS module: Fonts configuration
{
  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      fira-sans
      roboto
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
      material-symbols
      material-icons
    ];
  };
}
