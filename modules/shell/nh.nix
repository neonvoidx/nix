{ den, ... }:
{
  den.aspects.nh.homeManager =
    { ... }:
    {
      programs.nh = {
        enable = true;
        flake = "$HOME/nix";
        homeFlake = "$HOME/nix";
        osFlake = "$HOME/nix";
      };
    };
}
