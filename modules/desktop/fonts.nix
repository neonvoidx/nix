{ den, inputs, ... }:
{
  den.aspects.fonts.nixos =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        (inputs.neonmono.packages.${pkgs.stdenv.hostPlatform.system}.default)
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
