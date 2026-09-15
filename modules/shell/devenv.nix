{ den, lib, ... }:
{
  den.aspects.devenv.homeManager =
    { ... }:
    {
      programs.devenv = {
        enable = true;
        enableZshIntegration = true;
      };
      home.file.".config/devenv/config.yaml" = lib.generators.toYAML { } {
        tui.statusline.enabled = false;
      };
    };
}
