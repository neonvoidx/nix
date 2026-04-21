{ den, ... }:
{
  den.aspects.fonts.nixos =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        iosevka-custom # Custom Iosevka font -> look in overlays.nix
        fira-sans
        material-icons
        material-symbols
        nerd-fonts.symbols-only
        noto-fonts
        noto-fonts-color-emoji
        roboto
        sn-pro
      ];
    };
}
