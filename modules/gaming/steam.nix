{ den, inputs, ... }:
{
  den.aspects.steam =
    { host, ... }:
    {
      nixos =
        { pkgs, ... }:
        {
        programs.steam = {
          enable = true;
          protontricks.enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
        };
        environment.sessionVariables = {
          # Proton settings
          PROTON_ENABLE_WAYLAND = "1";
          PROTON_ENABLE_HDR = "1";
          PROTON_USE_NTSYNC = "1";
          PROTON_FSR4_UPGRADE = "1";
          PROTON_FSR4_RDNA3_UPGRADE = "1";
          PROTON_XESS_UPGRADE = "1";
        };
        };

      homeManager =
        { pkgs, ... }:
        {
          home.packages =
            with pkgs;
            [
              inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
              inputs.scopebuddy.packages.${pkgs.stdenv.hostPlatform.system}.default
              steam
              gamescope
              protontricks
              protonup-rs
              vulkan-tools
              sgdboop
            ]
            ++ pkgs.lib.optionals (host.hostName == "void") [
              deadlock-mod-manager
            ];
        };
    };
}
