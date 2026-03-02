{ den, ... }:
{
  den.aspects.mpv.homeManager =
    { ... }:
    {
      programs.mpv = {
        enable = true;
        config = {
          "gpu-context" = "waylandvk";
          "vo" = "gpu-next";
          "gpu-api" = "vulkan";
        };
      };
    };
}
