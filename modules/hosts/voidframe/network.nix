{ ... }:
{
  flake.modules.nixos.voidframe = { ... }: {
    networking = {
      hostName = "voidframe";
      firewall.enable = false;
      useDHCP = true;
      wireless = {
        enable = true;
        userControlled = true;
        networks."LittyPitty".pskRaw = "654787ccc87bf9e3520e3cc82840cf1e3dd182a466e92a70d5f47ecd160501e0";
      };
    };
  };
}
