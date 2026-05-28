{ den, ... }:
{
  den.aspects.fonts.nixos =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        fira-sans
        neonmono
        material-icons
        material-symbols
        nerd-fonts.symbols-only
        noto-fonts
        noto-fonts-color-emoji
        sn-pro
      ];
    };
}
