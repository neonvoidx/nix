{ den, ... }:
{
  den.aspects.fonts.nixos =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        neonmono
        monolisa
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
