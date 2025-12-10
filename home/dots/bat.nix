{ lib, pkgs, ... }: {
  programs.bat = {
    enable = true;
    config = { theme = "Eldritch"; };
    themes = {
      src = pkgs.fetchFromGitHub {
        owner = "eldritch-theme";
        repo = "bat";
        rev = "33f8a2543f626637e8d85356e85bf32eee414f17";
        sha256 = "";
      };
      file = "Eldritch.tmTheme";
    };
  };
}
