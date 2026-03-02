{ ... }:
{
  den.aspects.obs-studio.homeManager =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs; [
          obs-studio-plugins.wlrobs
          obs-studio-plugins.obs-vaapi
        ];
      };
    };
}
