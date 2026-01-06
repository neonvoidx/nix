{ ... }:
{
  networking = {
    enableIPv6 = false;
    # Firewall disabled - consider enabling with appropriate rules for security
    # Or use per-host firewall configuration in host-specific files
    firewall.enable = false;
    useNetworkd = true;
  };

  systemd.network.wait-online = {
    timeout = 10;
    anyInterface = true;
  };
}
