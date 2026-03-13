{ den, inputs, ... }:
{
  den.aspects.wowup =
    { host, ... }:
    {
      homeManager =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            wowup-cf
          ];
        };
    };
}
