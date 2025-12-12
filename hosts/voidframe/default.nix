{ lib, inputs, pkgs, ... }:

{
  imports = [ /etc/nixos/hardware-configuration.nix ../common.nix ];

  networking = {
    hostName = "voidframe";
    firewall.enable = false;

    useDHCP = lib.mkDefault true;
    wireless = {
      enable = true;
      userControlled.enable = true;
      networks."LittyPitty".pskRaw =
        "654787ccc87bf9e3520e3cc82840cf1e3dd182a466e92a70d5f47ecd160501e0";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot = {
    loader = {
      # TODO GRUB 
      #  efi = {
      #    canTouchEfiVariables = true;
      #    efiSysMountPoint = "/boot/efi";
      #  };
      #  grub = {
      #    efiSupport = true;
      #    device = "nodev";
      #    enable=true;
      #    useOSProber = true;
      #  };
      #};
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
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

