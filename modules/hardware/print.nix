{ den, ... }:
{
  den.aspects.print =
    { host, ... }:
    {
      nixos =
        { pkgs, lib, ... }:
        let
          hasPrinter = host ? printer;
          printer = host.printer or { };
          options = printer.ppdOptions or { };
          optionArgs = lib.concatStringsSep " " (
            lib.mapAttrsToList (name: value: "-o ${lib.escapeShellArg "${name}=${value}"}") options
          );
        in
        {
          hardware.printers = lib.mkIf hasPrinter {
            ensurePrinters = [
              (builtins.removeAttrs printer [ "drivers" ])
            ];
            ensureDefaultPrinter = printer.name;
          };

          systemd.services.cups-printer-defaults = lib.mkIf (hasPrinter && options != { }) {
            description = "Apply configured printer defaults";
            after = [
              "cups.service"
              "cups-ensure-printers.service"
            ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.cups}/bin/lpadmin -p ${lib.escapeShellArg printer.name} ${optionArgs}";
            };
          };

          services.printing = {
            enable = true;
            drivers = map (name: pkgs.${name}) (printer.drivers or [ "cups-filters" ]);

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
