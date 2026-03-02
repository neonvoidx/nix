{ den, ... }:
{
  den.aspects.networking.nixos = {
    networking = {
      enableIPv6 = false;
      firewall.enable = false;
      useNetworkd = true;
    };

    systemd.network.wait-online = {
      timeout = 10;
      anyInterface = true;
    };
  };
}
