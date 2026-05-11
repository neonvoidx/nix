{ den, inputs, ... }:
{
  den.aspects.wow =
    { ... }:
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
