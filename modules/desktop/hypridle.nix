{ ... }:
{
  flake.modules.nixos.hypridle =
    { ... }:
    {
      services.hypridle.enable = true;
    };

  flake.modules.homeManager.hypridle =
    { ... }:
    {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "noctalia-shell ipc call lockScreen lock";
            before_sleep_cmd = "noctalia-shell ipc call lockScreen lock";
            after_sleep_cmd = "hyprctl dispatch dpms on && xrandr --output DP-2 --primary";
          };
          listener = [
            {
              timeout = 300;
              on-timeout = "noctalia-shell ipc call lockScreen lock";
            }
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
            }
            {
              timeout = 3600;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };
    };
}
