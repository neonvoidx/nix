{ den, ... }:
{
  den.aspects.wow.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wowup-cf
      ];

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/curseforge" = "wowup-cf.desktop";
        };
      };
    };
}
