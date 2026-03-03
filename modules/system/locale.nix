{ den, ... }:
{
  den.aspects.locale =
    { host, ... }:
    {
      nixos =
        { pkgs, ... }:
        {
          i18n.defaultLocale = "en_US.UTF-8";

          console = {
            earlySetup = true;
            font = "${pkgs.terminus_font}/share/consolefonts/ter-118b.psf.gz";
            packages = with pkgs; [ terminus_font ];
            keyMap = "us";
          };

          time.hardwareClockInLocalTime = true;
          time.timeZone = host.timezone;
        };
    };
}
