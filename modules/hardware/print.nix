{ den, ... }:
{
  den.aspects.print =
    { host, ... }:
    {
      nixos =
        { pkgs, lib, ... }:
        let
          hasPrinter = host ? printerUri;
        in
        {
          hardware.printers = lib.mkIf hasPrinter {
            ensurePrinters = [
              {
                name = "HP_Color_LaserJet_MFP_M182nw";
                location = "Home";
                deviceUri = host.printerUri;
                model = "everywhere";
                ppdOptions = {
                  PageSize = "Letter";
                  ColorModel = "RGB";
                };
              }
            ];
            ensureDefaultPrinter = "HP_Color_LaserJet_MFP_M182nw";
          };

          systemd.services.cups-color-default = lib.mkIf hasPrinter {
            description = "Force color printing default for HP printer";
            after = [
              "cups.service"
              "cups-ensure-printers.service"
            ];
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
            listenAddresses = [ "127.0.0.1:631" ];
          };

          systemd.services."cups-ensure-printers" = lib.mkIf hasPrinter {
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            serviceConfig.Restart = lib.mkOverride 90 "on-failure";
            serviceConfig.RestartSec = lib.mkOverride 90 "30s";
          };

          services.avahi = {
            enable = true;
            nssmdns4 = true;
            openFirewall = true;
          };
        };
    };
}
