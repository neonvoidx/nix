{ den, ... }:
{
  den.aspects.eza.homeManager =
    { ... }:
    {
      programs.eza = {
        enable = true;
        enableZshIntegration = false;
        colors = "auto";
        icons = "always";
      };

      programs.zsh.shellAliases = {
        ls = "eza";
        l = "eza -Al";
        lt = "eza --tree --ignore-glob=node_modules";
        lc = "eza --code";
      };
    };
}
