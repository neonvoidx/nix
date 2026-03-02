{ den, ... }:
{
  den.aspects.direnv.homeManager =
    { ... }:
    {
      programs = {
        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };
      };
      home.file.".config/direnv/direnv.toml".text = ''
        [whitelist]
        prefix = ["~/dev"]
      '';
    };
}
