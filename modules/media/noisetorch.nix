{ den, ... }:
{
  den.aspects.noisetorch =
    { ... }:
    {
      homeManager =
        { pkgs, ... }:
        {
          # NOTE: Follow this guide https://github.com/noisetorch/NoiseTorch/wiki/Start-automatically-with-Systemd
          # To get the values below, these are hardware specific so the below only works for `void` host
          # change to your hostname after following guide and updating values
          # This sets up a service to autorun noise cancellation on microphone
          # After it will create a virtual microphone, so you can select that NoiseTorch device in things like
          # OBS or Vesktop/discord
          systemd.user.services.noisetorch = {
            Unit = {
              Description = "NoiseTorch Noise Cancelling";
              Requires = "sys-devices-pci0000:00-0000:00:02.1-0000:05:00.0-0000:06:0c.0-0000:0f:00.0-usb3-3\\x2d8-3\\x2d8:1.0-sound-card2-controlC2.device";
              After = [
                "sys-devices-pci0000:00-0000:00:02.1-0000:05:00.0-0000:06:0c.0-0000:0f:00.0-usb3-3\\x2d8-3\\x2d8:1.0-sound-card2-controlC2.device"
                "pipewire.service"
              ];
            };
            Service = {
              Type = "simple";
              RemainAfterExit = true;
              ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i -s alsa_input.usb-R__DE_Microphones_R__DE_NT-USB_Mini_F5DF5DCC-00.mono-fallback -t 95";
              ExecStop = "${pkgs.noisetorch}/bin/noisetorch -u";
              Restart = "on-failure";
              RestartSec = 3;
            };
            Install = {
              WantedBy = [ "default.target" ];
            };
          };
        };
    };
}
