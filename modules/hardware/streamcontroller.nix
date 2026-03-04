{ den, ... }:
{
  den.aspects.streamcontroller = {
    homeManager =
      { pkgs, ... }:
      {
        systemd.user.services.streamcontroller = {
          Unit = {
            Description = "StreamController";
            After = [ "hyprland-session.target" ];
            PartOf = [ "hyprland-session.target" ];
          };
          Service = {
            ExecStart = "${pkgs.streamcontroller}/bin/streamcontroller -b";
            Restart = "on-failure";
            RestartSec = 5;
          };
          Install = {
            WantedBy = [ "hyprland-session.target" ];
          };
        };
      };

    nixos =
      { ... }:
      {
        programs.streamcontroller.enable = true;
        services = {
          udev.extraRules = ''
            # Stream deck - official StreamController udev rules
            SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0063", TAG+="uaccess"
            SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0090", TAG+="uaccess"
            SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0060", TAG+="uaccess"
            SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006d", TAG+="uaccess"
            SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006c", TAG+="uaccess"
            SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="008f", TAG+="uaccess"
            SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0080", TAG+="uaccess"
            SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0084", TAG+="uaccess"
            SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0086", TAG+="uaccess"
            SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="009a", TAG+="uaccess"
            SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="00a5", TAG+="uaccess"
          '';
        };
      };
  };
}
