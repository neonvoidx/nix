{ den, ... }:
{
  den.aspects.fonts.nixos =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        fira-sans
        iosevka-custom # Custom Iosevka font -> look in overlays.nix
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
