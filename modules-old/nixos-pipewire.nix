# NixOS module: Pipewire audio configuration
{
  flake.modules.nixos.pipewire = {
    services.pipewire = {
      enable = true;
      audio.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber = {
        enable = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    security.rtkit.enable = true;
  };
}
