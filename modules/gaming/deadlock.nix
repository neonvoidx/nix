{ den, inputs, ... }:
{
  den.aspects.deadlock =
    { ... }:
    {
      homeManager =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            deadlock-mod-manager
          ];
        };
    };
}
