{ lib, pkgs, ... }: {
  programs.bat = {
    enable = true;
    config = { theme = "Eldritch"; };
    themes = {
      Eldritch = {
        src = pkgs.fetchFromGitHub {
          owner = "eldritch-theme";
          repo = "bat";
          rev = "33f8a2543f626637e8d85356e85bf32eee414f17";
          sha256 = "sha256-zZbe3eFxG/cC6s6vOnDvpVkDysCg+PkK5Uunr9oVGrU=";
        };
        file = "Eldritch.tmTheme";
      };
    };
  };

  programs.zsh.shellAliases.bat = "bat";
}
