{ den, ... }:
{
  den.aspects.steam =
    { host, ... }:
    {
      nixos =
        { lib, ... }:
        let
          primaryDisplay =
            (lib.findFirst (monitor: monitor.primary or false) { name = ""; } (
              builtins.attrValues (host.monitors or { })
            )).name;
        in
        {
          programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
            # extraCompatPackages = with pkgs; [
            # proton-ge-bin
            # ];
          };
          environment.sessionVariables = {
            # Proton settings
            DXVK_HUD = "0";
            PROTON_USE_NTSYNC = "1";
          }
          // lib.optionalAttrs (primaryDisplay != "") {
            # Primary display for Proton Wayland driver
            WAYLANDDRV_PRIMARY_DISPLAY = primaryDisplay;
          }
          // (host.gaming.environment or { });
        };

      homeManager =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            steam
            gamescope
            protontricks
            vulkan-tools
            sgdboop
            protonplus
            # if you want GTK theme style for Steam, requires manual running to apply
            # adwsteamgtk
          ];
        };
    };
}
