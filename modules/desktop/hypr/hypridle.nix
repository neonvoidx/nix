{ den, ... }:
{
  den.aspects.hypridle.homeManager =
    { ... }:
    {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "noctalia msg screen-lock";
            before_sleep_cmd = "noctalia msg screen-lock"; # lock before suspend.
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 600; # 10min
              on-timeout = "noctalia msg screen-lock"; # lock screen when timeout has passed
            }
            {
              timeout = 900; # 15min
              on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
              on-resume = "hyprctl dispatch dpms on && brightnessctl -r "; # screen on when activity is detected after timeout has fired.
            }
            {
              timeout = 7200; # 1 hour
              on-timeout = "systemctl suspend"; # suspend pc
            }
          ];
        };
      };
    };
}
