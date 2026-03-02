{ den, ... }:
{
  den.aspects.cava.homeManager =
    { config, ... }:
    {
      programs.cava = {
        enable = true;
        settings = {
          general.framerate = 60;
          input.method = "pipewire";
          smoothing.noise_reduction = 88;
        };
      };
    };
}
