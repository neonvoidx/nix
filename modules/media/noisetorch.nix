{ ... }:
{
  den.aspects.noisetorch.nixos =
    { pkgs, ... }:
    {
      # Replace broken NoiseTorch systemd service (module-ladspa-source not
      # supported by PipeWire 1.6.5 pipewire-pulse) with PipeWire's native
      # filter-chain RNNoise noise cancellation. Creates a virtual "Noise
      # Canceling source" Audio/Source node visible to all applications.
      services.pipewire.extraConfig.pipewire = {
        "10-rnnoise-source" = {
          "context.modules" = [
            {
              name = "libpipewire-module-filter-chain";
              flags = [ "nofail" ];
              args = {
                node.description = "Noise Canceling source";
                media.name = "Noise Canceling source";
                filter.graph = {
                  nodes = [
                    {
                      type = "ladspa";
                      name = "rnnoise";
                      plugin = "${pkgs.rnnoise-plugin.ladspa}/lib/ladspa/librnnoise_ladspa";
                      label = "noise_suppressor_mono";
                      control = {
                        "VAD Threshold (%)" = 50.0;
                      };
                    }
                  ];
                };
                audio.position = [ "FL" "FR" ];
                capture.props = {
                  node.name = "effect_input.rnnoise";
                  node.passive = true;
                };
                playback.props = {
                  node.name = "effect_output.rnnoise";
                  media.class = "Audio/Source";
                };
              };
            }
          ];
        };
      };
    };
}
