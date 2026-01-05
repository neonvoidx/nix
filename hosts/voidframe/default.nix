{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  networking = {
    hostName = "voidframe";
    firewall.enable = false;

    useDHCP = lib.mkDefault true;
    wireless = {
      enable = true;
      userControlled = true;
      networks."LittyPitty".pskRaw = "654787ccc87bf9e3520e3cc82840cf1e3dd182a466e92a70d5f47ecd160501e0";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot = {
    loader = {
      limine = {
        style = {
          interface = {
            resolution = lib.mkDefault "2880x1920";
          };
        };
      };
    };

    initrd.luks.devices."luks-7970f8ae-ec08-42a6-a7f9-f8bbb448589f" = {
      device = "/dev/disk/by-uuid/7970f8ae-ec08-42a6-a7f9-f8bbb448589f";
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  };

  # Prevent rfkill from softblocking bluetooth and wifi
  systemd.services.rfkill-unblock = {
    description = "Unblock rfkill devices";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock all";
    };
  };

  system.stateVersion = "25.11";
}
