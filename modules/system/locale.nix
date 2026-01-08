{ pkgs, ... }:
{
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-118b.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
    # Using Stylix, leaving here for future if needed
    # colors = [
    #   "21222c"
    #   "7081d0"
    #   "f9515d"
    #   "f16c75"
    #   "37f499"
    #   "69F8B3"
    #   "e9f941"
    #   "f1fc79"
    #   "9071f4"
    #   "a48cf2"
    #   "f265b5"
    #   "FD92CE"
    #   "04d1f9"
    #   "66e4fd"
    #   "ebfafa"
    #   "ffffff"
    # ];
  };

  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/New_York";
}
