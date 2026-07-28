{ den, inputs, ... }:
{
  den.aspects.steam =
    { host, ... }:
    {
      nixos =
        { pkgs, ... }:
        let
          mainMon = host.monitors.main or { };
          builtinMon = host.monitors.builtin or { };

          primaryDisplay = mainMon.name or builtinMon.name or "";
        in
        {
          programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
            extraCompatPackages = with pkgs; [
              proton-ge-bin
            ];
          };
          environment.sessionVariables = {
            # Proton settings
            DXVK_HUD = "0";
            PROTON_ENABLE_HDR = "1";
            PROTON_USE_NTSYNC = "1";
            PROTON_FSR4_UPGRADE = "1";
            PROTON_XESS_UPGRADE = "1";
            # Disable mesh shaders — common cause of VKD3D ring timeouts on RDNA4
            RADV_DEBUG = "nomeshshader";
            # Disable upload heap host-visible VRAM — improves stability with VKD3D DX12 titles
            VKD3D_CONFIG = "no_upload_hvv";
            # Primary display for Proton Wayland driver
            WAYLANDDRV_PRIMARY_DISPLAY = primaryDisplay;
          };
        };

      homeManager =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            inputs.scopebuddy.packages.${pkgs.stdenv.hostPlatform.system}.default
            steam
            gamescope
            protontricks
            vulkan-tools
            sgdboop
            # if you want GTK theme style for Steam, requires manual running to apply
            # adwsteamgtk
          ];
        };
    };
}
