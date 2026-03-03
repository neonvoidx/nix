{ den, ... }:
{
  den.aspects.nh.homeManager =
    { ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "-k 5";
        };
        flake = "$HOME/nix";
        homeFlake = "$HOME/nix";
        osFlake = "$HOME/nix";
      };
    };
}
