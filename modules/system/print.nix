{ ... }:
{
  flake.modules.nixos.print =
    { pkgs, ... }:
    {
      hardware.printers = {
        ensurePrinters = [
          {
            name = "HP_Color_LaserJet_MFP_M182nw";
            location = "Home";
            deviceUri = "ipps://192.168.86.186/ipp/print";
            model = "everywhere";
            ppdOptions.PageSize = "Letter";
          }
        ];
        ensureDefaultPrinter = "HP_Color_LaserJet_MFP_M182nw";
      };

      services.printing = {
        enable = true;
        drivers = with pkgs; [ hplipWithPlugin cups-filters ];
        browsing = true;
        logLevel = "warn";
      };

      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
}
