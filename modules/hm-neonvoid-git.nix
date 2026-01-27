{ config, ... }:
{
  flake.modules.homeManager.neonvoid-git = { ... }: {
    programs.git = {
      settings = {
        user = {
          name = "neonvoidx";
          email = "me@neonvoid.dev";
        };
      };
    };
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
  };
}
