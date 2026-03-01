{ ... }:
{
  flake.modules.nixos.xserver = {
    services = {
      xserver = {
        enable = true;
        videoDrivers = [ "amdgpu" ];
      };
    };
  };
}
