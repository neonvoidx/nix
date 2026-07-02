{ den, ... }:
{
  den.aspects.delta =
    { ... }:
    {
      homeManager =
        { config, ... }:
        let
          c = config.lib.stylix.colors;
        in
        {
          programs.delta = {
            enable = true;
            enableGitIntegration = true;
            enableJujutsuIntegration = true;
            options = {
              syntax-theme = "base16";
              line-numbers = true;
              side-by-side = true;
              navigate = true;
              plus-style = "syntax \"#${c.base0B}\"";
              minus-style = "syntax \"#${c.base08}\"";
              plus-emph-style = "syntax \"#${c.base0B}\"";
              minus-emph-style = "syntax \"#${c.base08}\"";
              line-numbers-plus-style = "#${c.base0B}";
              line-numbers-minus-style = "#${c.base08}";
              line-numbers-zero-style = "#${c.base03}";
            };
          };

        };
    };
}
