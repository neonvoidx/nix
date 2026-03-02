{ ... }:
{
  den.aspects.xserver.nixos = {
    services = {
      xserver = {
        enable = true;
        videoDrivers = [ "amdgpu" ];
      };
    };
  };
}
