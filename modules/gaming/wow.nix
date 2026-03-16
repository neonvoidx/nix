{ den, inputs, ... }:
{
  den.aspects.wow =
    { host, ... }:
    {
      homeManager =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            wowup-cf
            inputs.warcraftlogs.packages.x86_64-linux.default
          ];

          xdg.mimeApps.defaultApplications = {
            "x-scheme-handler/curseforge" = "wowup-cf.desktop";
          };
        };
    };
}
