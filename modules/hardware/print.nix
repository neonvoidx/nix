{ den, ... }:
{
  den.aspects.print.nixos =
    { pkgs, ... }:
    {
      hardware.printers = {
        ensurePrinters = [
          {
            name = "HP_Color_LaserJet_MFP_M182nw";
            location = "Home";
            deviceUri = "ipps://192.168.86.186/ipp/print";
            model = "everywhere";
            ppdOptions = {
              PageSize = "Letter";
              ColorModel = "RGB";
            };
          }
        ];
        ensureDefaultPrinter = "HP_Color_LaserJet_MFP_M182nw";
      };

      systemd.services.cups-color-default = {
        description = "Force color printing default for HP printer";
        after = [ "cups.service" "cups-ensure-printers.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.cups}/bin/lpadmin -p HP_Color_LaserJet_MFP_M182nw -o ColorModel=RGB";
        };
      };

      services.printing = {
        enable = true;
        drivers = with pkgs; [
          hplipWithPlugin
          cups-filters
        ];

        logLevel = "warn";
      };

      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
}
