{ den, inputs, ... }:
{
  den.aspects.wowup =
    { host, ... }:
    {
      homeManager =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            wowup-cf
          ];

          xdg.mimeApps.defaultApplications = {
            "x-scheme-handler/curseforge" = "wowup-cf.desktop";
          };
        };
    };
}
