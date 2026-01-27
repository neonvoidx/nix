{ config, ... }:
{
  flake.modules.homeManager.mpv = { pkgs, lib, config, ... }: {
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
