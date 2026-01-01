{ lib, pkgs, config, nix-colors, ... }:
{
  programs.bat = {
    enable = true;
    config = { theme = "nix-${config.colorScheme.slug}"; };
    themes = {
      "nix-${config.colorScheme.slug}" = {
        src = (nix-colors.lib-contrib { inherit pkgs; }).textMateThemeFromScheme { 
          scheme = config.colorScheme;
        };
      };
    };
  };

  programs.zsh.shellAliases.bat = "bat";
}
