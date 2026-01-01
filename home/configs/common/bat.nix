{ lib, pkgs, config, nix-colors, ... }:
let
  themeFile = (nix-colors.lib-contrib { inherit pkgs; }).textMateThemeFromScheme { 
    scheme = config.colorScheme;
  };
  themeName = "nix-${config.colorScheme.slug}";
  themeDir = pkgs.runCommand "${themeName}-bat-theme" {} ''
    mkdir -p $out
    cp ${themeFile} $out/${themeName}.tmTheme
  '';
in
{
  programs.bat = {
    enable = true;
    config = { theme = themeName; };
    themes = {
      "${themeName}" = {
        src = themeDir;
        file = "${themeName}.tmTheme";
      };
    };
  };

  programs.zsh.shellAliases.bat = "bat";
}
