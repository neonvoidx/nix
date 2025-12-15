{ ... }:
{
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
  };
}
