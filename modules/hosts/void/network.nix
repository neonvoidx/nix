{ ... }:
{
  den.aspects.void.nixos = { ... }: {
    networking = {
      hostName = "void";
      nameservers = [
        "192.168.86.7"
        "192.168.86.8"
      ];
      wireless.enable = false;
      networkmanager.enable = false;
      interfaces.eth0 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.86.20";
            prefixLength = 24;
          }
        ];
      };
      defaultGateway = {
        address = "192.168.86.1";
        interface = "eth0";
      };
    };

    systemd.network = {
      links."10-eth0" = {
        matchConfig.MACAddress = "9c:6b:00:98:96:96";
        linkConfig.Name = "eth0";
      };
      wait-online.anyInterface = true;
    };
  };
}
