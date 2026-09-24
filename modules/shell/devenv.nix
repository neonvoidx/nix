{
  den,
  lib,
  ...
}:
{
  den.aspects.devenv.homeManager =
    { config, ... }:
    {
      programs.devenv = {
        enable = true;
        enableZshIntegration = true;
      };
      home.file.".config/devenv/config.yaml".text = lib.generators.toYAML { } {
        tui.statusline.enabled = true;
        version = 1;
      };
    };
}
