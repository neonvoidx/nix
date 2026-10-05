{ den, inputs, ... }:
{
  den.aspects.nix-index.homeManager = {
    imports = [ inputs.nix-index-database.homeModules.default ];

    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
