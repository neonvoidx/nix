{ den, ... }:
{
  den.aspects.regreet =
    { host, ... }:
    {
      nixos =
        {
          pkgs,
          lib,
          ...
        }:
        {
          services.greetd = {
            enable = true;
            settings.default_session = {
              command = "${pkgs.hyprland}/bin/start-hyprland --config /etc/greetd/hyprland.conf";
              user = "greeter";
            };
          };

          programs.regreet = {
            enable = true;
            settings = {
              appearance = {
                greeting_msg = host.greeting or "Welcome back!";
              };
            };
          };

          # Minimal Hyprland config for the greeter session.
          # Launches regreet; exits Hyprland once regreet closes (user logged in).
          environment.etc."greetd/hyprland.conf".text = ''
            misc {
              disable_hyprland_logo = true
              disable_splash_rendering = true
              force_default_wallpaper = 0
            }

            animations {
              enabled = false
            }

            ${lib.optionalString (host.isMultiMonitor or false) ''
              monitor=DP-2,3440x1440@143.92,4880x1440,1.0,bitdepth,10, cm, hdr, sdrbrightness, 1.3, sdrsaturation, 0.93, vrr, 1
              monitor=DP-3,3440x1440@143.92,4880x0,1.0,bitdepth,10, cm, hdr, sdrbrightness, 1.3, sdrsaturation, 0.93, vrr, 1
              monitor=HDMI-A-1,2560x1440@59.95,3440x727,1.0
              monitor=HDMI-A-1,transform,1
            ''}
            ${lib.optionalString (host.isLaptop or false) ''
              monitor = eDP-1,2880x1920@120,0x0,1.33333
            ''}
            monitor = ,preferred,auto,1

            windowrule = match:class regreet, fullscreen on

            exec-once = ${lib.getExe pkgs.regreet} && hyprctl dispatch exit 0
          '';

          # Unlock gnome-keyring via greetd's PAM session
          security.pam.services.greetd.enableGnomeKeyring = true;
        };
    };
}
