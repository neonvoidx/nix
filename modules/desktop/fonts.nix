{ den, ... }:
{
  den.aspects.fonts.nixos =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        fira-sans
        jetbrains-mono
        material-icons
        material-symbols
        nerd-fonts.jetbrains-mono
        nerd-fonts.symbols-only
        noto-fonts
        noto-fonts-color-emoji
        roboto
        sn-pro
      ];
    };
}
