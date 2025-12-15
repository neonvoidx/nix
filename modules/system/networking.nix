{ ... }:
{
  networking = {
    enableIPv6 = false;
    firewall.enable = false;
    useNetworkd = true;
  };
}
