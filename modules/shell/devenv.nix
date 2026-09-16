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
        package = config.multiverse.pinned.devenv;
        enableZshIntegration = true;
      };
      home.file.".config/devenv/config.yaml".text = lib.generators.toYAML { } {
        tui.statusline.enabled = false;
        version = 1;
      };
    };
}
