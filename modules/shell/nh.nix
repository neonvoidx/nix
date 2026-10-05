{ den, ... }:
{
  den.aspects.nh.homeManager =
    { config, ... }:
    {
      programs.nh = {
        enable = true;
        flake = config.dotfiles.checkoutPath;
        homeFlake = config.dotfiles.checkoutPath;
        osFlake = config.dotfiles.checkoutPath;
      };
    };
}
