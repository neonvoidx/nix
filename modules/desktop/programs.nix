{ ... }:
{
  flake.modules.nixos.desktop-programs =
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

      programs.streamcontroller.enable = true;
      programs.dconf.enable = true;
    };
}
