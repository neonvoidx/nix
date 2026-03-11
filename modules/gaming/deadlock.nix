{ den, inputs, ... }:
{
  den.aspects.deadlock =
    { host, ... }:
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
