{ den, ... }:
{
  den.aspects.limo = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          limo
        ];
      };
  };
}
