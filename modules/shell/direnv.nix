{ den, lib, ... }:
{
  den.aspects.direnv.homeManager =
    { ... }:
    {
      programs = {
        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
          config = {
            whitelist = {
              prefix = [ "~/dev" ];
            };
          };
        };
      };
    };
}
