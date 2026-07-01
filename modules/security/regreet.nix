{ den, lib, ... }:
{
  den.aspects.regreet =
    { host, ... }:
    {
      nixos =
        { pkgs, config, ... }:
        let
          mkGreeterConfig = regreetPkg:
            pkgs.writeText "greeter-hyprland.lua" ''
              ${host.greeterMonitorConfig or "-- no monitor config"}

              hl.on("hyprland.start", function()
                hl.exec_cmd("${lib.getExe regreetPkg}; hyprctl dispatch exit")
              end)

              hl.config({
                misc = {
                  disable_hyprland_logo = true,
                  disable_splash_rendering = true,
                  disable_hyprland_guiutils_check = true,
                },
              })
            '';
        in
        {
          services.greetd.enable = true;

          programs.regreet = {
            enable = true;
            settings = {
              appearance.greeting_msg = host.greeting or "Welcome back!";
              GTK.application_prefer_dark_theme = true;
            };
          };

          services.greetd.settings.default_session.command =
            "${pkgs.dbus}/bin/dbus-run-session ${pkgs.hyprland}/bin/start-hyprland -- -c ${mkGreeterConfig config.programs.regreet.package}";

          security.pam.services.greetd.enableGnomeKeyring = true;
        };
    };
}
