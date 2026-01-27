{ config, ... }:
{
  flake.modules.homeManager.direnv = { ... }: {
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
