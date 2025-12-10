{ lib, pkgs, ... }: {
  programs.bat = {
    enable = true;
    themes = {
      src = builtins.fetchGit {
        url = "https://github.com/eldritch-theme/bat";
        ref = "master";
      };
      file = "Eldritch.tmTheme";
    };
  };
}
