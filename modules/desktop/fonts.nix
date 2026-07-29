{ den, ... }:
{
  den.aspects.fonts.nixos =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        neonmono
        fira-sans
        roboto
        material-icons
        material-symbols
        nerd-fonts.symbols-only
        noto-fonts
        noto-fonts-color-emoji
        sn-pro
      ];
    };
}
