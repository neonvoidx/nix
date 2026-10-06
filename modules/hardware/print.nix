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
        in
        {
          hardware.printers = lib.mkIf hasPrinter {
            ensurePrinters = [
              (builtins.removeAttrs printer [ "drivers" ])
            ];
            ensureDefaultPrinter = printer.name;
          };

          services.printing = {
            enable = true;
            drivers = map (name: pkgs.${name}) (printer.drivers or [ "cups-filters" ]);

            logLevel = "warn";
            listenAddresses = [ "127.0.0.1:631" ];
          };

          # Since nixpkgs 26.11, hardware.printers.ensurePrinters runs as
          # cups.service's ExecStartPost instead of a separate
          # cups-ensure-printers unit (which no longer exists).
          systemd.services.cups = lib.mkIf hasPrinter {
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            # The provisioning script runs with `set -e` and lpadmin fails
            # whenever the printer is unreachable, which would otherwise fail
            # cups.service five times and leave CUPS down until something
            # pokes cups.socket. Run the upstream commands without errexit and
            # always report success; failures are still logged by lpadmin.
            postStart = lib.mkMerge [
              (lib.mkBefore "set +e")
              (lib.mkAfter "true")
            ];
          };

          services.avahi = {
            enable = true;
            nssmdns4 = true;
            openFirewall = true;
          };
        };
    };
}
